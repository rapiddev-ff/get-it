-- GT-122: Fix create_checkout_order to accept Stripe payment method ID
-- The client sends Stripe pm_xxx IDs, not internal UUIDs.
-- Changed p_payment_method_id from UUID to TEXT, and lookup the internal UUID.

DROP FUNCTION IF EXISTS public.create_checkout_order(uuid, integer, uuid, uuid, text, uuid);

CREATE OR REPLACE FUNCTION public.create_checkout_order(
    p_product_id uuid,
    p_quantity integer DEFAULT 1,
    p_shipping_address_id uuid DEFAULT NULL,
    p_payment_method_id text DEFAULT NULL,
    p_buyer_notes text DEFAULT NULL,
    p_shortlist_id uuid DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public', 'pg_temp'
AS $function$
DECLARE
    v_buyer_id UUID := auth.uid();
    v_product RECORD;
    v_seller_id UUID;
    v_address RECORD;
    v_subtotal NUMERIC(10,2);
    v_shipping_cost NUMERIC(10,2);
    v_tax_amount NUMERIC(10,2);
    v_platform_fee NUMERIC(10,2);
    v_total_amount NUMERIC(10,2);
    v_effective_price NUMERIC(10,2);
    v_order_id UUID;
    v_order_number TEXT;
    v_address_snapshot JSONB;
    v_can_purchase BOOLEAN;
    v_settings RECORD;
    v_tax_rate NUMERIC := 0.08;
    v_platform_fee_rate NUMERIC := 0.01;
    v_internal_pm_id UUID;
BEGIN
    -- 1. Auth
    IF v_buyer_id IS NULL THEN
        RAISE EXCEPTION 'Authentication required';
    END IF;

    -- 2. Product with lock
    SELECT * INTO v_product
    FROM products
    WHERE id = p_product_id AND deleted_at IS NULL
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Product not found';
    END IF;

    IF v_product.status != 'active' THEN
        RAISE EXCEPTION 'Product is not available for purchase (status: %)', v_product.status;
    END IF;

    IF v_product.quantity < p_quantity THEN
        RAISE EXCEPTION 'Insufficient stock. Available: %, Requested: %', v_product.quantity, p_quantity;
    END IF;

    v_seller_id := v_product.seller_id;

    -- 3. Can purchase check
    v_can_purchase := can_user_purchase(v_buyer_id, p_product_id);
    IF NOT v_can_purchase THEN
        RAISE EXCEPTION 'You cannot purchase this product';
    END IF;

    -- 4. Budget settings
    SELECT * INTO v_settings
    FROM user_settings
    WHERE user_id = v_buyer_id;

    -- 5. Effective price (flash sale)
    IF v_product.flash_sale_enabled = TRUE
       AND v_product.flash_sale_price IS NOT NULL
       AND v_product.flash_sale_ends_at > NOW() THEN
        v_effective_price := v_product.flash_sale_price;
    ELSE
        v_effective_price := v_product.price;
    END IF;

    -- 6. Calculate totals
    v_subtotal := v_effective_price * p_quantity;
    v_shipping_cost := calculate_product_shipping(p_product_id, p_quantity);
    v_tax_amount := ROUND(v_subtotal * v_tax_rate, 2);
    v_platform_fee := ROUND(v_subtotal * v_platform_fee_rate, 2);
    v_total_amount := v_subtotal + v_shipping_cost + v_tax_amount + v_platform_fee;

    -- 7. Daily budget check
    IF v_settings IS NOT NULL
       AND v_settings.swipe_payment_enabled = TRUE
       AND v_settings.daily_budget > 0 THEN
        IF v_settings.budget_reset_at IS NULL OR v_settings.budget_reset_at < DATE_TRUNC('day', NOW()) THEN
            UPDATE user_settings
            SET daily_budget_used = 0, budget_reset_at = DATE_TRUNC('day', NOW())
            WHERE user_id = v_buyer_id;
            v_settings.daily_budget_used := 0;
        END IF;

        IF (v_settings.daily_budget_used + v_total_amount) > v_settings.daily_budget THEN
            RAISE EXCEPTION 'Daily budget exceeded. Budget: %, Used: %, Order: %',
                v_settings.daily_budget, v_settings.daily_budget_used, v_total_amount;
        END IF;
    END IF;

    -- 8. Address snapshot
    IF p_shipping_address_id IS NOT NULL THEN
        SELECT * INTO v_address
        FROM shipping_addresses
        WHERE id = p_shipping_address_id AND user_id = v_buyer_id AND deleted_at IS NULL;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Shipping address not found';
        END IF;

        v_address_snapshot := jsonb_build_object(
            'full_name', v_address.full_name,
            'address_line1', v_address.address_line1,
            'address_line2', v_address.address_line2,
            'city', v_address.city,
            'state', v_address.state,
            'zip_code', v_address.zip_code,
            'country', v_address.country,
            'phone', v_address.phone
        );
    END IF;

    -- 8b. Resolve payment method: accept either Stripe ID (pm_xxx) or internal UUID
    IF p_payment_method_id IS NOT NULL AND p_payment_method_id != '' THEN
        IF p_payment_method_id LIKE 'pm_%' THEN
            SELECT pm.id INTO v_internal_pm_id
            FROM payment_methods pm
            WHERE pm.stripe_payment_method_id = p_payment_method_id
              AND pm.user_id = v_buyer_id
              AND pm.deleted_at IS NULL;
        ELSE
            v_internal_pm_id := p_payment_method_id::uuid;
        END IF;
    END IF;

    -- 9. Create order
    INSERT INTO orders (
        buyer_id, seller_id, subtotal, shipping_cost, tax_amount,
        platform_fee, total_amount, shipping_address_id,
        shipping_address_snapshot, payment_method_id, buyer_notes,
        shortlist_id, status
    ) VALUES (
        v_buyer_id, v_seller_id, v_subtotal, v_shipping_cost, v_tax_amount,
        v_platform_fee, v_total_amount, p_shipping_address_id,
        v_address_snapshot, v_internal_pm_id, p_buyer_notes,
        p_shortlist_id, 'pending'
    )
    RETURNING id, order_number INTO v_order_id, v_order_number;

    -- 10. Order item
    INSERT INTO order_items (order_id, product_id, product_title, product_price, quantity)
    VALUES (v_order_id, p_product_id, v_product.title, v_effective_price, p_quantity);

    -- 11. Result
    RETURN jsonb_build_object(
        'success', true,
        'order_id', v_order_id,
        'order_number', v_order_number,
        'subtotal', v_subtotal,
        'shipping_cost', v_shipping_cost,
        'tax_amount', v_tax_amount,
        'platform_fee', v_platform_fee,
        'total_amount', v_total_amount
    );
END;
$function$;
