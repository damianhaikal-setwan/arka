-- ARKA Renja Workspace guardrails (follow-up to 20261024_renja_workspace_implementation.sql).
-- Additive/idempotent: does not relink or delete existing records.
-- Apply in staging after backing up the target database.
BEGIN;

-- The current UI creates Program and Kegiatan rows with status = 'Draft', while
-- the base schema's check constraints did not allow Draft for these two tables.
DO $$
DECLARE
  v_definition text;
BEGIN
  SELECT pg_get_constraintdef(oid) INTO v_definition
  FROM pg_constraint
  WHERE conrelid = 'public.program'::regclass AND conname = 'program_status_chk';
  IF v_definition IS NULL OR position('Draft' IN v_definition) = 0 THEN
    ALTER TABLE public.program DROP CONSTRAINT IF EXISTS program_status_chk;
    ALTER TABLE public.program
      ADD CONSTRAINT program_status_chk
      CHECK (status IS NULL OR status IN ('Draft', 'Berjalan', 'Selesai', 'Terlambat')) NOT VALID;
    ALTER TABLE public.program VALIDATE CONSTRAINT program_status_chk;
  END IF;

  SELECT pg_get_constraintdef(oid) INTO v_definition
  FROM pg_constraint
  WHERE conrelid = 'public.kegiatan'::regclass AND conname = 'kegiatan_status_chk';
  IF v_definition IS NULL OR position('Draft' IN v_definition) = 0 THEN
    ALTER TABLE public.kegiatan DROP CONSTRAINT IF EXISTS kegiatan_status_chk;
    ALTER TABLE public.kegiatan
      ADD CONSTRAINT kegiatan_status_chk
      CHECK (status IS NULL OR status IN ('Draft', 'Berjalan', 'Selesai', 'Terlambat')) NOT VALID;
    ALTER TABLE public.kegiatan VALIDATE CONSTRAINT kegiatan_status_chk;
  END IF;
END;
$$;

-- Renja references were validated by a trigger but were not backed by foreign
-- keys. NOT VALID preserves legacy rows for review while enforcing new/changed
-- references and prevents deleting a Renja document that still has linked rows.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'public.program'::regclass AND conname = 'program_renja_ref_fkey'
  ) THEN
    ALTER TABLE public.program
      ADD CONSTRAINT program_renja_ref_fkey
      FOREIGN KEY (renja_ref) REFERENCES public.renja(id) ON DELETE RESTRICT NOT VALID;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'public.kegiatan'::regclass AND conname = 'kegiatan_renja_ref_fkey'
  ) THEN
    ALTER TABLE public.kegiatan
      ADD CONSTRAINT kegiatan_renja_ref_fkey
      FOREIGN KEY (renja_ref) REFERENCES public.renja(id) ON DELETE RESTRICT NOT VALID;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'public.subkegiatan'::regclass AND conname = 'subkegiatan_renja_ref_fkey'
  ) THEN
    ALTER TABLE public.subkegiatan
      ADD CONSTRAINT subkegiatan_renja_ref_fkey
      FOREIGN KEY (renja_ref) REFERENCES public.renja(id) ON DELETE RESTRICT NOT VALID;
  END IF;
END;
$$;

COMMENT ON CONSTRAINT program_renja_ref_fkey ON public.program IS
  'Protects valid Renja references; legacy validation deferred for explicit review.';
COMMENT ON CONSTRAINT kegiatan_renja_ref_fkey ON public.kegiatan IS
  'Protects valid Renja references; legacy validation deferred for explicit review.';
COMMENT ON CONSTRAINT subkegiatan_renja_ref_fkey ON public.subkegiatan IS
  'Protects valid Renja references; legacy validation deferred for explicit review.';

COMMIT;
NOTIFY pgrst, 'reload schema';

-- Inspect the effective status and reference constraints after migration.
SELECT c.conrelid::regclass AS table_name, c.conname, pg_get_constraintdef(c.oid) AS definition,
       c.convalidated AS validated
FROM pg_constraint c
WHERE c.conrelid IN ('public.program'::regclass, 'public.kegiatan'::regclass, 'public.subkegiatan'::regclass)
  AND c.conname IN (
    'program_status_chk', 'kegiatan_status_chk',
    'program_renja_ref_fkey', 'kegiatan_renja_ref_fkey', 'subkegiatan_renja_ref_fkey'
  )
ORDER BY table_name::text, c.conname;
