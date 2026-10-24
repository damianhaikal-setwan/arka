-- DATA-CHANGING OPERATION. Do not run before backup and review of
-- preview_renja_budget_reconciliation.sql. Recomputes only valid linked rows.
-- Historical invalid/orphan hierarchy rows are skipped and must be corrected explicitly.
BEGIN;
DO $$
DECLARE v_renja_id text;
BEGIN
  FOR v_renja_id IN SELECT id::text FROM public.renja ORDER BY tahun, kode LOOP
    PERFORM public.arka_refresh_renja_budget(v_renja_id);
  END LOOP;
END;
$$;
COMMIT;

-- Check afterward; rerun preview_renja_budget_reconciliation.sql.
