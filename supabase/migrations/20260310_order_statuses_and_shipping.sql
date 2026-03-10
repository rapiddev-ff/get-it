-- ============================================================================
-- GT-65 Orders Epic: Order Statuses, Shipping Management, Earnings
-- Depends on: 20260310_01_add_sale_pending_enum.sql (must be committed first)
-- ============================================================================


-- ============================================================================
-- 1. Add seller cancellation columns to orders table
-- ============================================================================

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS seller_cancel_reason text,
  ADD COLUMN IF NOT EXISTS seller_cancel_reason_text text;

-- Index for auto-confirm cron (sale_pending orders older than 5 min)
CREATE INDEX IF NOT EXISTS idx_orders_sale_pending
  ON public.orders (created_at)
  WHERE status = 'sale_pending' AND deleted_at IS NULL AND cancelled_at IS NULL;

-- Index for delivery tracking cron (shipped orders with tracking)
CREATE INDEX IF NOT EXISTS idx_orders_shipped_tracking
  ON public.orders (id)
  WHERE status = 'shipped' AND tracking_number IS NOT NULL AND deleted_at IS NULL;

-- Index for seller earnings/orders queries
CREATE INDEX IF NOT EXISTS idx_orders_seller_status
  ON public.orders (seller_id, status, created_at)
  WHERE deleted_at IS NULL;


-- ============================================================================
-- 3. Update confirm_order_payment: pending -> sale_pending (not paid)
--    The 5-min auto-confirm will transition sale_pending -> paid
-- ============================================================================

CREATE OR REPLACE FUNCTION public.confirm_order_payment(p_order_id uuid, p_stripe_payment_intent_id text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
    v_order RECORD;
    v_buyer_id UUID := auth.uid();
BEGIN
    -- Get and lock order
    SELECT * INTO v_order
    FROM orders
    WHERE id = p_order_id AND buyer_id = v_buyer_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Order not found';
    END IF;

    IF v_order.status != 'pending' THEN
        RAISE EXCEPTION 'Order is not in pending status (current: %)', v_order.status;
    END IF;

    -- Update order to sale_pending (5-min buyer cancellation window)
    UPDATE orders SET
        status = 'sale_pending',
        paid_at = NOW(),
        stripe_payment_intent_id = p_stripe_payment_intent_id,
        updated_at = NOW()
    WHERE id = p_order_id;

    -- Update daily budget if applicable
    UPDATE user_settings
    SET daily_budget_used = daily_budget_used + v_order.total_amount
    WHERE user_id = v_buyer_id AND swipe_payment_enabled = TRUE;

    -- Create transactions
    INSERT INTO transactions (user_id, order_id, type, amount, description, stripe_charge_id)
    VALUES (v_order.seller_id, p_order_id, 'sale',
            v_order.subtotal, 'Sale from order ' || v_order.order_number,
            p_stripe_payment_intent_id);

    INSERT INTO transactions (user_id, order_id, type, amount, description, stripe_charge_id)
    VALUES (v_buyer_id, p_order_id, 'purchase',
            v_order.total_amount, 'Purchase order ' || v_order.order_number,
            p_stripe_payment_intent_id);

    IF v_order.platform_fee > 0 THEN
        INSERT INTO transactions (user_id, order_id, type, amount, description)
        VALUES (v_order.seller_id, p_order_id, 'platform_fee',
                v_order.platform_fee, 'Platform fee for order ' || v_order.order_number);
    END IF;

    -- Notification for seller
    INSERT INTO notifications (user_id, type, title, body, related_order_id, related_user_id, action_url)
    VALUES (v_order.seller_id, 'item_sold', 'Item Sold!',
            'You have a new order ' || v_order.order_number || '. The buyer has 5 minutes to cancel.',
            p_order_id, v_buyer_id,
            '/orders/' || p_order_id::text);

    RETURN jsonb_build_object(
        'success', true,
        'order_id', p_order_id,
        'order_number', v_order.order_number,
        'status', 'sale_pending'
    );
END;
$function$;


-- ============================================================================
-- 4. Update process_successful_payment: paid -> sale_pending
-- ============================================================================

CREATE OR REPLACE FUNCTION public.process_successful_payment(p_order_id uuid, p_stripe_payment_intent_id text, p_stripe_charge_id text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
    v_order RECORD;
BEGIN
    SELECT * INTO v_order FROM orders WHERE id = p_order_id;

    IF v_order IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Order not found');
    END IF;

    IF v_order.status = 'paid' OR v_order.status = 'sale_pending' THEN
        RETURN jsonb_build_object('success', true, 'message', 'Order already processed');
    END IF;

    -- Set to sale_pending (5-min buyer cancellation window)
    UPDATE orders
    SET
        status = 'sale_pending',
        stripe_payment_intent_id = p_stripe_payment_intent_id,
        paid_at = NOW(),
        updated_at = NOW()
    WHERE id = p_order_id;

    -- Buyer transaction
    INSERT INTO transactions (
        user_id, order_id, type, amount, description, stripe_charge_id
    ) VALUES (
        v_order.buyer_id,
        v_order.id,
        'purchase',
        v_order.total_amount,
        'Order payment #' || v_order.order_number,
        p_stripe_charge_id
    );

    -- Seller transaction
    INSERT INTO transactions (
        user_id, order_id, type, amount, description, stripe_charge_id
    ) VALUES (
        v_order.seller_id,
        v_order.id,
        'sale',
        v_order.subtotal,
        'Sale earnings for order #' || v_order.order_number,
        p_stripe_charge_id
    );

    -- Platform fee
    IF v_order.platform_fee > 0 THEN
        INSERT INTO transactions (
            user_id, order_id, type, amount, description, stripe_charge_id
        ) VALUES (
            v_order.seller_id,
            v_order.id,
            'platform_fee',
            -v_order.platform_fee,
            'Platform fee for order #' || v_order.order_number,
            p_stripe_charge_id
        );
    END IF;

    RETURN jsonb_build_object('success', true);
END;
$function$;


-- ============================================================================
-- 5. Update validate_order_update trigger for new status transitions
-- ============================================================================

CREATE OR REPLACE FUNCTION public.validate_order_update()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    -- CRITICAL: Prevent changing buyer_id or seller_id
    IF OLD.buyer_id IS DISTINCT FROM NEW.buyer_id THEN
        RAISE EXCEPTION 'Cannot change order buyer';
    END IF;

    IF OLD.seller_id IS DISTINCT FROM NEW.seller_id THEN
        RAISE EXCEPTION 'Cannot change order seller';
    END IF;

    -- If buyer is updating (not the seller)
    IF OLD.buyer_id = auth.uid() AND OLD.seller_id != auth.uid() THEN
        IF OLD.status != NEW.status THEN
            -- Buyers can: pending -> cancelled, sale_pending -> cancelled (within 5 min)
            IF NOT (
                (OLD.status = 'pending' AND NEW.status = 'cancelled') OR
                (OLD.status = 'sale_pending' AND NEW.status = 'cancelled')
            ) THEN
                RAISE EXCEPTION 'Buyers cannot change order status (except cancel pending/sale_pending)';
            END IF;

            -- Enforce 5-minute cancellation window for sale_pending
            IF OLD.status = 'sale_pending' AND NEW.status = 'cancelled' THEN
                IF OLD.created_at < (NOW() - INTERVAL '5 minutes') THEN
                    RAISE EXCEPTION 'Cancellation window has expired (5 minutes)';
                END IF;
            END IF;
        END IF;

        IF OLD.subtotal != NEW.subtotal OR OLD.shipping_cost != NEW.shipping_cost OR
           OLD.tax_amount != NEW.tax_amount OR OLD.platform_fee != NEW.platform_fee OR
           OLD.total_amount != NEW.total_amount THEN
            RAISE EXCEPTION 'Buyers cannot modify financial fields';
        END IF;

        IF OLD.tracking_number IS DISTINCT FROM NEW.tracking_number OR
           OLD.shipping_carrier IS DISTINCT FROM NEW.shipping_carrier OR
           OLD.shipping_status IS DISTINCT FROM NEW.shipping_status THEN
            RAISE EXCEPTION 'Buyers cannot modify shipping fields';
        END IF;

        IF OLD.seller_notes IS DISTINCT FROM NEW.seller_notes THEN
            RAISE EXCEPTION 'Buyers cannot modify seller notes';
        END IF;
    END IF;

    -- If seller is updating (not the buyer)
    IF OLD.seller_id = auth.uid() AND OLD.buyer_id != auth.uid() THEN
        IF OLD.status != NEW.status THEN
            -- Sellers can: paid -> shipped, shipped -> delivered, paid -> cancelled (seller cancel)
            IF NOT (
                (OLD.status = 'paid' AND NEW.status = 'shipped') OR
                (OLD.status = 'shipped' AND NEW.status = 'delivered') OR
                (OLD.status = 'paid' AND NEW.status = 'cancelled')
            ) THEN
                RAISE EXCEPTION 'Sellers can only update status: paid->shipped, shipped->delivered, or paid->cancelled';
            END IF;

            -- Seller cancel requires reason
            IF OLD.status = 'paid' AND NEW.status = 'cancelled' THEN
                IF NEW.seller_cancel_reason IS NULL OR NEW.seller_cancel_reason = '' THEN
                    RAISE EXCEPTION 'Seller must provide a cancellation reason';
                END IF;
            END IF;
        END IF;

        IF OLD.subtotal != NEW.subtotal OR OLD.shipping_cost != NEW.shipping_cost OR
           OLD.tax_amount != NEW.tax_amount OR OLD.platform_fee != NEW.platform_fee OR
           OLD.total_amount != NEW.total_amount THEN
            RAISE EXCEPTION 'Sellers cannot modify financial fields';
        END IF;

        IF OLD.buyer_notes IS DISTINCT FROM NEW.buyer_notes THEN
            RAISE EXCEPTION 'Sellers cannot modify buyer notes';
        END IF;
    END IF;

    RETURN NEW;
END;
$function$;


-- ============================================================================
-- 6. Auto-confirm function: sale_pending -> paid after 5 minutes
-- ============================================================================

CREATE OR REPLACE FUNCTION public.auto_confirm_pending_orders()
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
DECLARE
  v_confirmed integer := 0;
  v_checked integer := 0;
  v_order record;
BEGIN
  FOR v_order IN
    SELECT id
    FROM orders
    WHERE status = 'sale_pending'
      AND created_at < (NOW() - INTERVAL '5 minutes')
      AND deleted_at IS NULL
      AND cancelled_at IS NULL
  LOOP
    v_checked := v_checked + 1;

    UPDATE orders
    SET status = 'paid',
        updated_at = NOW()
    WHERE id = v_order.id
      AND status = 'sale_pending';  -- Race condition guard

    IF FOUND THEN
      v_confirmed := v_confirmed + 1;
    END IF;
  END LOOP;

  RETURN jsonb_build_object(
    'checked', v_checked,
    'confirmed', v_confirmed
  );
END;
$function$;


-- ============================================================================
-- 7. pg_cron: auto-confirm every minute
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS pg_cron;

SELECT cron.schedule(
  'auto-confirm-pending-orders',
  '* * * * *',
  $$SELECT public.auto_confirm_pending_orders()$$
);


-- ============================================================================
-- 8. Update get_seller_stripe_earnings to handle date filtering
--    NOTE: This function already works correctly via stripe_payment_intents.
--    Adding a helper that returns order-level stats for the Earnings page.
-- ============================================================================

CREATE OR REPLACE FUNCTION public.get_seller_order_stats(
  p_start_date timestamp with time zone DEFAULT NULL,
  p_end_date timestamp with time zone DEFAULT NULL
)
RETURNS TABLE(
  total_orders bigint,
  total_revenue numeric,
  avg_sale numeric
)
LANGUAGE plpgsql
STABLE SECURITY DEFINER
SET search_path TO 'public'
AS $function$
DECLARE
  v_seller_id uuid;
BEGIN
  v_seller_id := auth.uid();

  RETURN QUERY
  SELECT
    COUNT(*)::bigint AS total_orders,
    COALESCE(SUM(o.total_amount), 0)::numeric AS total_revenue,
    CASE
      WHEN COUNT(*) > 0
      THEN (COALESCE(SUM(o.total_amount), 0) / COUNT(*))::numeric
      ELSE 0::numeric
    END AS avg_sale
  FROM orders o
  WHERE o.seller_id = v_seller_id
    AND o.status NOT IN ('cancelled', 'refunded')
    AND o.deleted_at IS NULL
    AND (p_start_date IS NULL OR o.created_at >= p_start_date)
    AND (p_end_date IS NULL OR o.created_at <= p_end_date);
END;
$function$;
