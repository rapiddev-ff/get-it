-- GT-112: Fix user-to-user chat not created when product chat exists
-- GT-113: Add product_condition to get_or_create_conversation RPC
--
-- GT-112: The lookup used (p_product_id IS NULL OR c.product_id = p_product_id)
--   which matched ALL chats when p_product_id was NULL (user-chat).
--   Fixed to (p_product_id IS NULL AND c.product_id IS NULL) so user-chats
--   only match other user-chats.
-- GT-113: Added product_condition to RETURNS TABLE and SELECT via JOIN conditions.

DROP FUNCTION IF EXISTS public.get_or_create_conversation(uuid, uuid);

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
    product_condition text,
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
      (p_product_id IS NULL AND c.product_id IS NULL)
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
    up.username::text,
    up.avatar_url::text,
    p.title::text,
    (
      SELECT pi.image_url::text
      FROM product_images pi
      WHERE pi.product_id = c.product_id
        AND pi.is_main = TRUE
      LIMIT 1
    ),
    p.price::double precision,
    cond.name::text,
    v_is_new
  FROM conversations c
  LEFT JOIN user_profiles up ON up.user_id = v_other_user_id AND up.deleted_at IS NULL
  LEFT JOIN products p ON p.id = c.product_id AND p.deleted_at IS NULL
  LEFT JOIN conditions cond ON cond.id = p.condition_id
  WHERE c.id = v_conversation_id;
END;
$$;
