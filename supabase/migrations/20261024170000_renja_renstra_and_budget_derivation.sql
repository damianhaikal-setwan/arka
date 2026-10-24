-- ARKA: Renstra -> Renja derivation and server-side budget rollups.
-- Additive/idempotent schema change. This migration installs rules; it does NOT
-- backfill existing parent pagu values. Review preview_renja_budget_reconciliation.sql
-- and take a backup before running the separate backfill script.
BEGIN;

-- The existing UI already uses these fields, but the base schema did not declare
-- them. Add only missing columns so current Renstra/RPJMD data is preserved.
ALTER TABLE public.renstra
  ADD COLUMN IF NOT EXISTS jenis text,
  ADD COLUMN IF NOT EXISTS induk text,
  ADD COLUMN IF NOT EXISTS nspk text,
  ADD COLUMN IF NOT EXISTS rpjmd_ref text,
  ADD COLUMN IF NOT EXISTS indikator text,
  ADD COLUMN IF NOT EXISTS t2025 text,
  ADD COLUMN IF NOT EXISTS t2026 text,
  ADD COLUMN IF NOT EXISTS t2027 text,
  ADD COLUMN IF NOT EXISTS t2028 text,
  ADD COLUMN IF NOT EXISTS t2029 text,
  ADD COLUMN IF NOT EXISTS t2030 text,
  ADD COLUMN IF NOT EXISTS keterangan text;

-- Keep the upstream RPJMD form/schema consistent with the same annual target model.
ALTER TABLE public.rpjmd
  ADD COLUMN IF NOT EXISTS jenis text,
  ADD COLUMN IF NOT EXISTS induk text,
  ADD COLUMN IF NOT EXISTS visimisi text,
  ADD COLUMN IF NOT EXISTS indikator text,
  ADD COLUMN IF NOT EXISTS t2025 text,
  ADD COLUMN IF NOT EXISTS t2026 text,
  ADD COLUMN IF NOT EXISTS t2027 text,
  ADD COLUMN IF NOT EXISTS t2028 text,
  ADD COLUMN IF NOT EXISTS t2029 text,
  ADD COLUMN IF NOT EXISTS t2030 text,
  ADD COLUMN IF NOT EXISTS keterangan text;

-- The UI exposes Draft/Revisi. Preserve the prior valid values and make the
-- allowed values agree with the form before relying on the upstream source.
DO $$
DECLARE v_definition text;
BEGIN
  SELECT pg_get_constraintdef(oid) INTO v_definition
  FROM pg_constraint WHERE conrelid='public.renstra'::regclass AND conname='renstra_status_chk';
  IF v_definition IS NULL OR position('Revisi' IN v_definition)=0 THEN
    ALTER TABLE public.renstra DROP CONSTRAINT IF EXISTS renstra_status_chk;
    ALTER TABLE public.renstra ADD CONSTRAINT renstra_status_chk
      CHECK (status IS NULL OR status IN ('Draft','Berjalan','Selesai','Revisi')) NOT VALID;
    ALTER TABLE public.renstra VALIDATE CONSTRAINT renstra_status_chk;
  END IF;

  SELECT pg_get_constraintdef(oid) INTO v_definition
  FROM pg_constraint WHERE conrelid='public.rpjmd'::regclass AND conname='rpjmd_status_chk';
  IF v_definition IS NULL OR position('Draft' IN v_definition)=0 THEN
    ALTER TABLE public.rpjmd DROP CONSTRAINT IF EXISTS rpjmd_status_chk;
    ALTER TABLE public.rpjmd ADD CONSTRAINT rpjmd_status_chk
      CHECK (status IS NULL OR status IN ('Draft','Berjalan','Selesai','Revisi')) NOT VALID;
    ALTER TABLE public.rpjmd VALIDATE CONSTRAINT rpjmd_status_chk;
  END IF;
END;
$$;

-- Only rows linked to a Renja are derived. Legacy Program/Kegiatan rows with a
-- NULL Renja reference keep their existing pagu and behavior.
CREATE OR REPLACE FUNCTION public.arka_derive_renja_pagu_before_write()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
BEGIN
  IF TG_TABLE_NAME = 'renja' THEN
    SELECT COALESCE(SUM(p.pagu), 0)
      INTO NEW.pagu
    FROM public.program p
    WHERE p.renja_ref::text = NEW.id::text
      AND p.tahun = NEW.tahun;
  ELSIF TG_TABLE_NAME = 'program' THEN
    IF NULLIF(BTRIM(NEW.renja_ref::text), '') IS NOT NULL THEN
      SELECT COALESCE(SUM(k.pagu), 0)
        INTO NEW.pagu
      FROM public.kegiatan k
      WHERE k.program::text = NEW.id::text
        AND k.renja_ref::text = NEW.renja_ref::text
        AND k.tahun = NEW.tahun;
    END IF;
  ELSIF TG_TABLE_NAME = 'kegiatan' THEN
    IF NULLIF(BTRIM(NEW.renja_ref::text), '') IS NOT NULL THEN
      SELECT COALESCE(SUM(s.pagu), 0)
        INTO NEW.pagu
      FROM public.subkegiatan s
      WHERE s.kegiatan::text = NEW.id::text
        AND s.renja_ref::text = NEW.renja_ref::text
        AND s.tahun = NEW.tahun;
    END IF;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_arka_derive_renja_pagu ON public.renja;
CREATE TRIGGER trg_arka_derive_renja_pagu
BEFORE INSERT OR UPDATE ON public.renja
FOR EACH ROW EXECUTE FUNCTION public.arka_derive_renja_pagu_before_write();

DROP TRIGGER IF EXISTS trg_arka_derive_program_pagu ON public.program;
CREATE TRIGGER trg_arka_derive_program_pagu
BEFORE INSERT OR UPDATE ON public.program
FOR EACH ROW EXECUTE FUNCTION public.arka_derive_renja_pagu_before_write();

DROP TRIGGER IF EXISTS trg_arka_derive_kegiatan_pagu ON public.kegiatan;
CREATE TRIGGER trg_arka_derive_kegiatan_pagu
BEFORE INSERT OR UPDATE ON public.kegiatan
FOR EACH ROW EXECUTE FUNCTION public.arka_derive_renja_pagu_before_write();

-- Reconcile valid rows for one document, deepest level first. Historical rows
-- with a broken/mismatched hierarchy are skipped and reported by verification;
-- they are never auto-linked or silently assigned to a different parent.
CREATE OR REPLACE FUNCTION public.arka_refresh_renja_budget(p_renja_id text)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
BEGIN
  IF NULLIF(BTRIM(p_renja_id), '') IS NULL THEN
    RETURN;
  END IF;

  UPDATE public.kegiatan k
     SET pagu = COALESCE((
       SELECT SUM(s.pagu)
       FROM public.subkegiatan s
       WHERE s.kegiatan::text = k.id::text
         AND s.renja_ref::text = k.renja_ref::text
         AND s.tahun = k.tahun
     ), 0)
   WHERE k.renja_ref::text = p_renja_id
     AND EXISTS (SELECT 1 FROM public.renja r WHERE r.id::text = k.renja_ref::text AND r.tahun = k.tahun)
     AND EXISTS (SELECT 1 FROM public.program p WHERE p.id::text = k.program::text AND p.renja_ref::text = k.renja_ref::text AND p.tahun = k.tahun)
     AND k.pagu IS DISTINCT FROM COALESCE((
       SELECT SUM(s.pagu)
       FROM public.subkegiatan s
       WHERE s.kegiatan::text = k.id::text
         AND s.renja_ref::text = k.renja_ref::text
         AND s.tahun = k.tahun
     ), 0);

  UPDATE public.program p
     SET pagu = COALESCE((
       SELECT SUM(k.pagu)
       FROM public.kegiatan k
       WHERE k.program::text = p.id::text
         AND k.renja_ref::text = p.renja_ref::text
         AND k.tahun = p.tahun
     ), 0)
   WHERE p.renja_ref::text = p_renja_id
     AND EXISTS (SELECT 1 FROM public.renja r WHERE r.id::text = p.renja_ref::text AND r.tahun = p.tahun)
     AND p.pagu IS DISTINCT FROM COALESCE((
       SELECT SUM(k.pagu)
       FROM public.kegiatan k
       WHERE k.program::text = p.id::text
         AND k.renja_ref::text = p.renja_ref::text
         AND k.tahun = p.tahun
     ), 0);

  UPDATE public.renja r
     SET pagu = COALESCE((
       SELECT SUM(p.pagu)
       FROM public.program p
       WHERE p.renja_ref::text = r.id::text
         AND p.tahun = r.tahun
     ), 0)
   WHERE r.id::text = p_renja_id
     AND r.pagu IS DISTINCT FROM COALESCE((
       SELECT SUM(p.pagu)
       FROM public.program p
       WHERE p.renja_ref::text = r.id::text
         AND p.tahun = r.tahun
     ), 0);
END;
$$;

CREATE OR REPLACE FUNCTION public.arka_sync_renja_budget_after_child_write()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
DECLARE v_old_doc text; v_new_doc text;
BEGIN
  IF TG_OP <> 'INSERT' THEN v_old_doc := NULLIF(BTRIM(OLD.renja_ref::text), ''); END IF;
  IF TG_OP <> 'DELETE' THEN v_new_doc := NULLIF(BTRIM(NEW.renja_ref::text), ''); END IF;

  IF v_old_doc IS NOT NULL THEN
    PERFORM public.arka_refresh_renja_budget(v_old_doc);
  END IF;
  IF v_new_doc IS NOT NULL AND v_new_doc IS DISTINCT FROM v_old_doc THEN
    PERFORM public.arka_refresh_renja_budget(v_new_doc);
  ELSIF v_new_doc IS NOT NULL AND TG_OP = 'INSERT' THEN
    PERFORM public.arka_refresh_renja_budget(v_new_doc);
  END IF;
  RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_arka_sync_budget_subkegiatan ON public.subkegiatan;
CREATE TRIGGER trg_arka_sync_budget_subkegiatan
AFTER INSERT OR DELETE OR UPDATE OF pagu, kegiatan, renja_ref, tahun ON public.subkegiatan
FOR EACH ROW EXECUTE FUNCTION public.arka_sync_renja_budget_after_child_write();

DROP TRIGGER IF EXISTS trg_arka_sync_budget_kegiatan ON public.kegiatan;
CREATE TRIGGER trg_arka_sync_budget_kegiatan
AFTER INSERT OR DELETE OR UPDATE OF pagu, program, renja_ref, tahun ON public.kegiatan
FOR EACH ROW EXECUTE FUNCTION public.arka_sync_renja_budget_after_child_write();

DROP TRIGGER IF EXISTS trg_arka_sync_budget_program ON public.program;
CREATE TRIGGER trg_arka_sync_budget_program
AFTER INSERT OR DELETE OR UPDATE OF pagu, renja_ref, tahun ON public.program
FOR EACH ROW EXECUTE FUNCTION public.arka_sync_renja_budget_after_child_write();

COMMENT ON FUNCTION public.arka_refresh_renja_budget(text) IS
  'Recalculates valid Renja leaf-to-document pagu rollups. Does not auto-link invalid or historical records.';

-- The refresh entry point may be called by database owners/migrations, not directly
-- by client roles. Trigger functions invoke it under their definer privileges.
REVOKE ALL ON FUNCTION public.arka_refresh_renja_budget(text) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.arka_derive_renja_pagu_before_write() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.arka_sync_renja_budget_after_child_write() FROM PUBLIC, anon, authenticated;

COMMIT;
NOTIFY pgrst, 'reload schema';
