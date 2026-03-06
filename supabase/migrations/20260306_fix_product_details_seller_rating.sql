-- Migration: Fix seller rating in get_product_details
-- Problem: reads stale cached values from user_profiles (rating_as_seller, total_reviews_as_seller)
-- Fix: calculate rating live from reviews table, matching get_seller_info behavior

CREATE OR REPLACE FUNCTION public.get_product_details(p_product_id uuid, p_user_id uuid DEFAULT NULL::uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
    v_result JSONB;
BEGIN
    SELECT jsonb_build_object(
        'id', p.id,
        'title', p.title,
        'description', p.description,
        'price', p.price,
        'original_price', p.original_price,
        'flash_sale_enabled', p.flash_sale_enabled,
        'flash_sale_price', p.flash_sale_price,
        'flash_sale_ends_at', p.flash_sale_ends_at,
        'discount_type', p.discount_type,
        'discount_amount', p.discount_amount,
        'quantity', p.quantity,
        'year', p.year,
        'issue_number', p.issue_number,
        'sku', p.sku,
        'sku_number', p.sku_number,

        'shipping_info', p.shipping_info,
        'shipping_price', p.shipping_price,
        'free_shipping', p.free_shipping,
        'use_seller_shipping', p.use_seller_shipping,
        'custom_flat_rate', p.custom_flat_rate,
        'custom_additional_item_fee', p.custom_additional_item_fee,
        'shortlist_id', p.shortlist_id,
        'views_count', p.views_count,
        'status', p.status,
        'created_at', p.created_at,

        -- Conditions (array via product_conditions)
        'conditions', (
            SELECT COALESCE(jsonb_agg(
                jsonb_build_object(
                    'id', c.id,
                    'name', c.name,
                    'code', c.code,
                    'description', c.description
                ) ORDER BY c.name
            ), '[]'::jsonb)
            FROM product_conditions pc
            JOIN conditions c ON c.id = pc.condition_id
            WHERE pc.product_id = p.id
        ),

        -- Category
        'category', jsonb_build_object(
            'id', cat.id,
            'name', cat.name,
            'slug', cat.slug
        ),

        -- Subcategory
        'subcategory', CASE WHEN sub.id IS NOT NULL THEN jsonb_build_object(
            'id', sub.id,
            'name', sub.name,
            'slug', sub.slug
        ) ELSE NULL END,

        -- Seller (rating calculated live from reviews table)
        'seller', jsonb_build_object(
            'id', up.user_id,
            'username', up.username,
            'avatar_url', up.avatar_url,
            'rating', COALESCE((
                SELECT ROUND(AVG(r.rating)::numeric, 1)
                FROM reviews r
                WHERE r.reviewed_id = up.user_id
                  AND r.role = 'as_seller'
                  AND r.deleted_at IS NULL
            ), 0),
            'total_reviews', COALESCE((
                SELECT COUNT(*)
                FROM reviews r
                WHERE r.reviewed_id = up.user_id
                  AND r.role = 'as_seller'
                  AND r.deleted_at IS NULL
            ), 0),
            'total_sales', up.total_sales,
            'seller_since', up.seller_since
        ),

        -- Images
        'images', (
            SELECT COALESCE(jsonb_agg(
                jsonb_build_object(
                    'id', pi.id,
                    'image_url', pi.image_url,
                    'is_main', pi.is_main,
                    'sort_order', pi.sort_order
                ) ORDER BY pi.is_main DESC, pi.sort_order ASC
            ), '[]'::jsonb)
            FROM product_images pi
            WHERE pi.product_id = p.id
        ),

        -- Tags
        'tags', (
            SELECT COALESCE(jsonb_agg(
                jsonb_build_object(
                    'id', t.id,
                    'name', t.name,
                    'slug', t.slug
                )
            ), '[]'::jsonb)
            FROM product_tags pt
            JOIN tags t ON t.id = pt.tag_id
            WHERE pt.product_id = p.id
        ),

        -- User-specific
        'is_in_wishlist', CASE
            WHEN p_user_id IS NOT NULL THEN EXISTS(
                SELECT 1 FROM wishlists w
                WHERE w.user_id = p_user_id AND w.product_id = p.id
            )
            ELSE false
        END,

        'is_own_product', CASE
            WHEN p_user_id IS NOT NULL THEN p.seller_id = p_user_id
            ELSE false
        END
    ) INTO v_result
    FROM products p
    LEFT JOIN categories cat ON cat.id = p.category_id
    LEFT JOIN subcategories sub ON sub.id = p.subcategory_id
    LEFT JOIN user_profiles up ON up.user_id = p.seller_id
    WHERE p.id = p_product_id
      AND p.deleted_at IS NULL;

    IF v_result IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'Product not found'
        );
    END IF;

    RETURN v_result;
END;
$function$;
