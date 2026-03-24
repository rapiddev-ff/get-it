-- Migration: GT-92 Browse Search + Filter
-- Adds multi-select filters: categories, subcategories, conditions, tags, price range, year
-- Also adds tag name search to the search query
-- Uses text[] instead of uuid[] for PostgREST compatibility

-- Drop ALL overloaded versions of the function
DROP FUNCTION IF EXISTS public.get_browse_products(uuid, text, uuid, uuid, integer, integer);
DROP FUNCTION IF EXISTS public.get_browse_products(uuid, text, uuid, uuid, uuid[], uuid[], uuid[], uuid[], double precision, double precision, integer, integer, integer);
DROP FUNCTION IF EXISTS public.get_browse_products(uuid, text, uuid, uuid, text[], text[], text[], text[], double precision, double precision, integer, integer, integer);

CREATE OR REPLACE FUNCTION public.get_browse_products(
    p_user_id uuid DEFAULT NULL,
    p_search_query text DEFAULT NULL,
    p_category_id uuid DEFAULT NULL,
    p_subcategory_id uuid DEFAULT NULL,
    p_category_ids text[] DEFAULT NULL,
    p_subcategory_ids text[] DEFAULT NULL,
    p_condition_ids text[] DEFAULT NULL,
    p_tag_ids text[] DEFAULT NULL,
    p_price_min double precision DEFAULT NULL,
    p_price_max double precision DEFAULT NULL,
    p_year integer DEFAULT NULL,
    p_limit integer DEFAULT 20,
    p_offset integer DEFAULT 0
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_total_count INTEGER;
    v_products JSONB;
    v_search_tsquery TSQUERY;
    v_search_pattern TEXT;
    v_cat_ids uuid[];
    v_subcat_ids uuid[];
    v_cond_ids uuid[];
    v_tag_uuids uuid[];
BEGIN
    -- Cast text[] to uuid[] and merge single-value params for backward compat
    IF p_category_ids IS NOT NULL THEN
        v_cat_ids := ARRAY(SELECT unnest(p_category_ids)::uuid);
    END IF;
    IF p_category_id IS NOT NULL THEN
        v_cat_ids := COALESCE(v_cat_ids, ARRAY[]::uuid[]) || p_category_id;
    END IF;

    IF p_subcategory_ids IS NOT NULL THEN
        v_subcat_ids := ARRAY(SELECT unnest(p_subcategory_ids)::uuid);
    END IF;
    IF p_subcategory_id IS NOT NULL THEN
        v_subcat_ids := COALESCE(v_subcat_ids, ARRAY[]::uuid[]) || p_subcategory_id;
    END IF;

    IF p_condition_ids IS NOT NULL THEN
        v_cond_ids := ARRAY(SELECT unnest(p_condition_ids)::uuid);
    END IF;

    IF p_tag_ids IS NOT NULL THEN
        v_tag_uuids := ARRAY(SELECT unnest(p_tag_ids)::uuid);
    END IF;

    IF p_search_query IS NOT NULL AND TRIM(p_search_query) != '' THEN
        v_search_tsquery := websearch_to_tsquery('english', p_search_query);
        v_search_pattern := '%' || replace(replace(replace(trim(p_search_query), '\', '\\'), '%', '\%'), '_', '\_') || '%';
    END IF;

    SELECT COUNT(*)
    INTO v_total_count
    FROM products p
    WHERE p.status = 'active'
      AND p.deleted_at IS NULL
      AND p.quantity > 0
      AND (p_user_id IS NULL OR p.seller_id != p_user_id)
      AND (v_cat_ids IS NULL OR p.category_id = ANY(v_cat_ids))
      AND (v_subcat_ids IS NULL OR p.subcategory_id = ANY(v_subcat_ids))
      AND (v_cond_ids IS NULL OR p.condition_id = ANY(v_cond_ids) OR EXISTS (
          SELECT 1 FROM product_conditions pc WHERE pc.product_id = p.id AND pc.condition_id = ANY(v_cond_ids)
      ))
      AND (v_tag_uuids IS NULL OR EXISTS (
          SELECT 1 FROM product_tags pt WHERE pt.product_id = p.id AND pt.tag_id = ANY(v_tag_uuids)
      ))
      AND (p_price_min IS NULL OR p.price >= p_price_min)
      AND (p_price_max IS NULL OR p.price <= p_price_max)
      AND (p_year IS NULL OR p.year = p_year)
      AND (
          v_search_tsquery IS NULL
          OR p.search_vector @@ v_search_tsquery
          OR p.title ILIKE v_search_pattern
          OR EXISTS (
              SELECT 1 FROM product_tags pt2
              JOIN tags t ON t.id = pt2.tag_id
              WHERE pt2.product_id = p.id AND t.name ILIKE v_search_pattern
          )
      )
      AND NOT EXISTS (
          SELECT 1 FROM blocked_users bu
          WHERE p_user_id IS NOT NULL
          AND ((bu.blocker_id = p_user_id AND bu.blocked_id = p.seller_id)
              OR (bu.blocker_id = p.seller_id AND bu.blocked_id = p_user_id))
      );

    SELECT COALESCE(jsonb_agg(product_data), '[]'::jsonb)
    INTO v_products
    FROM (
        SELECT jsonb_build_object(
            'id', p.id,
            'title', p.title,
            'price', p.price,
            'original_price', p.original_price,
            'status', p.status,
            'views_count', p.views_count,
            'condition_name', cond.name,
            'category_name', cat.name,
            'main_image_url', (
                SELECT pi.image_url
                FROM product_images pi
                WHERE pi.product_id = p.id
                ORDER BY (pi.is_main IS TRUE) DESC, pi.sort_order ASC
                LIMIT 1
            ),
            'is_in_wishlist', CASE
                WHEN p_user_id IS NOT NULL THEN EXISTS (
                    SELECT 1 FROM wishlists w
                    WHERE w.product_id = p.id AND w.user_id = p_user_id
                )
                ELSE FALSE
            END,
            'seller_id', p.seller_id,
            'seller_username', up.username,
            'seller_avatar_url', up.avatar_url,
            'seller_rating', up.rating_as_seller,
            'created_at', p.created_at,
            'free_shipping', p.free_shipping,
            'discount_type', p.discount_type,
            'discount_amount', p.discount_amount,
            'flash_sale_enabled', p.flash_sale_enabled AND p.flash_sale_ends_at > NOW(),
            'flash_sale_price', CASE
                WHEN p.flash_sale_enabled AND p.flash_sale_ends_at > NOW()
                THEN p.flash_sale_price
                ELSE NULL
            END,
            'flash_sale_ends_at', CASE
                WHEN p.flash_sale_enabled AND p.flash_sale_ends_at > NOW()
                THEN p.flash_sale_ends_at
                ELSE NULL
            END
        ) AS product_data
        FROM products p
        JOIN user_profiles up ON up.user_id = p.seller_id
        LEFT JOIN conditions cond ON cond.id = p.condition_id
        LEFT JOIN categories cat ON cat.id = p.category_id
        WHERE p.status = 'active'
          AND p.deleted_at IS NULL
          AND p.quantity > 0
          AND (v_cat_ids IS NULL OR p.category_id = ANY(v_cat_ids))
          AND (v_subcat_ids IS NULL OR p.subcategory_id = ANY(v_subcat_ids))
          AND (v_cond_ids IS NULL OR p.condition_id = ANY(v_cond_ids) OR EXISTS (
              SELECT 1 FROM product_conditions pc WHERE pc.product_id = p.id AND pc.condition_id = ANY(v_cond_ids)
          ))
          AND (v_tag_uuids IS NULL OR EXISTS (
              SELECT 1 FROM product_tags pt WHERE pt.product_id = p.id AND pt.tag_id = ANY(v_tag_uuids)
          ))
          AND (p_price_min IS NULL OR p.price >= p_price_min)
          AND (p_price_max IS NULL OR p.price <= p_price_max)
          AND (p_year IS NULL OR p.year = p_year)
          AND (
              v_search_tsquery IS NULL
              OR p.search_vector @@ v_search_tsquery
              OR p.title ILIKE v_search_pattern
              OR EXISTS (
                  SELECT 1 FROM product_tags pt2
                  JOIN tags t ON t.id = pt2.tag_id
                  WHERE pt2.product_id = p.id AND t.name ILIKE v_search_pattern
              )
          )
          AND NOT EXISTS (
              SELECT 1 FROM blocked_users bu
              WHERE p_user_id IS NOT NULL
              AND ((bu.blocker_id = p_user_id AND bu.blocked_id = p.seller_id)
                  OR (bu.blocker_id = p.seller_id AND bu.blocked_id = p_user_id))
          )
        ORDER BY
            CASE WHEN v_search_tsquery IS NOT NULL
                 THEN ts_rank(p.search_vector, v_search_tsquery)
                 ELSE 0
            END DESC,
            p.created_at DESC
        LIMIT p_limit
        OFFSET p_offset
    ) subq;

    RETURN jsonb_build_object(
        'products', v_products,
        'total_count', v_total_count,
        'has_more', (p_offset + p_limit) < v_total_count
    );
END;
$$;
