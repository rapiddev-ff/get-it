-- GT-115: Hide empty conversations (no messages sent) from the conversations list
-- Conversations with last_message_at IS NULL have zero messages and should not appear.

DROP FUNCTION IF EXISTS public.get_conversations(uuid, text);

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
        (CASE WHEN c.buyer_id = v_user_id THEN seller_profile.username ELSE buyer_profile.username END)::text AS other_user_username,
        (CASE WHEN c.buyer_id = v_user_id THEN seller_profile.avatar_url ELSE buyer_profile.avatar_url END)::text AS other_user_avatar,
        CASE WHEN c.buyer_id = v_user_id THEN seller_profile.last_active_at ELSE buyer_profile.last_active_at END AS other_user_last_active,
        p.title::text AS product_title,
        (
            SELECT pi.image_url::text
            FROM product_images pi
            WHERE pi.product_id = p.id AND pi.is_main = TRUE
            LIMIT 1
        ) AS product_image,
        p.price::double precision AS product_price,
        cond.name::text AS product_condition,
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
      AND c.last_message_at IS NOT NULL
      AND (c.buyer_id = v_user_id OR c.seller_id = v_user_id)
      AND NOT EXISTS (
          SELECT 1 FROM blocked_users bu
          WHERE (bu.blocker_id = v_user_id AND bu.blocked_id = CASE WHEN c.buyer_id = v_user_id THEN c.seller_id ELSE c.buyer_id END)
             OR (bu.blocked_id = v_user_id AND bu.blocker_id = CASE WHEN c.buyer_id = v_user_id THEN c.seller_id ELSE c.buyer_id END)
      )
    ORDER BY c.last_message_at DESC;
END;
$$;
