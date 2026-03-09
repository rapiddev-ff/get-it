-- Migration: RPC functions for paginated followers/following lists with search

CREATE OR REPLACE FUNCTION public.get_followers(
    p_user_id uuid,
    p_search text DEFAULT '',
    p_limit integer DEFAULT 20,
    p_offset integer DEFAULT 0
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result jsonb;
    total_count integer;
    items jsonb;
BEGIN
    -- Count total matching followers
    SELECT count(*)
    INTO total_count
    FROM follows f
    JOIN user_profiles up ON up.user_id = f.follower_id
    WHERE f.following_id = p_user_id
      AND up.deleted_at IS NULL
      AND up.is_deactivated IS NOT TRUE
      AND (
          p_search = ''
          OR up.username ILIKE '%' || p_search || '%'
          OR up.first_name ILIKE '%' || p_search || '%'
          OR up.last_name ILIKE '%' || p_search || '%'
      );

    -- Get paginated followers
    SELECT coalesce(jsonb_agg(row_data), '[]'::jsonb)
    INTO items
    FROM (
        SELECT jsonb_build_object(
            'user_id', up.user_id,
            'username', up.username,
            'avatar_url', up.avatar_url,
            'first_name', up.first_name,
            'last_name', up.last_name,
            'followed_at', f.created_at
        ) AS row_data
        FROM follows f
        JOIN user_profiles up ON up.user_id = f.follower_id
        WHERE f.following_id = p_user_id
          AND up.deleted_at IS NULL
          AND up.is_deactivated IS NOT TRUE
          AND (
              p_search = ''
              OR up.username ILIKE '%' || p_search || '%'
              OR up.first_name ILIKE '%' || p_search || '%'
              OR up.last_name ILIKE '%' || p_search || '%'
          )
        ORDER BY f.created_at DESC
        LIMIT p_limit
        OFFSET p_offset
    ) sub;

    result := jsonb_build_object(
        'total_count', total_count,
        'items', items
    );

    RETURN result;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_following(
    p_user_id uuid,
    p_search text DEFAULT '',
    p_limit integer DEFAULT 20,
    p_offset integer DEFAULT 0
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result jsonb;
    total_count integer;
    items jsonb;
BEGIN
    -- Count total matching following
    SELECT count(*)
    INTO total_count
    FROM follows f
    JOIN user_profiles up ON up.user_id = f.following_id
    WHERE f.follower_id = p_user_id
      AND up.deleted_at IS NULL
      AND up.is_deactivated IS NOT TRUE
      AND (
          p_search = ''
          OR up.username ILIKE '%' || p_search || '%'
          OR up.first_name ILIKE '%' || p_search || '%'
          OR up.last_name ILIKE '%' || p_search || '%'
      );

    -- Get paginated following
    SELECT coalesce(jsonb_agg(row_data), '[]'::jsonb)
    INTO items
    FROM (
        SELECT jsonb_build_object(
            'user_id', up.user_id,
            'username', up.username,
            'avatar_url', up.avatar_url,
            'first_name', up.first_name,
            'last_name', up.last_name,
            'followed_at', f.created_at
        ) AS row_data
        FROM follows f
        JOIN user_profiles up ON up.user_id = f.following_id
        WHERE f.follower_id = p_user_id
          AND up.deleted_at IS NULL
          AND up.is_deactivated IS NOT TRUE
          AND (
              p_search = ''
              OR up.username ILIKE '%' || p_search || '%'
              OR up.first_name ILIKE '%' || p_search || '%'
              OR up.last_name ILIKE '%' || p_search || '%'
          )
        ORDER BY f.created_at DESC
        LIMIT p_limit
        OFFSET p_offset
    ) sub;

    result := jsonb_build_object(
        'total_count', total_count,
        'items', items
    );

    RETURN result;
END;
$$;
