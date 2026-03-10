-- ============================================================================
-- GT-65 Orders Epic: Step 1 — Add 'sale_pending' to order_status ENUM
-- Must be committed separately before it can be used in indexes/functions.
-- ============================================================================

ALTER TYPE public.order_status ADD VALUE IF NOT EXISTS 'sale_pending' BEFORE 'paid';
