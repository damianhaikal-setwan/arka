-- ARKA v28b Renja Workspace implementation
-- Additive/idempotent migration. Run on the same Supabase project used by ARKA.
-- Does not delete or auto-link existing records. Review current RLS/policies separately.
BEGIN;

-- Document-level fields used by the Renja identity panel.
ALTER TABLE public.renja
  ADD COLUMN IF NOT EXISTS perangkat_daerah text,
  ADD COLUMN IF NOT EXISTS renstra_ref text,
  ADD COLUMN IF NOT EXISTS indikator text,
  ADD COLUMN IF NOT EXISTS target text,
  ADD COLUMN IF NOT EXISTS lokasi text,
  ADD COLUMN IF NOT EXISTS kelompok_sasaran text;

-- Annual Program rows in a Renja document.
ALTER TABLE public.program
  ADD COLUMN IF NOT EXISTS renja_ref text,
  ADD COLUMN IF NOT EXISTS tahun numeric,
  ADD COLUMN IF NOT EXISTS urusan_bidang text,
  ADD COLUMN IF NOT EXISTS indikator text,
  ADD COLUMN IF NOT EXISTS target text,
  ADD COLUMN IF NOT EXISTS lokasi text,
  ADD COLUMN IF NOT EXISTS kelompok_sasaran text,
  ADD COLUMN IF NOT EXISTS sumber_dana text,
  ADD COLUMN IF NOT EXISTS catatan_penting text,
  ADD COLUMN IF NOT EXISTS target_maju text,
  ADD COLUMN IF NOT EXISTS pagu_maju numeric,
  ADD COLUMN IF NOT EXISTS realisasi numeric,
  ADD COLUMN IF NOT EXISTS berlaku_mulai numeric,
  ADD COLUMN IF NOT EXISTS berlaku_sampai numeric;

-- Annual Kegiatan rows. Parent is an id/reference, validated by ARKA before write.
ALTER TABLE public.kegiatan
  ADD COLUMN IF NOT EXISTS renja_ref text,
  ADD COLUMN IF NOT EXISTS program text,
  ADD COLUMN IF NOT EXISTS tahun numeric,
  ADD COLUMN IF NOT EXISTS indikator text,
  ADD COLUMN IF NOT EXISTS target text,
  ADD COLUMN IF NOT EXISTS lokasi text,
  ADD COLUMN IF NOT EXISTS kelompok_sasaran text,
  ADD COLUMN IF NOT EXISTS sumber_dana text,
  ADD COLUMN IF NOT EXISTS catatan_penting text,
  ADD COLUMN IF NOT EXISTS target_maju text,
  ADD COLUMN IF NOT EXISTS pagu_maju numeric,
  ADD COLUMN IF NOT EXISTS realisasi numeric,
  ADD COLUMN IF NOT EXISTS berlaku_mulai numeric,
  ADD COLUMN IF NOT EXISTS berlaku_sampai numeric;

-- Annual Subkegiatan rows. Parent is an id/reference, validated by ARKA before write.
ALTER TABLE public.subkegiatan
  ADD COLUMN IF NOT EXISTS renja_ref text,
  ADD COLUMN IF NOT EXISTS kegiatan text,
  ADD COLUMN IF NOT EXISTS tahun numeric,
  ADD COLUMN IF NOT EXISTS indikator text,
  ADD COLUMN IF NOT EXISTS target text,
  ADD COLUMN IF NOT EXISTS lokasi text,
  ADD COLUMN IF NOT EXISTS kelompok_sasaran text,
  ADD COLUMN IF NOT EXISTS sumber_dana text,
  ADD COLUMN IF NOT EXISTS catatan_penting text,
  ADD COLUMN IF NOT EXISTS target_maju text,
  ADD COLUMN IF NOT EXISTS pagu_maju numeric,
  ADD COLUMN IF NOT EXISTS realisasi numeric,
  ADD COLUMN IF NOT EXISTS berlaku_mulai numeric,
  ADD COLUMN IF NOT EXISTS berlaku_sampai numeric;

CREATE INDEX IF NOT EXISTS idx_program_renja_ref ON public.program(renja_ref);
CREATE INDEX IF NOT EXISTS idx_kegiatan_renja_ref ON public.kegiatan(renja_ref);
CREATE INDEX IF NOT EXISTS idx_kegiatan_program ON public.kegiatan(program);
CREATE INDEX IF NOT EXISTS idx_subkegiatan_renja_ref ON public.subkegiatan(renja_ref);
CREATE INDEX IF NOT EXISTS idx_subkegiatan_kegiatan ON public.subkegiatan(kegiatan);

-- Server-side guard: validate document/year and parent-child relationships for
-- every new or changed annual planning row. Existing rows are not rewritten by
-- this migration; each row must be explicitly linked before it can be saved.
CREATE OR REPLACE FUNCTION public.arka_guard_renja_hierarchy()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  v_renja_year numeric;
  v_parent_renja text;
  v_parent_year numeric;
  v_grandparent_renja text;
  v_grandparent_year numeric;
  v_parent_program text;
  v_has_conflict boolean;
BEGIN
  IF NULLIF(btrim(NEW.renja_ref::text), '') IS NULL THEN
    RAISE EXCEPTION 'Rincian % wajib terhubung ke dokumen Renja.', TG_TABLE_NAME
      USING ERRCODE = '23514';
  END IF;

  SELECT r.tahun INTO v_renja_year
  FROM public.renja r
  WHERE r.id::text = btrim(NEW.renja_ref::text);
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Dokumen Renja % tidak ditemukan.', NEW.renja_ref
      USING ERRCODE = '23503';
  END IF;
  IF v_renja_year IS NULL THEN
    RAISE EXCEPTION 'Tahun dokumen Renja harus diisi sebelum menambah rincian.'
      USING ERRCODE = '23514';
  END IF;
  IF NEW.tahun IS NULL THEN
    NEW.tahun := v_renja_year;
  ELSIF NEW.tahun IS DISTINCT FROM v_renja_year THEN
    RAISE EXCEPTION 'Tahun rincian harus sama dengan tahun dokumen Renja (%) .', v_renja_year
      USING ERRCODE = '23514';
  END IF;
  IF NEW.berlaku_mulai IS NOT NULL AND NEW.tahun < NEW.berlaku_mulai THEN
    RAISE EXCEPTION 'Nomenklatur belum berlaku pada tahun Renja.' USING ERRCODE = '23514';
  END IF;
  IF NEW.berlaku_sampai IS NOT NULL AND NEW.tahun > NEW.berlaku_sampai THEN
    RAISE EXCEPTION 'Nomenklatur sudah tidak berlaku pada tahun Renja.' USING ERRCODE = '23514';
  END IF;

  IF TG_TABLE_NAME = 'kegiatan' THEN
    IF NULLIF(btrim(NEW.program::text), '') IS NULL THEN
      RAISE EXCEPTION 'Kegiatan wajib memilih Program induk.' USING ERRCODE = '23514';
    END IF;
    SELECT p.renja_ref::text, p.tahun INTO v_parent_renja, v_parent_year
    FROM public.program p WHERE p.id::text = btrim(NEW.program::text);
    IF NOT FOUND THEN
      RAISE EXCEPTION 'Program induk tidak ditemukan.' USING ERRCODE = '23503';
    END IF;
    IF v_parent_renja IS DISTINCT FROM btrim(NEW.renja_ref::text) THEN
      RAISE EXCEPTION 'Program induk harus berasal dari dokumen Renja yang sama.' USING ERRCODE = '23514';
    END IF;
    IF v_parent_year IS DISTINCT FROM NEW.tahun THEN
      RAISE EXCEPTION 'Tahun Program induk harus sama dengan tahun Kegiatan.' USING ERRCODE = '23514';
    END IF;
  ELSIF TG_TABLE_NAME = 'subkegiatan' THEN
    IF NULLIF(btrim(NEW.kegiatan::text), '') IS NULL THEN
      RAISE EXCEPTION 'Subkegiatan wajib memilih Kegiatan induk.' USING ERRCODE = '23514';
    END IF;
    SELECT k.renja_ref::text, k.tahun, k.program::text
      INTO v_parent_renja, v_parent_year, v_parent_program
    FROM public.kegiatan k WHERE k.id::text = btrim(NEW.kegiatan::text);
    IF NOT FOUND THEN
      RAISE EXCEPTION 'Kegiatan induk tidak ditemukan.' USING ERRCODE = '23503';
    END IF;
    IF v_parent_renja IS DISTINCT FROM btrim(NEW.renja_ref::text) THEN
      RAISE EXCEPTION 'Kegiatan induk harus berasal dari dokumen Renja yang sama.' USING ERRCODE = '23514';
    END IF;
    IF v_parent_year IS DISTINCT FROM NEW.tahun THEN
      RAISE EXCEPTION 'Tahun Kegiatan induk harus sama dengan tahun Subkegiatan.' USING ERRCODE = '23514';
    END IF;
    SELECT p.renja_ref::text, p.tahun INTO v_grandparent_renja, v_grandparent_year
    FROM public.program p WHERE p.id::text = btrim(v_parent_program);
    IF NOT FOUND OR v_grandparent_renja IS DISTINCT FROM btrim(NEW.renja_ref::text)
       OR v_grandparent_year IS DISTINCT FROM NEW.tahun THEN
      RAISE EXCEPTION 'Rantai Program → Kegiatan → Subkegiatan tidak konsisten.' USING ERRCODE = '23514';
    END IF;
  END IF;

  -- Prevent moving/re-dating a parent while its children would become orphaned.
  IF TG_OP = 'UPDATE' AND TG_TABLE_NAME = 'program'
     AND (OLD.renja_ref::text IS DISTINCT FROM NEW.renja_ref::text OR OLD.tahun IS DISTINCT FROM NEW.tahun) THEN
    SELECT EXISTS(SELECT 1 FROM public.kegiatan k
      WHERE k.program::text = NEW.id::text
        AND (
          (NULLIF(btrim(k.renja_ref::text), '') IS NOT NULL AND k.renja_ref::text IS DISTINCT FROM NEW.renja_ref::text)
          OR (k.tahun IS NOT NULL AND k.tahun IS DISTINCT FROM NEW.tahun
              AND k.renja_ref::text IS NOT DISTINCT FROM NEW.renja_ref::text)
        ))
      INTO v_has_conflict;
    IF v_has_conflict THEN
      RAISE EXCEPTION 'Program memiliki Kegiatan. Pindahkan seluruh hierarki melalui proses migrasi khusus.' USING ERRCODE = '23514';
    END IF;
  ELSIF TG_OP = 'UPDATE' AND TG_TABLE_NAME = 'kegiatan'
     AND (OLD.renja_ref::text IS DISTINCT FROM NEW.renja_ref::text OR OLD.tahun IS DISTINCT FROM NEW.tahun) THEN
    SELECT EXISTS(SELECT 1 FROM public.subkegiatan s
      WHERE s.kegiatan::text = NEW.id::text
        AND (
          (NULLIF(btrim(s.renja_ref::text), '') IS NOT NULL AND s.renja_ref::text IS DISTINCT FROM NEW.renja_ref::text)
          OR (s.tahun IS NOT NULL AND s.tahun IS DISTINCT FROM NEW.tahun
              AND s.renja_ref::text IS NOT DISTINCT FROM NEW.renja_ref::text)
        ))
      INTO v_has_conflict;
    IF v_has_conflict THEN
      RAISE EXCEPTION 'Kegiatan memiliki Subkegiatan. Pindahkan seluruh hierarki melalui proses migrasi khusus.' USING ERRCODE = '23514';
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_arka_guard_program_renja ON public.program;
CREATE TRIGGER trg_arka_guard_program_renja
BEFORE INSERT OR UPDATE ON public.program
FOR EACH ROW EXECUTE FUNCTION public.arka_guard_renja_hierarchy();
DROP TRIGGER IF EXISTS trg_arka_guard_kegiatan_renja ON public.kegiatan;
CREATE TRIGGER trg_arka_guard_kegiatan_renja
BEFORE INSERT OR UPDATE ON public.kegiatan
FOR EACH ROW EXECUTE FUNCTION public.arka_guard_renja_hierarchy();
DROP TRIGGER IF EXISTS trg_arka_guard_subkegiatan_renja ON public.subkegiatan;
CREATE TRIGGER trg_arka_guard_subkegiatan_renja
BEFORE INSERT OR UPDATE ON public.subkegiatan
FOR EACH ROW EXECUTE FUNCTION public.arka_guard_renja_hierarchy();

-- A Renja document year is immutable after linked detail rows exist. To create
-- a different planning year, make a new Renja document rather than silently
-- changing the period under existing children.
CREATE OR REPLACE FUNCTION public.arka_guard_renja_document_year()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE v_has_details boolean;
BEGIN
  IF NEW.tahun IS DISTINCT FROM OLD.tahun THEN
    SELECT EXISTS (
      SELECT 1 FROM public.program p WHERE p.renja_ref::text = OLD.id::text
      UNION ALL
      SELECT 1 FROM public.kegiatan k WHERE k.renja_ref::text = OLD.id::text
      UNION ALL
      SELECT 1 FROM public.subkegiatan s WHERE s.renja_ref::text = OLD.id::text
    ) INTO v_has_details;
    IF v_has_details THEN
      RAISE EXCEPTION 'Tahun dokumen Renja tidak dapat diubah setelah memiliki rincian. Buat dokumen Renja baru untuk tahun berbeda.' USING ERRCODE = '23514';
    END IF;
  END IF;
  RETURN NEW;
END;
$$;
DROP TRIGGER IF EXISTS trg_arka_guard_renja_document_year ON public.renja;
CREATE TRIGGER trg_arka_guard_renja_document_year
BEFORE UPDATE OF tahun ON public.renja
FOR EACH ROW EXECUTE FUNCTION public.arka_guard_renja_document_year();

-- Do not auto-link legacy records. The trigger validates writes, not untouched rows.
-- Inspect the Workspace's orphan list and connect each historical record explicitly.
COMMIT;
NOTIFY pgrst, 'reload schema';

-- Post-migration verification: this should return all expected fields.
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema='public'
  AND table_name IN ('renja','program','kegiatan','subkegiatan')
  AND column_name IN (
    'perangkat_daerah','renstra_ref','indikator','target','lokasi','kelompok_sasaran',
    'renja_ref','program','kegiatan','tahun','urusan_bidang','sumber_dana',
    'catatan_penting','target_maju','pagu_maju','realisasi','berlaku_mulai','berlaku_sampai'
  )
ORDER BY table_name, ordinal_position;
