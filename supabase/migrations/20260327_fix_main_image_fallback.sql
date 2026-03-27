-- GT-111: Fix inconsistent product images across Product List, Detail, and Checkout
--
-- Root cause: Several RPCs use `WHERE pi.is_main = TRUE` to select the main image.
-- If no image has is_main=TRUE (e.g., improperly created products), the query returns NULL.
-- Meanwhile, other RPCs (browse) correctly fall back to the first image by sort_order.
--
-- Fix: Replace strict `is_main = TRUE` filter with
--   ORDER BY (pi.is_main IS TRUE) DESC, pi.sort_order ASC LIMIT 1
-- This prefers the main image but falls back to the first image by sort_order.

-- 1. Fix get_feed_products
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
            WHERE pi.product_id = p.id
            ORDER BY (pi.is_main IS TRUE) DESC, pi.sort_order ASC
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
