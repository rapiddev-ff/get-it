-- GT-116: RPC to soft-delete a conversation
-- Direct client UPDATE is blocked by RLS; use SECURITY DEFINER to bypass.

DROP FUNCTION IF EXISTS public.delete_conversation(uuid);

CREATE OR REPLACE FUNCTION public.delete_conversation(
    p_conversation_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_user_id UUID := auth.uid();
BEGIN
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    -- Only allow participants to delete
    UPDATE conversations
    SET deleted_at = now()
    WHERE id = p_conversation_id
      AND deleted_at IS NULL
      AND (buyer_id = v_user_id OR seller_id = v_user_id);

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Conversation not found or not authorized';
    END IF;
END;
$$;
