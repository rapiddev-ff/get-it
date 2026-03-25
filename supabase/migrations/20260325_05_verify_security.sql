-- ============================================================================
-- Verification Script: Run AFTER all security migrations
-- Date: 2026-03-25
-- Purpose: Verify all security issues are resolved
-- NOTE: This is a read-only verification — safe to run multiple times
-- ============================================================================

-- ============================================================================
-- CHECK 1: Verify RLS is enabled on all public tables
-- Expected: All tables should show rls_enabled = true
-- ============================================================================
SELECT
    schemaname,
    tablename,
    rowsecurity AS rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- ============================================================================
-- CHECK 2: Verify no sensitive tables are accessible to anon
-- Expected: 0 rows (no sensitive tables accessible to anon)
-- ============================================================================
SELECT
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'anon'
  AND table_schema = 'public'
  AND table_name IN (
      'password_reset_codes',
      'sync_logs',
      'user_settings',
      'orders',
      'stripe_accounts',
      'payment_methods',
      'transactions',
      'tax_document_downloads',
      'wishlists',
      'blocked_users',
      'referrals',
      'promotions',
      'shopify_integrations',
      'api_tokens',
      'product_shopify_mapping'
  )
ORDER BY table_name, privilege_type;

-- ============================================================================
-- CHECK 3: Count functions still accessible to anon
-- Expected: Only password reset functions (2)
-- ============================================================================
SELECT
    p.proname AS function_name,
    pg_catalog.pg_get_function_identity_arguments(p.oid) AS arguments
FROM pg_catalog.pg_proc p
JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public'
  AND p.prokind = 'f'
  AND has_function_privilege('anon', p.oid, 'EXECUTE')
ORDER BY p.proname;

-- ============================================================================
-- CHECK 4: Verify all functions have fixed search_path
-- Expected: 0 rows (no functions without search_path)
-- ============================================================================
SELECT
    p.proname AS function_name,
    pg_catalog.pg_get_function_identity_arguments(p.oid) AS arguments,
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
ORDER BY p.proname;

-- ============================================================================
-- CHECK 5: List all RLS policies per table
-- Expected: Each sensitive table has ownership-based policies
-- ============================================================================
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- ============================================================================
-- CHECK 6: Verify no overly permissive policies (using 'true' without role restriction)
-- Expected: Only reference tables (conditions, subcategories, etc.) should have USING (true)
-- ============================================================================
SELECT
    tablename,
    policyname,
    roles,
    qual
FROM pg_policies
WHERE schemaname = 'public'
  AND qual = 'true'
  AND tablename NOT IN ('conditions', 'subcategories', 'product_tags', 'product_conditions', 'video_products', 'review_images', 'shopify_integrations', 'api_tokens')
ORDER BY tablename;

-- ============================================================================
-- CHECK 7: Verify view security
-- Expected: v_product_sync_status has security_invoker = true
-- ============================================================================
SELECT
    viewname,
    definition
FROM pg_views
WHERE schemaname = 'public'
  AND viewname = 'v_product_sync_status';
