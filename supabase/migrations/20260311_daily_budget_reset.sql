-- Daily budget reset function
-- Resets daily_budget_used to 0 for all users with swipe_payment_enabled
-- where budget_reset_at is NULL or before the start of today (UTC).
CREATE OR REPLACE FUNCTION reset_daily_budgets()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE user_settings
  SET
    daily_budget_used = 0,
    budget_reset_at = now(),
    updated_at = now()
  WHERE swipe_payment_enabled = true
    AND daily_budget > 0
    AND (budget_reset_at IS NULL OR budget_reset_at < date_trunc('day', now() AT TIME ZONE 'UTC'));
END;
$$;

-- Schedule daily reset at midnight UTC via pg_cron
SELECT cron.schedule(
  'reset-daily-budgets',
  '0 0 * * *',
  $$SELECT reset_daily_budgets()$$
);
