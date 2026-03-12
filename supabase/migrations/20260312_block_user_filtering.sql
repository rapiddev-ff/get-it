-- Migration: Add blocked user filtering to browse, conversations, wishlist
-- Also prevents creating conversations with blocked users

-- 1. get_browse_products: filter blocked users' products
CREATE OR REPLACE FUNCTION public.get_browse_products(
    p_user_id uuid DEFAULT NULL,
    p_search_query text DEFAULT NULL,
    p_category_id uuid DEFAULT NULL,
    p_subcategory_id uuid DEFAULT NULL,
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
BEGIN
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
      AND (p_category_id IS NULL OR p.category_id = p_category_id)
      AND (p_subcategory_id IS NULL OR p.subcategory_id = p_subcategory_id)
      AND (v_search_tsquery IS NULL OR p.search_vector @@ v_search_tsquery OR p.title ILIKE v_search_pattern)
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
          AND (p_category_id IS NULL OR p.category_id = p_category_id)
          AND (p_subcategory_id IS NULL OR p.subcategory_id = p_subcategory_id)
          AND (v_search_tsquery IS NULL OR p.search_vector @@ v_search_tsquery OR p.title ILIKE v_search_pattern)
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


-- 2. get_conversations: filter conversations with blocked users
CREATE OR REPLACE FUNCTION public.get_conversations(
    p_user_id uuid DEFAULT NULL,
    p_filter text DEFAULT NULL
)
RETURNS TABLE(
    id uuid,
    buyer_id uuid,
    seller_id uuid,
    product_id uuid,
    last_message_text text,
    last_message_at timestamptz,
    buyer_unread_count integer,
    seller_unread_count integer,
    created_at timestamptz,
    other_user_id uuid,
    other_user_username text,
    other_user_avatar text,
    other_user_last_active timestamptz,
    product_title text,
    product_image text,
    product_price double precision,
    product_condition text,
    role text
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_user_id UUID := auth.uid();
BEGIN
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    RETURN QUERY
    SELECT
        c.id,
        c.buyer_id,
        c.seller_id,
        c.product_id,
        c.last_message_text,
        c.last_message_at,
        c.buyer_unread_count,
        c.seller_unread_count,
        c.created_at,
        CASE WHEN c.buyer_id = v_user_id THEN c.seller_id ELSE c.buyer_id END AS other_user_id,
        CASE WHEN c.buyer_id = v_user_id THEN seller_profile.username ELSE buyer_profile.username END AS other_user_username,
        CASE WHEN c.buyer_id = v_user_id THEN seller_profile.avatar_url ELSE buyer_profile.avatar_url END AS other_user_avatar,
        CASE WHEN c.buyer_id = v_user_id THEN seller_profile.last_active_at ELSE buyer_profile.last_active_at END AS other_user_last_active,
        p.title AS product_title,
        (
            SELECT pi.image_url
            FROM product_images pi
            WHERE pi.product_id = p.id AND pi.is_main = TRUE
            LIMIT 1
        ) AS product_image,
        p.price AS product_price,
        cond.name AS product_condition,
        CASE
            WHEN c.buyer_id = v_user_id AND c.seller_id = v_user_id THEN 'both'
            WHEN c.buyer_id = v_user_id THEN 'buyer'
            ELSE 'seller'
        END AS role
    FROM conversations c
    LEFT JOIN user_profiles buyer_profile ON buyer_profile.user_id = c.buyer_id
    LEFT JOIN user_profiles seller_profile ON seller_profile.user_id = c.seller_id
    LEFT JOIN products p ON p.id = c.product_id
    LEFT JOIN conditions cond ON cond.id = p.condition_id
    WHERE c.deleted_at IS NULL
      AND (c.buyer_id = v_user_id OR c.seller_id = v_user_id)
      AND NOT EXISTS (
          SELECT 1 FROM blocked_users bu
          WHERE (bu.blocker_id = v_user_id AND bu.blocked_id = CASE WHEN c.buyer_id = v_user_id THEN c.seller_id ELSE c.buyer_id END)
             OR (bu.blocked_id = v_user_id AND bu.blocker_id = CASE WHEN c.buyer_id = v_user_id THEN c.seller_id ELSE c.buyer_id END)
      )
    ORDER BY c.last_message_at DESC NULLS LAST;
END;
$$;


-- 3. get_wishlist_products: filter blocked users' products from wishlist
CREATE OR REPLACE FUNCTION public.get_wishlist_products(
    p_user_id uuid DEFAULT NULL
)
RETURNS TABLE(
    id uuid,
    title text,
    description text,
    price double precision,
    original_price double precision,
    flash_sale_enabled boolean,
    flash_sale_price double precision,
    flash_sale_ends_at timestamptz,
    discount_type text,
    discount_amount double precision,
    quantity integer,
    year integer,
    issue_number integer,
    sku text,
    shipping_info text,
    shipping_price double precision,
    free_shipping boolean,
    use_seller_shipping boolean,
    custom_flat_rate double precision,
    custom_additional_item_fee double precision,
    shortlist_id uuid,
    views_count integer,
    status text,
    created_at timestamptz,
    conditions jsonb,
    category jsonb,
    subcategory jsonb,
    seller jsonb,
    images jsonb,
    tags jsonb,
    is_in_wishlist boolean,
    is_own_product boolean
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_user_id UUID;
BEGIN
    v_user_id := COALESCE(p_user_id, auth.uid());

    IF v_user_id IS NULL THEN
        RETURN;
    END IF;

    RETURN QUERY
    SELECT
        p.id,
        p.title::TEXT,
        p.description::TEXT,
        p.price::DOUBLE PRECISION,
        p.original_price::DOUBLE PRECISION,
        COALESCE(p.flash_sale_enabled, FALSE),
        p.flash_sale_price::DOUBLE PRECISION,
        p.flash_sale_ends_at,
        p.discount_type::TEXT,
        p.discount_amount::DOUBLE PRECISION,
        COALESCE(p.quantity, 0),
        p.year,
        p.issue_number,
        p.sku::TEXT,
        p.shipping_info::TEXT,
        p.shipping_price::DOUBLE PRECISION,
        COALESCE(p.free_shipping, FALSE),
        COALESCE(p.use_seller_shipping, TRUE),
        p.custom_flat_rate::DOUBLE PRECISION,
        p.custom_additional_item_fee::DOUBLE PRECISION,
        p.shortlist_id,
        COALESCE(p.views_count, 0),
        p.status::TEXT,
        p.created_at,
        (
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
        ) AS conditions,
        CASE WHEN cat.id IS NOT NULL THEN
            jsonb_build_object('id', cat.id, 'name', cat.name, 'slug', cat.slug)
        ELSE NULL END AS category,
        CASE WHEN sub.id IS NOT NULL THEN
            jsonb_build_object('id', sub.id, 'name', sub.name, 'slug', sub.slug)
        ELSE NULL END AS subcategory,
        CASE WHEN up.user_id IS NOT NULL THEN
            jsonb_build_object(
                'id', up.user_id, 'username', up.username, 'avatar_url', up.avatar_url,
                'rating', up.rating_as_seller, 'total_reviews', up.total_reviews_as_seller,
                'total_sales', up.total_sales, 'seller_since', up.seller_since
            )
        ELSE NULL END AS seller,
        (
            SELECT COALESCE(jsonb_agg(
                jsonb_build_object(
                    'id', pi.id, 'image_url', pi.image_url,
                    'is_main', pi.is_main, 'sort_order', pi.sort_order
                ) ORDER BY pi.is_main DESC, pi.sort_order ASC
            ), '[]'::jsonb)
            FROM product_images pi
            WHERE pi.product_id = p.id
        ) AS images,
        (
            SELECT COALESCE(jsonb_agg(
                jsonb_build_object('id', t.id, 'name', t.name, 'slug', t.slug)
            ), '[]'::jsonb)
            FROM product_tags pt
            JOIN tags t ON t.id = pt.tag_id
            WHERE pt.product_id = p.id
        ) AS tags,
        TRUE AS is_in_wishlist,
        (p.seller_id = v_user_id) AS is_own_product
    FROM wishlists w
    INNER JOIN products p ON p.id = w.product_id
    LEFT JOIN user_profiles up ON up.user_id = p.seller_id
    LEFT JOIN categories cat ON cat.id = p.category_id
    LEFT JOIN subcategories sub ON sub.id = p.subcategory_id
    WHERE w.user_id = v_user_id
      AND p.deleted_at IS NULL
      AND NOT EXISTS (
          SELECT 1 FROM blocked_users bu
          WHERE (bu.blocker_id = v_user_id AND bu.blocked_id = p.seller_id)
             OR (bu.blocked_id = v_user_id AND bu.blocker_id = p.seller_id)
      )
    ORDER BY w.created_at DESC;
END;
$$;


-- 4. get_or_create_conversation: prevent with blocked users
CREATE OR REPLACE FUNCTION public.get_or_create_conversation(
    p_seller_id uuid,
    p_product_id uuid DEFAULT NULL
)
RETURNS TABLE(
    id uuid,
    buyer_id uuid,
    seller_id uuid,
    product_id uuid,
    last_message_text text,
    last_message_at timestamptz,
    buyer_unread_count integer,
    seller_unread_count integer,
    created_at timestamptz,
    other_user_id uuid,
    other_user_username text,
    other_user_avatar text,
    product_title text,
    product_image text,
    product_price double precision,
    is_new boolean
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_conversation_id UUID;
  v_is_new BOOLEAN := FALSE;
  v_other_user_id UUID;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  IF v_user_id = p_seller_id THEN
    RAISE EXCEPTION 'Cannot create conversation with yourself';
  END IF;

  -- Block check: prevent conversation with blocked user
  IF EXISTS (
      SELECT 1 FROM blocked_users bu
      WHERE (bu.blocker_id = v_user_id AND bu.blocked_id = p_seller_id)
         OR (bu.blocked_id = v_user_id AND bu.blocker_id = p_seller_id)
  ) THEN
      RAISE EXCEPTION 'Cannot message this user';
  END IF;

  SELECT c.id INTO v_conversation_id
  FROM conversations c
  WHERE c.deleted_at IS NULL
    AND (
      (c.buyer_id = v_user_id AND c.seller_id = p_seller_id)
      OR
      (c.buyer_id = p_seller_id AND c.seller_id = v_user_id)
    )
    AND (
      p_product_id IS NULL
      OR
      c.product_id = p_product_id
    )
  ORDER BY c.last_message_at DESC NULLS LAST
  LIMIT 1;

  IF v_conversation_id IS NULL THEN
    DELETE FROM conversations AS old_conv
    WHERE old_conv.deleted_at IS NOT NULL
      AND old_conv.buyer_id = v_user_id
      AND old_conv.seller_id = p_seller_id
      AND (
        (p_product_id IS NULL AND old_conv.product_id IS NULL)
        OR old_conv.product_id = p_product_id
      );

    INSERT INTO conversations AS conv (buyer_id, seller_id, product_id)
    VALUES (v_user_id, p_seller_id, p_product_id)
    ON CONFLICT ON CONSTRAINT conversations_buyer_id_seller_id_product_id_key
    DO UPDATE SET
      deleted_at = NULL,
      updated_at = now()
    RETURNING conv.id INTO v_conversation_id;

    v_is_new := TRUE;
  END IF;

  SELECT
    CASE
      WHEN c.buyer_id = v_user_id THEN c.seller_id
      ELSE c.buyer_id
    END INTO v_other_user_id
  FROM conversations c
  WHERE c.id = v_conversation_id;

  RETURN QUERY
  SELECT
    c.id,
    c.buyer_id,
    c.seller_id,
    c.product_id,
    c.last_message_text,
    c.last_message_at,
    c.buyer_unread_count,
    c.seller_unread_count,
    c.created_at,
    v_other_user_id,
    up.username,
    up.avatar_url,
    p.title,
    (
      SELECT pi.image_url
      FROM product_images pi
      WHERE pi.product_id = c.product_id
        AND pi.is_main = TRUE
      LIMIT 1
    ),
    p.price,
    v_is_new
  FROM conversations c
  LEFT JOIN user_profiles up ON up.user_id = v_other_user_id AND up.deleted_at IS NULL
  LEFT JOIN products p ON p.id = c.product_id AND p.deleted_at IS NULL
  WHERE c.id = v_conversation_id;
END;
$$;
