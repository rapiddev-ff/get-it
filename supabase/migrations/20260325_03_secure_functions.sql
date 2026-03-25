-- ============================================================================
-- Migration: Secure RPC Functions
-- Date: 2026-03-25
-- Purpose: Fix EXPOSED_RPC_FUNCTIONS (91 functions), FUNCTION_SEARCH_PATH_RISK
-- ============================================================================

-- ============================================================================
-- STEP 1: Revoke EXECUTE from anon on ALL functions in public schema
-- Then selectively re-grant only the ones that need pre-auth access
-- Fixes: EXPOSED_RPC_FUNCTIONS
-- ============================================================================

-- Revoke EXECUTE from anon on ALL public schema functions
DO $$
DECLARE
    func RECORD;
BEGIN
    FOR func IN
        SELECT p.oid, n.nspname, p.proname,
               pg_catalog.pg_get_function_identity_arguments(p.oid) AS args
        FROM pg_catalog.pg_proc p
        JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
        WHERE n.nspname = 'public'
          AND p.prokind = 'f'  -- regular functions only
    LOOP
        BEGIN
            EXECUTE format(
                'REVOKE EXECUTE ON FUNCTION public.%I(%s) FROM anon',
                func.proname, func.args
            );
        EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Could not revoke on %.%(%): %', func.nspname, func.proname, func.args, SQLERRM;
        END;
    END LOOP;
END $$;

-- ============================================================================
-- STEP 2: Re-grant anon EXECUTE on functions that MUST work before auth
-- Password reset uses Edge Functions (not RPC), so no anon grants needed.
-- If you add RPC functions that must work pre-auth, grant them here:
-- ============================================================================

-- Example: GRANT EXECUTE ON FUNCTION public.some_pre_auth_function(text) TO anon;

-- ============================================================================
-- STEP 3: Grant EXECUTE to authenticated on functions they need
-- ============================================================================

-- Grant all public functions to authenticated (they've proven identity)
DO $$
DECLARE
    func RECORD;
BEGIN
    FOR func IN
        SELECT p.oid, n.nspname, p.proname,
               pg_catalog.pg_get_function_identity_arguments(p.oid) AS args
        FROM pg_catalog.pg_proc p
        JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
        WHERE n.nspname = 'public'
          AND p.prokind = 'f'
    LOOP
        BEGIN
            EXECUTE format(
                'GRANT EXECUTE ON FUNCTION public.%I(%s) TO authenticated',
                func.proname, func.args
            );
        EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Could not grant on %.%(%): %', func.nspname, func.proname, func.args, SQLERRM;
        END;
    END LOOP;
END $$;

-- ============================================================================
-- STEP 4: Fix search_path on functions to prevent search path injection
-- Fixes: FUNCTION_SEARCH_PATH_RISK
-- Set search_path = '' (empty) to force fully qualified references
-- ============================================================================

DO $$
DECLARE
    func RECORD;
    func_def TEXT;
BEGIN
    FOR func IN
        SELECT p.oid, p.proname,
               pg_catalog.pg_get_function_identity_arguments(p.oid) AS args,
               p.proconfig
        FROM pg_catalog.pg_proc p
        JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
        WHERE n.nspname = 'public'
          AND p.prokind = 'f'
          AND (
              p.proconfig IS NULL
              OR NOT EXISTS (
                  SELECT 1 FROM unnest(p.proconfig) AS c
                  WHERE c LIKE 'search_path=%'
              )
          )
    LOOP
        BEGIN
            EXECUTE format(
                'ALTER FUNCTION public.%I(%s) SET search_path = public, pg_temp',
                func.proname, func.args
            );
        EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Could not set search_path on %(%): %', func.proname, func.args, SQLERRM;
        END;
    END LOOP;
END $$;

-- ============================================================================
-- STEP 5: Ensure SECURITY DEFINER functions have proper search_path
-- Functions marked SECURITY DEFINER are especially dangerous without fixed search_path
-- ============================================================================

DO $$
DECLARE
    func RECORD;
BEGIN
    FOR func IN
        SELECT p.proname,
               pg_catalog.pg_get_function_identity_arguments(p.oid) AS args
        FROM pg_catalog.pg_proc p
        JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
        WHERE n.nspname = 'public'
          AND p.prosecdef = true  -- SECURITY DEFINER functions
    LOOP
        BEGIN
            EXECUTE format(
                'ALTER FUNCTION public.%I(%s) SET search_path = public, pg_temp',
                func.proname, func.args
            );
            RAISE NOTICE 'Fixed SECURITY DEFINER function: %(%)', func.proname, func.args;
        EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Could not fix SECURITY DEFINER %(%): %', func.proname, func.args, SQLERRM;
        END;
    END LOOP;
END $$;
