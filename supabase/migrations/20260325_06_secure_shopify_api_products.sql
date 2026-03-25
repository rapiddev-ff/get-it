-- ============================================================================
-- Migration: Secure shopify_integrations, api_tokens, product_shopify_mapping, products
-- Date: 2026-03-25
-- Purpose: Fix remaining SENSITIVE_COLUMNS warnings
--   - shopify_integrations: access_token, webhook_secret
--   - api_tokens: access_token, refresh_token
--   - product_shopify_mapping: shopify_data_hash, cardsmart_data_hash
--   - products: shipping columns (RLS + proper policies)
-- ============================================================================

-- ============================================================================
-- 1. shopify_integrations — CRITICAL: access_token, webhook_secret exposed
--    Owner: user_id
-- ============================================================================

ALTER TABLE IF EXISTS public.shopify_integrations ENABLE ROW LEVEL SECURITY;

-- Revoke all from anon
REVOKE ALL ON public.shopify_integrations FROM anon;

-- Drop any existing permissive policies
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'shopify_integrations' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.shopify_integrations', pol.policyname); END LOOP;
END $$;

-- Owner-only access (authenticated users see only their own integrations)
CREATE POLICY "shopify_integrations_select_own"
    ON public.shopify_integrations FOR SELECT
    TO authenticated
    USING (user_id = auth.uid() AND deleted_at IS NULL);

CREATE POLICY "shopify_integrations_insert_own"
    ON public.shopify_integrations FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "shopify_integrations_update_own"
    ON public.shopify_integrations FOR UPDATE
    TO authenticated
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "shopify_integrations_delete_own"
    ON public.shopify_integrations FOR DELETE
    TO authenticated
    USING (user_id = auth.uid());

-- ============================================================================
-- 2. api_tokens — CRITICAL: access_token, refresh_token exposed
--    May or may not exist in the database. Using IF EXISTS throughout.
-- ============================================================================

ALTER TABLE IF EXISTS public.api_tokens ENABLE ROW LEVEL SECURITY;

-- Revoke all from anon and authenticated (service_role only by default)
REVOKE ALL ON public.api_tokens FROM anon;
REVOKE ALL ON public.api_tokens FROM authenticated;

-- Drop any existing policies
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'api_tokens' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.api_tokens', pol.policyname); END LOOP;
END $$;

-- If api_tokens has a user_id column, allow owner read-only access
-- Writes should only happen via service_role/edge functions
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'public' AND table_name = 'api_tokens' AND column_name = 'user_id'
    ) THEN
        EXECUTE '
            CREATE POLICY "api_tokens_select_own"
                ON public.api_tokens FOR SELECT
                TO authenticated
                USING (user_id = auth.uid())';
        -- Grant SELECT only — token creation/refresh via service_role
        EXECUTE 'GRANT SELECT ON public.api_tokens TO authenticated';
    END IF;
END $$;

-- ============================================================================
-- 3. product_shopify_mapping — shopify_data_hash, cardsmart_data_hash exposed
--    Owner: indirect via integration_id → shopify_integrations.user_id
--           or via product_id → products.seller_id
-- ============================================================================

ALTER TABLE IF EXISTS public.product_shopify_mapping ENABLE ROW LEVEL SECURITY;

-- Revoke all from anon
REVOKE ALL ON public.product_shopify_mapping FROM anon;

-- Drop any existing policies
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'product_shopify_mapping' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.product_shopify_mapping', pol.policyname); END LOOP;
END $$;

-- Authenticated grant
GRANT SELECT, INSERT, UPDATE, DELETE ON public.product_shopify_mapping TO authenticated;

-- Seller can view/manage mappings for their own products
CREATE POLICY "product_shopify_mapping_select_seller"
    ON public.product_shopify_mapping FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.products p
            WHERE p.id = product_id AND p.seller_id = auth.uid()
        )
    );

CREATE POLICY "product_shopify_mapping_insert_seller"
    ON public.product_shopify_mapping FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.products p
            WHERE p.id = product_id AND p.seller_id = auth.uid()
        )
    );

CREATE POLICY "product_shopify_mapping_update_seller"
    ON public.product_shopify_mapping FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.products p
            WHERE p.id = product_id AND p.seller_id = auth.uid()
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.products p
            WHERE p.id = product_id AND p.seller_id = auth.uid()
        )
    );

CREATE POLICY "product_shopify_mapping_delete_seller"
    ON public.product_shopify_mapping FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.products p
            WHERE p.id = product_id AND p.seller_id = auth.uid()
        )
    );

-- ============================================================================
-- 4. products — shipping columns flagged as sensitive
--    Products must be publicly readable (marketplace), but writes limited to seller
--    Ensure RLS is enabled with proper policies
-- ============================================================================

ALTER TABLE IF EXISTS public.products ENABLE ROW LEVEL SECURITY;

-- Drop any existing policies
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'products' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.products', pol.policyname); END LOOP;
END $$;

-- Public read: anyone can browse active products (marketplace requirement)
-- Only published, non-deleted products are visible to the public
CREATE POLICY "products_select_public"
    ON public.products FOR SELECT
    TO anon, authenticated
    USING (
        status = 'active' AND deleted_at IS NULL
    );

-- Seller can see ALL their own products (including drafts, sold, inactive)
CREATE POLICY "products_select_own_all"
    ON public.products FOR SELECT
    TO authenticated
    USING (seller_id = auth.uid());

-- Seller can create products
CREATE POLICY "products_insert_seller"
    ON public.products FOR INSERT
    TO authenticated
    WITH CHECK (seller_id = auth.uid());

-- Seller can update their own products
CREATE POLICY "products_update_seller"
    ON public.products FOR UPDATE
    TO authenticated
    USING (seller_id = auth.uid())
    WITH CHECK (seller_id = auth.uid());

-- Seller can delete (soft-delete) their own products
CREATE POLICY "products_delete_seller"
    ON public.products FOR DELETE
    TO authenticated
    USING (seller_id = auth.uid());

-- ============================================================================
-- 5. Ensure shopify_integrations also has FORCE RLS for safety
-- ============================================================================

ALTER TABLE IF EXISTS public.shopify_integrations FORCE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.api_tokens FORCE ROW LEVEL SECURITY;

-- Service role bypass for tables that edge functions need
CREATE POLICY "service_role_bypass_shopify_integrations"
    ON public.shopify_integrations FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.tables
        WHERE table_schema = 'public' AND table_name = 'api_tokens'
    ) THEN
        EXECUTE '
            CREATE POLICY "service_role_bypass_api_tokens"
                ON public.api_tokens FOR ALL
                TO service_role
                USING (true)
                WITH CHECK (true)';
    END IF;
END $$;
