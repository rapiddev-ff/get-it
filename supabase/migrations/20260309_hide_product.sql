-- 1. Create hidden_products table
CREATE TABLE IF NOT EXISTS public.hidden_products (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    created_at timestamp with time zone DEFAULT now()
);

-- Unique constraint: user can hide a product only once
CREATE UNIQUE INDEX IF NOT EXISTS hidden_products_user_id_product_id_key
    ON public.hidden_products (user_id, product_id);

CREATE INDEX IF NOT EXISTS idx_hidden_products_user_id
    ON public.hidden_products (user_id);

CREATE INDEX IF NOT EXISTS idx_hidden_products_product_id
    ON public.hidden_products (product_id);

-- RLS
ALTER TABLE public.hidden_products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage hidden products"
    ON public.hidden_products
    FOR ALL
    USING (user_id = auth.uid());


-- 2. Create hide_product RPC
CREATE OR REPLACE FUNCTION public.hide_product(p_user_id uuid, p_product_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
    INSERT INTO hidden_products (user_id, product_id)
    VALUES (p_user_id, p_product_id)
    ON CONFLICT (user_id, product_id) DO NOTHING;

    RETURN jsonb_build_object(
        'success', true,
        'action', 'hidden'
    );

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'success', false,
        'error', SQLERRM
    );
END;
$function$;


-- 3. Update get_feed_products to exclude hidden products
CREATE OR REPLACE FUNCTION public.get_feed_products(p_user_id uuid DEFAULT NULL::uuid, p_exclude_ids uuid[] DEFAULT NULL::uuid[])
 RETURNS TABLE(id uuid, title character varying, description text, price numeric, original_price numeric, flash_sale_enabled boolean, flash_sale_price numeric, flash_sale_ends_at timestamp with time zone, condition_name character varying, main_image_url text, seller_id uuid, seller_username character varying, seller_avatar_url text, seller_rating numeric, seller_total_reviews integer, is_in_wishlist boolean, created_at timestamp with time zone)
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
    RETURN QUERY
    SELECT
        p.id,
        p.title,
        p.description,
        p.price,
        p.original_price,
        p.flash_sale_enabled,
        p.flash_sale_price,
        p.flash_sale_ends_at,
        c.name AS condition_name,
        (
            SELECT pi.image_url
            FROM product_images pi
            WHERE pi.product_id = p.id AND pi.is_main = TRUE
            LIMIT 1
        ) AS main_image_url,
        p.seller_id,
        up.username AS seller_username,
        up.avatar_url AS seller_avatar_url,
        up.rating_as_seller AS seller_rating,
        up.total_reviews_as_seller AS seller_total_reviews,
        (
            CASE
                WHEN p_user_id IS NOT NULL THEN
                    EXISTS (
                        SELECT 1 FROM wishlists w
                        WHERE w.product_id = p.id AND w.user_id = p_user_id
                    )
                ELSE FALSE
            END
        ) AS is_in_wishlist,
        p.created_at
    FROM products p
    JOIN user_profiles up ON p.seller_id = up.user_id
    JOIN stripe_accounts sa ON sa.user_id = p.seller_id
    LEFT JOIN conditions c ON p.condition_id = c.id
    WHERE
        p.status = 'active'
        AND p.deleted_at IS NULL
        AND up.deleted_at IS NULL
        AND up.is_seller = TRUE
        AND sa.account_status = 'enabled'
        AND (p_user_id IS NULL OR p.seller_id != p_user_id)
        AND (p_exclude_ids IS NULL OR p.id != ALL(p_exclude_ids))
        AND NOT EXISTS (
            SELECT 1 FROM blocked_users bu
            WHERE p_user_id IS NOT NULL
            AND ((bu.blocker_id = p_user_id AND bu.blocked_id = p.seller_id)
                OR (bu.blocker_id = p.seller_id AND bu.blocked_id = p_user_id))
        )
        -- Exclude hidden products
        AND NOT EXISTS (
            SELECT 1 FROM hidden_products hp
            WHERE p_user_id IS NOT NULL
            AND hp.user_id = p_user_id
            AND hp.product_id = p.id
        )
    ORDER BY p.created_at DESC
    LIMIT 1000;
END;
$function$;
