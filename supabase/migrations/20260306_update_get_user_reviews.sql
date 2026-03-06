-- Migration: Add order_date and review_role to get_user_reviews
-- Needed for "Purchased on [date]" / "Sold on [date]" display in review cards

DROP FUNCTION IF EXISTS public.get_user_reviews(uuid, text, integer, integer);

CREATE OR REPLACE FUNCTION public.get_user_reviews(
    p_user_id uuid,
    p_role text,
    p_limit integer DEFAULT 30,
    p_offset integer DEFAULT 0
)
RETURNS TABLE(
    review_id uuid,
    rating integer,
    title character varying,
    content text,
    would_recommend boolean,
    created_at timestamp with time zone,
    reviewer_username character varying,
    reviewer_avatar_url text,
    product_id uuid,
    product_title character varying,
    product_price numeric,
    product_image text,
    product_main_image_url text,
    images jsonb,
    review_role text,
    order_date timestamp with time zone
)
LANGUAGE plpgsql
STABLE SECURITY DEFINER
SET search_path TO 'public'
AS $function$
BEGIN
    RETURN QUERY
    SELECT
        r.id AS review_id,
        r.rating,
        r.title,
        r.content,
        r.would_recommend,
        r.created_at,
        rp.username AS reviewer_username,
        rp.avatar_url AS reviewer_avatar_url,
        r.product_id,
        p.title AS product_title,
        p.price AS product_price,
        (
            SELECT pi.image_url
            FROM product_images pi
            WHERE pi.product_id = p.id AND pi.is_main = true
            LIMIT 1
        ) AS product_image,
        (
            SELECT pi.image_url
            FROM product_images pi
            WHERE pi.product_id = p.id AND pi.is_main = true
            LIMIT 1
        ) AS product_main_image_url,
        COALESCE(
            (SELECT jsonb_agg(jsonb_build_object(
                'id', ri.id,
                'image_url', ri.image_url
            ) ORDER BY ri.sort_order)
            FROM review_images ri WHERE ri.review_id = r.id),
            '[]'::jsonb
        ) AS images,
        r.role::text AS review_role,
        COALESCE(o.paid_at, o.delivered_at) AS order_date
    FROM reviews r
    JOIN user_profiles rp ON rp.user_id = r.reviewer_id
    LEFT JOIN products p ON p.id = r.product_id
    LEFT JOIN orders o ON o.id = r.order_id
    WHERE r.reviewed_id = p_user_id
      AND r.role = p_role::review_role
      AND r.deleted_at IS NULL
    ORDER BY r.created_at DESC
    LIMIT p_limit
    OFFSET p_offset;
END;
$function$;
