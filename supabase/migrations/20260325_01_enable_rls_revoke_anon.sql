-- ============================================================================
-- Migration: Enable RLS & Revoke Anonymous Access on Sensitive Tables
-- Date: 2026-03-25
-- Purpose: Fix ANON_ACCESS_WIDE, MISSING_RLS_ON_EXPOSED_TABLES, FULL_CRUD_EXPOSED
-- ============================================================================

-- ============================================================================
-- STEP 1: Enable RLS on tables that are missing it
-- Fixes: MISSING_RLS_ON_EXPOSED_TABLES (4 tables)
-- ============================================================================

ALTER TABLE IF EXISTS public.tax_document_downloads ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.sync_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.product_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.blocked_users ENABLE ROW LEVEL SECURITY;

-- Also ensure RLS is enabled on all other audited tables (idempotent)
ALTER TABLE IF EXISTS public.user_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.promotions ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.referrals ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.product_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.wishlists ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.product_conditions ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.conditions ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.video_products ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.stripe_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.password_reset_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.payment_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.subcategories ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.review_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.transactions ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- STEP 2: Revoke ALL access from anon on SENSITIVE tables
-- These tables should NEVER be readable by unauthenticated users
-- Fixes: ANON_ACCESS_WIDE, SENSITIVE_DATA_EXPOSED
-- ============================================================================

-- Password reset codes — extremely sensitive, service_role only
REVOKE ALL ON public.password_reset_codes FROM anon;
REVOKE ALL ON public.password_reset_codes FROM authenticated;

-- Sync logs — internal system table, service_role only
REVOKE ALL ON public.sync_logs FROM anon;
REVOKE ALL ON public.sync_logs FROM authenticated;

-- User settings (contains fcm_token, payment method IDs)
REVOKE ALL ON public.user_settings FROM anon;

-- Orders (contains shipping addresses, payment info, stripe IDs)
REVOKE ALL ON public.orders FROM anon;

-- Stripe accounts (contains account IDs, capabilities, requirements)
REVOKE ALL ON public.stripe_accounts FROM anon;

-- Payment methods (contains billing addresses, card info)
REVOKE ALL ON public.payment_methods FROM anon;

-- Transactions (contains stripe transfer IDs, amounts)
REVOKE ALL ON public.transactions FROM anon;

-- Tax document downloads (contains IP addresses, user agents)
REVOKE ALL ON public.tax_document_downloads FROM anon;

-- Wishlists (private user data)
REVOKE ALL ON public.wishlists FROM anon;

-- Blocked users (private user data)
REVOKE ALL ON public.blocked_users FROM anon;

-- Referrals (private user/commission data)
REVOKE ALL ON public.referrals FROM anon;

-- Promotions (seller-specific data)
REVOKE ALL ON public.promotions FROM anon;

-- ============================================================================
-- STEP 3: Grant authenticated role proper access on tables they need
-- ============================================================================

-- Private user tables: authenticated can SELECT/INSERT/UPDATE/DELETE their own rows (RLS enforces ownership)
GRANT SELECT, INSERT, UPDATE, DELETE ON public.user_settings TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.orders TO authenticated;
GRANT SELECT ON public.stripe_accounts TO authenticated;  -- writes via service_role/edge functions only
GRANT SELECT, INSERT, UPDATE, DELETE ON public.payment_methods TO authenticated;
GRANT SELECT ON public.transactions TO authenticated;
GRANT SELECT, INSERT, DELETE ON public.wishlists TO authenticated;
GRANT SELECT, INSERT, DELETE ON public.blocked_users TO authenticated;
GRANT SELECT ON public.referrals TO authenticated;
GRANT SELECT ON public.tax_document_downloads TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.promotions TO authenticated;

-- ============================================================================
-- STEP 4: Restrict write operations on reference/read-only tables
-- Fixes: FULL_CRUD_EXPOSED — these tables should be read-only for regular users
-- ============================================================================

-- Reference data tables: only SELECT allowed (admin manages via service_role)
REVOKE INSERT, UPDATE, DELETE ON public.conditions FROM anon, authenticated;
REVOKE INSERT, UPDATE, DELETE ON public.subcategories FROM anon, authenticated;

-- Junction/analytics tables: restrict writes appropriately
REVOKE INSERT, UPDATE, DELETE ON public.product_views FROM anon;
REVOKE UPDATE, DELETE ON public.product_views FROM authenticated;
GRANT SELECT, INSERT ON public.product_views TO authenticated;

REVOKE INSERT, UPDATE, DELETE ON public.review_images FROM anon;
GRANT SELECT, INSERT, DELETE ON public.review_images TO authenticated;

REVOKE INSERT, UPDATE, DELETE ON public.video_products FROM anon;
GRANT SELECT ON public.video_products TO authenticated;

-- product_tags and product_conditions: managed by product creation flow
REVOKE INSERT, UPDATE, DELETE ON public.product_tags FROM anon;
GRANT SELECT, INSERT, DELETE ON public.product_tags TO authenticated;

REVOKE INSERT, UPDATE, DELETE ON public.product_conditions FROM anon;
GRANT SELECT, INSERT, DELETE ON public.product_conditions TO authenticated;
