-- ============================================================================
-- Migration: Add/Fix RLS Policies for All Exposed Tables
-- Date: 2026-03-25
-- Purpose: Fix PERMISSIVE_RLS_POLICIES, add proper ownership-based policies
-- ============================================================================

-- ============================================================================
-- Helper: Drop existing overly permissive policies before creating proper ones
-- We drop by known common names, then create with explicit names
-- ============================================================================

-- ============================================================================
-- 1. user_settings — owner access only
-- ============================================================================
DROP POLICY IF EXISTS "Users can view own settings" ON public.user_settings;
DROP POLICY IF EXISTS "Users can insert own settings" ON public.user_settings;
DROP POLICY IF EXISTS "Users can update own settings" ON public.user_settings;
DROP POLICY IF EXISTS "Users can delete own settings" ON public.user_settings;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.user_settings;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.user_settings;
DROP POLICY IF EXISTS "Enable update for users based on id" ON public.user_settings;
DROP POLICY IF EXISTS "Enable delete for users based on id" ON public.user_settings;
-- Drop any catch-all permissive policies
DO $$
DECLARE
    pol RECORD;
BEGIN
    FOR pol IN
        SELECT policyname FROM pg_policies
        WHERE tablename = 'user_settings' AND schemaname = 'public'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.user_settings', pol.policyname);
    END LOOP;
END $$;

CREATE POLICY "user_settings_select_own"
    ON public.user_settings FOR SELECT
    TO authenticated
    USING (user_id = auth.uid());

CREATE POLICY "user_settings_insert_own"
    ON public.user_settings FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "user_settings_update_own"
    ON public.user_settings FOR UPDATE
    TO authenticated
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "user_settings_delete_own"
    ON public.user_settings FOR DELETE
    TO authenticated
    USING (user_id = auth.uid());

-- ============================================================================
-- 2. orders — buyer and seller can view their own orders
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'orders' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.orders', pol.policyname); END LOOP;
END $$;

CREATE POLICY "orders_select_participant"
    ON public.orders FOR SELECT
    TO authenticated
    USING (buyer_id = auth.uid() OR seller_id = auth.uid());

CREATE POLICY "orders_insert_buyer"
    ON public.orders FOR INSERT
    TO authenticated
    WITH CHECK (buyer_id = auth.uid());

CREATE POLICY "orders_update_participant"
    ON public.orders FOR UPDATE
    TO authenticated
    USING (buyer_id = auth.uid() OR seller_id = auth.uid())
    WITH CHECK (buyer_id = auth.uid() OR seller_id = auth.uid());

-- No direct DELETE — orders should be soft-deleted via service_role

-- ============================================================================
-- 3. stripe_accounts — owner read only (writes via edge functions)
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'stripe_accounts' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.stripe_accounts', pol.policyname); END LOOP;
END $$;

CREATE POLICY "stripe_accounts_select_own"
    ON public.stripe_accounts FOR SELECT
    TO authenticated
    USING (user_id = auth.uid());

-- ============================================================================
-- 4. payment_methods — owner access only
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'payment_methods' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.payment_methods', pol.policyname); END LOOP;
END $$;

CREATE POLICY "payment_methods_select_own"
    ON public.payment_methods FOR SELECT
    TO authenticated
    USING (user_id = auth.uid());

CREATE POLICY "payment_methods_insert_own"
    ON public.payment_methods FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "payment_methods_update_own"
    ON public.payment_methods FOR UPDATE
    TO authenticated
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "payment_methods_delete_own"
    ON public.payment_methods FOR DELETE
    TO authenticated
    USING (user_id = auth.uid());

-- ============================================================================
-- 5. transactions — owner read only
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'transactions' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.transactions', pol.policyname); END LOOP;
END $$;

CREATE POLICY "transactions_select_own"
    ON public.transactions FOR SELECT
    TO authenticated
    USING (user_id = auth.uid());

-- ============================================================================
-- 6. wishlists — owner access only
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'wishlists' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.wishlists', pol.policyname); END LOOP;
END $$;

CREATE POLICY "wishlists_select_own"
    ON public.wishlists FOR SELECT
    TO authenticated
    USING (user_id = auth.uid());

CREATE POLICY "wishlists_insert_own"
    ON public.wishlists FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "wishlists_delete_own"
    ON public.wishlists FOR DELETE
    TO authenticated
    USING (user_id = auth.uid());

-- ============================================================================
-- 7. blocked_users — blocker can manage their blocks
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'blocked_users' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.blocked_users', pol.policyname); END LOOP;
END $$;

CREATE POLICY "blocked_users_select_own"
    ON public.blocked_users FOR SELECT
    TO authenticated
    USING (blocker_id = auth.uid());

CREATE POLICY "blocked_users_insert_own"
    ON public.blocked_users FOR INSERT
    TO authenticated
    WITH CHECK (blocker_id = auth.uid());

CREATE POLICY "blocked_users_delete_own"
    ON public.blocked_users FOR DELETE
    TO authenticated
    USING (blocker_id = auth.uid());

-- ============================================================================
-- 8. referrals — participants can view their own referrals
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'referrals' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.referrals', pol.policyname); END LOOP;
END $$;

CREATE POLICY "referrals_select_participant"
    ON public.referrals FOR SELECT
    TO authenticated
    USING (referrer_id = auth.uid() OR referred_id = auth.uid());

-- ============================================================================
-- 9. tax_document_downloads — owner read only
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'tax_document_downloads' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.tax_document_downloads', pol.policyname); END LOOP;
END $$;

CREATE POLICY "tax_downloads_select_own"
    ON public.tax_document_downloads FOR SELECT
    TO authenticated
    USING (user_id = auth.uid());

-- ============================================================================
-- 10. promotions — seller can manage their own promotions
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'promotions' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.promotions', pol.policyname); END LOOP;
END $$;

CREATE POLICY "promotions_select_own"
    ON public.promotions FOR SELECT
    TO authenticated
    USING (seller_id = auth.uid());

CREATE POLICY "promotions_insert_own"
    ON public.promotions FOR INSERT
    TO authenticated
    WITH CHECK (seller_id = auth.uid());

CREATE POLICY "promotions_update_own"
    ON public.promotions FOR UPDATE
    TO authenticated
    USING (seller_id = auth.uid())
    WITH CHECK (seller_id = auth.uid());

-- ============================================================================
-- 11. password_reset_codes — NO access for any role (service_role only)
-- RLS enabled + no policies = only service_role can access
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'password_reset_codes' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.password_reset_codes', pol.policyname); END LOOP;
END $$;

-- No policies created — only service_role/edge functions can access this table

-- ============================================================================
-- 12. sync_logs — NO access for any role (service_role only)
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'sync_logs' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.sync_logs', pol.policyname); END LOOP;
END $$;

-- No policies created — only service_role can access this table

-- ============================================================================
-- 13. product_views — authenticated can insert, seller can view own product views
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'product_views' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.product_views', pol.policyname); END LOOP;
END $$;

CREATE POLICY "product_views_insert_authenticated"
    ON public.product_views FOR INSERT
    TO authenticated
    WITH CHECK (viewer_id = auth.uid());

CREATE POLICY "product_views_select_via_product"
    ON public.product_views FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.products p
            WHERE p.id = product_id AND p.seller_id = auth.uid()
        )
        OR viewer_id = auth.uid()
    );

-- ============================================================================
-- 14. conditions — public read-only (reference data needed before auth)
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'conditions' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.conditions', pol.policyname); END LOOP;
END $$;

CREATE POLICY "conditions_select_all"
    ON public.conditions FOR SELECT
    TO anon, authenticated
    USING (true);

-- ============================================================================
-- 15. subcategories — public read-only (reference data needed before auth)
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'subcategories' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.subcategories', pol.policyname); END LOOP;
END $$;

CREATE POLICY "subcategories_select_all"
    ON public.subcategories FOR SELECT
    TO anon, authenticated
    USING (true);

-- ============================================================================
-- 16. product_tags — public read (needed for product display)
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'product_tags' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.product_tags', pol.policyname); END LOOP;
END $$;

CREATE POLICY "product_tags_select_all"
    ON public.product_tags FOR SELECT
    TO anon, authenticated
    USING (true);

CREATE POLICY "product_tags_insert_seller"
    ON public.product_tags FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.products p
            WHERE p.id = product_id AND p.seller_id = auth.uid()
        )
    );

CREATE POLICY "product_tags_delete_seller"
    ON public.product_tags FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.products p
            WHERE p.id = product_id AND p.seller_id = auth.uid()
        )
    );

-- ============================================================================
-- 17. product_conditions — public read (needed for product display)
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'product_conditions' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.product_conditions', pol.policyname); END LOOP;
END $$;

CREATE POLICY "product_conditions_select_all"
    ON public.product_conditions FOR SELECT
    TO anon, authenticated
    USING (true);

CREATE POLICY "product_conditions_insert_seller"
    ON public.product_conditions FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.products p
            WHERE p.id = product_id AND p.seller_id = auth.uid()
        )
    );

CREATE POLICY "product_conditions_delete_seller"
    ON public.product_conditions FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.products p
            WHERE p.id = product_id AND p.seller_id = auth.uid()
        )
    );

-- ============================================================================
-- 18. video_products — public read (displayed with videos)
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'video_products' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.video_products', pol.policyname); END LOOP;
END $$;

CREATE POLICY "video_products_select_all"
    ON public.video_products FOR SELECT
    TO anon, authenticated
    USING (true);

-- ============================================================================
-- 19. review_images — public read (displayed with reviews)
-- ============================================================================
DO $$
DECLARE pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'review_images' AND schemaname = 'public'
    LOOP EXECUTE format('DROP POLICY IF EXISTS %I ON public.review_images', pol.policyname); END LOOP;
END $$;

CREATE POLICY "review_images_select_all"
    ON public.review_images FOR SELECT
    TO anon, authenticated
    USING (true);

CREATE POLICY "review_images_insert_reviewer"
    ON public.review_images FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.reviews r
            WHERE r.id = review_id AND r.reviewer_id = auth.uid()
        )
    );

CREATE POLICY "review_images_delete_reviewer"
    ON public.review_images FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.reviews r
            WHERE r.id = review_id AND r.reviewer_id = auth.uid()
        )
    );
