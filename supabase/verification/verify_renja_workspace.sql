-- READ-ONLY verification queries. Safe to run after migration; no writes.

-- 1) Expected columns and whether each one exists.
WITH expected(table_name, column_name) AS (
  VALUES
    ('renja','perangkat_daerah'),('renja','renstra_ref'),('renja','indikator'),
    ('renja','target'),('renja','lokasi'),('renja','kelompok_sasaran'),
    ('program','renja_ref'),('program','tahun'),('program','urusan_bidang'),
    ('program','indikator'),('program','target'),('program','lokasi'),
    ('program','kelompok_sasaran'),('program','sumber_dana'),('program','catatan_penting'),
    ('program','target_maju'),('program','pagu_maju'),('program','berlaku_mulai'),('program','berlaku_sampai'),
    ('kegiatan','renja_ref'),('kegiatan','program'),('kegiatan','tahun'),
    ('kegiatan','indikator'),('kegiatan','target'),('kegiatan','lokasi'),('kegiatan','kelompok_sasaran'),
    ('kegiatan','sumber_dana'),('kegiatan','catatan_penting'),('kegiatan','target_maju'),
    ('kegiatan','pagu_maju'),('kegiatan','berlaku_mulai'),('kegiatan','berlaku_sampai'),
    ('subkegiatan','renja_ref'),('subkegiatan','kegiatan'),('subkegiatan','tahun'),
    ('subkegiatan','indikator'),('subkegiatan','target'),('subkegiatan','lokasi'),
    ('subkegiatan','kelompok_sasaran'),('subkegiatan','sumber_dana'),('subkegiatan','catatan_penting'),
    ('subkegiatan','target_maju'),('subkegiatan','pagu_maju'),('subkegiatan','berlaku_mulai'),('subkegiatan','berlaku_sampai')
)
SELECT e.table_name, e.column_name,
       CASE WHEN c.column_name IS NULL THEN 'MISSING' ELSE 'OK' END AS status
FROM expected e
LEFT JOIN information_schema.columns c
  ON c.table_schema='public' AND c.table_name=e.table_name AND c.column_name=e.column_name
ORDER BY e.table_name, e.column_name;

-- 2) Counts and orphan rows; inspect before migrating historical records.
SELECT 'renja' AS table_name, count(*) AS total FROM public.renja
UNION ALL SELECT 'program', count(*) FROM public.program
UNION ALL SELECT 'kegiatan', count(*) FROM public.kegiatan
UNION ALL SELECT 'subkegiatan', count(*) FROM public.subkegiatan;

SELECT 'program' AS table_name, count(*) AS orphan_count
FROM public.program WHERE NULLIF(btrim(renja_ref::text),'') IS NULL
UNION ALL SELECT 'kegiatan', count(*)
FROM public.kegiatan WHERE NULLIF(btrim(renja_ref::text),'') IS NULL
UNION ALL SELECT 'subkegiatan', count(*)
FROM public.subkegiatan WHERE NULLIF(btrim(renja_ref::text),'') IS NULL;

-- 3) Detect child-parent and year mismatches without modifying any rows.
SELECT k.id AS kegiatan_id, k.renja_ref AS kegiatan_renja_ref, k.tahun AS kegiatan_tahun,
       p.id AS program_id, p.renja_ref AS program_renja_ref, p.tahun AS program_tahun
FROM public.kegiatan k
LEFT JOIN public.program p ON p.id::text=k.program::text
WHERE p.id IS NULL OR k.renja_ref::text IS DISTINCT FROM p.renja_ref::text
   OR k.tahun IS DISTINCT FROM p.tahun;

SELECT s.id AS subkegiatan_id, s.renja_ref AS subkegiatan_renja_ref, s.tahun AS subkegiatan_tahun,
       k.id AS kegiatan_id, k.renja_ref AS kegiatan_renja_ref, k.tahun AS kegiatan_tahun,
       p.id AS program_id, p.renja_ref AS program_renja_ref, p.tahun AS program_tahun
FROM public.subkegiatan s
LEFT JOIN public.kegiatan k ON k.id::text=s.kegiatan::text
LEFT JOIN public.program p ON p.id::text=k.program::text
WHERE k.id IS NULL OR p.id IS NULL
   OR s.renja_ref::text IS DISTINCT FROM k.renja_ref::text
   OR s.tahun IS DISTINCT FROM k.tahun
   OR s.renja_ref::text IS DISTINCT FROM p.renja_ref::text
   OR s.tahun IS DISTINCT FROM p.tahun;
