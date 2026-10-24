-- READ-ONLY preview. No data is modified.
-- Shows stored vs derived budget for the valid Renja hierarchy only.
WITH activity_calc AS (
  SELECT k.id, k.kode, k.nama, k.renja_ref, k.tahun, k.program,
         k.pagu AS stored_pagu,
         COALESCE(SUM(s.pagu) FILTER (
           WHERE s.renja_ref::text = k.renja_ref::text AND s.tahun = k.tahun
         ), 0) AS derived_pagu
  FROM public.kegiatan k
  JOIN public.renja r ON r.id::text = k.renja_ref::text AND r.tahun = k.tahun
  JOIN public.program p ON p.id::text = k.program::text
    AND p.renja_ref::text = k.renja_ref::text AND p.tahun = k.tahun
  LEFT JOIN public.subkegiatan s ON s.kegiatan::text = k.id::text
  GROUP BY k.id, k.kode, k.nama, k.renja_ref, k.tahun, k.program, k.pagu
), program_calc AS (
  SELECT p.id, p.kode, p.nama, p.renja_ref, p.tahun, p.pagu AS stored_pagu,
         COALESCE(SUM(a.derived_pagu), 0) AS derived_pagu
  FROM public.program p
  JOIN public.renja r ON r.id::text = p.renja_ref::text AND r.tahun = p.tahun
  LEFT JOIN activity_calc a ON a.program::text = p.id::text
    AND a.renja_ref::text = p.renja_ref::text AND a.tahun = p.tahun
  GROUP BY p.id, p.kode, p.nama, p.renja_ref, p.tahun, p.pagu
), renja_calc AS (
  SELECT r.id, r.kode, r.nama, r.tahun, r.pagu AS stored_pagu,
         COALESCE(SUM(p.derived_pagu), 0) AS derived_pagu
  FROM public.renja r
  LEFT JOIN program_calc p ON p.renja_ref::text = r.id::text AND p.tahun = r.tahun
  GROUP BY r.id, r.kode, r.nama, r.tahun, r.pagu
)
SELECT 'KEGIATAN' AS level, id, kode, nama, tahun, stored_pagu, derived_pagu,
       (stored_pagu IS DISTINCT FROM derived_pagu) AS would_change
FROM activity_calc
UNION ALL
SELECT 'PROGRAM', id, kode, nama, tahun, stored_pagu, derived_pagu,
       (stored_pagu IS DISTINCT FROM derived_pagu)
FROM program_calc
UNION ALL
SELECT 'RENJA', id, kode, nama, tahun, stored_pagu, derived_pagu,
       (stored_pagu IS DISTINCT FROM derived_pagu)
FROM renja_calc
ORDER BY level, tahun, kode;

-- Rows excluded from rollups because they are not valid in this hierarchy.
SELECT 'PROGRAM_INVALID' AS finding, p.id, p.kode, p.nama, p.tahun, p.renja_ref
FROM public.program p
LEFT JOIN public.renja r ON r.id::text = p.renja_ref::text AND r.tahun = p.tahun
WHERE NULLIF(BTRIM(COALESCE(p.renja_ref::text,'')), '') IS NOT NULL AND r.id IS NULL
UNION ALL
SELECT 'KEGIATAN_INVALID', k.id, k.kode, k.nama, k.tahun, k.renja_ref
FROM public.kegiatan k
LEFT JOIN public.renja r ON r.id::text = k.renja_ref::text AND r.tahun = k.tahun
LEFT JOIN public.program p ON p.id::text = k.program::text
  AND p.renja_ref::text = k.renja_ref::text AND p.tahun = k.tahun
WHERE NULLIF(BTRIM(COALESCE(k.renja_ref::text,'')), '') IS NOT NULL AND (r.id IS NULL OR p.id IS NULL)
UNION ALL
SELECT 'SUBKEGIATAN_INVALID', s.id, s.kode, s.nama, s.tahun, s.renja_ref
FROM public.subkegiatan s
LEFT JOIN public.renja r ON r.id::text = s.renja_ref::text AND r.tahun = s.tahun
LEFT JOIN public.kegiatan k ON k.id::text = s.kegiatan::text
  AND k.renja_ref::text = s.renja_ref::text AND k.tahun = s.tahun
WHERE NULLIF(BTRIM(COALESCE(s.renja_ref::text,'')), '') IS NOT NULL AND (r.id IS NULL OR k.id IS NULL)
ORDER BY finding, tahun, kode;
