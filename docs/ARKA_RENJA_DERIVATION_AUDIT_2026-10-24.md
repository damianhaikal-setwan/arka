# ARKA — Audit ZIP terbaru dan patch derivasi Renstra/Renja

Tanggal kerja: 24 Oktober 2026

## A. Baseline

- Snapshot yang diaudit: `arka-main (1).zip`.
- SHA-256 ZIP: `278860824d34d94e61779f0e1e4c56b1a032573ad6ac00d994e0e651402e417f`.
- Arsip berisi 38 entri dan tidak menyertakan `.git`; karena itu branch dan commit SHA GitHub **tidak dapat dibuktikan dari arsip**.
- Snapshot sebelumnya `arka-main(2).zip` berisi 29 file dibanding 30 file dalam ZIP terbaru. ZIP terbaru menambahkan migrasi guardrails dan memperbarui README, release notes, dokumen Renja, test checklist, test statis, serta query verifikasi. Namun `index.html` identik byte-for-byte pada dua ZIP (SHA-256: `ea16fa01f3f670870f4581057f2cb29c004914b3f7c3f21f615e6f14e064aa15`), sehingga fitur derivasi UI yang didokumentasikan belum ada pada entry point saat ini.
- Akses live ke repo `https://github.com/damianhaikal-setwan/arka`, GitHub API, dan raw GitHub gagal di lingkungan ini (`DisabledError`/tidak dapat diakses). Pencarian web juga tidak memberi konten yang dapat diverifikasi untuk repo yang tepat. ZIP terbaru digunakan sebagai baseline kerja, bukan klaim bahwa remote GitHub sudah cocok.

## B. Keputusan

- **[PERTAHANKAN]** Struktur single-file `index.html`, identitas terpisah per tabel, hierarki `renja → program → kegiatan → subkegiatan`, dan relasi historis yang sudah ada.
- **[PERBAIKI]** Query verifikasi guardrails yang memakai `ORDER BY table_name::text`; alias itu tidak valid pada ekspresi cast tersebut. Diganti dengan `c.conrelid::regclass::text, c.conname`.
- **[KEMBANGKAN]** Penurunan semua baris `renstra` dengan `jenis = 'Sasaran'` ke tampilan Identitas Renja; indikator diambil dari `renstra.indikator`, target diambil dari `t{tahun Renja}`. Tahun yang didukung schema sekarang 2025–2030.
- **[KEMBANGKAN]** Agregasi pagu: `Subkegiatan → Kegiatan → Program → Renja`. Parent budget tidak diinput manual pada form Workspace Renja. Baris induk T-C.33 yang mempunyai anak tetap dikosongkan di kolom pagu untuk mencegah hitung ganda.
- **[PERTAHANKAN]** Kolom Renja legacy `renstra_ref`, `indikator`, `target`, dan `pagu` tidak dihapus. Sumber otoritatif tampilan acuan Renstra kini daftar sasaran turunan, bukan satu `renstra_ref` singular.
- **[PERBAIKI]** Pagu hasil derivasi di database membutuhkan trigger server-side karena browser saja tidak menjaga konsistensi ketika ada beberapa klien. Trigger hanya mengagregasi record yang tertaut ke Renja dan mempunyai tahun/hierarki konsisten. Record legacy tanpa Renja tidak otomatis diubah.

## C. File yang berubah/ditambahkan

- `index.html`: helper sasaran tahunan, agregasi pagu, tampilan sasaran Renstra otomatis, pagu terhitung pada tabel Program/Kegiatan, validasi mismatch, dan blok cetak saat ada kesalahan kritis atau nilai pagu belum sinkron. Form Renja tidak lagi menerima `renstraRef`/indikator/target/pagu manual; pagu Program/Kegiatan Renja-linked tersembunyi dari form.
- `supabase/migrations/20261024170000_renja_renstra_and_budget_derivation.sql`: menambahkan kolom target tahunan yang telah digunakan UI tetapi belum ada di schema dasar, menyelaraskan status Draft/Revisi, dan memasang trigger derivasi pagu dengan `SECURITY DEFINER`, search path terbatas, serta hak execute entry point refresh dicabut dari `PUBLIC`, `anon`, dan `authenticated`.
- `supabase/verification/preview_renja_budget_reconciliation.sql`: pratinjau baca-saja untuk membandingkan pagu tersimpan dengan jumlah turunan dan menampilkan rantai yang tidak valid.
- `supabase/verification/backfill_renja_budget_derived.sql`: backfill terpisah yang mengubah nilai pagu induk; tidak dipanggil otomatis oleh migrasi.
- `supabase/migrations/20261024151600_renja_workspace_guardrails.sql`, `supabase/verification/verify_renja_workspace.sql`: perbaikan `ORDER BY` dan tambahan pengecekan schema.
- `tests/renja-derivation.test.mjs`: uji unit target tahun, pemilihan sasaran, agregasi pagu, cache, dan orphan.
- `tests/validate-html.mjs`, README, checklist, release notes, dan manifest checksum diperbarui.

## D. Verifikasi

- `node tests/validate-html.mjs`: lulus seluruh pemeriksaan statis, termasuk sintaks JavaScript inline, target tahun Renstra, trigger budget, keamanan fungsi derivasi, orphan, dan query `ORDER BY`.
- `node tests/renja-derivation.test.mjs`: lulus untuk fixture sintetis: Kegiatan 30+20=50; Program 50+25=75; dokumen Renja 75+40=115; target aktif 2026 mengarah ke `t2026` dan 2027 ke `t2027`; record legacy tanpa Renja tidak ikut dalam agregasi.
- Eksekusi SQL terhadap PostgreSQL/Supabase live belum dilakukan. `psql` dan parser PostgreSQL tidak tersedia di lingkungan ini; karenanya migrasi SQL perlu diuji pada staging sebelum produksi.
- Browser end-to-end, RLS di live, performa data besar, dan konflik lintas pengguna belum diuji.

## E. Risiko/penerapan

1. Pastikan migrasi awal Renja dan guardrails sudah diterapkan pada project target. Migrasi baru ini harus dijalankan setelah keduanya.
2. Backup database sebelum menerapkan migrasi derivasi pada staging.
3. Jalankan `preview_renja_budget_reconciliation.sql` dan perbaiki referensi yang tidak valid secara eksplisit.
4. Setelah persetujuan operator atas nilai hasil turunan, jalankan `backfill_renja_budget_derived.sql` untuk menyelaraskan nilai pagu lama. Backfill mengubah `pagu` pada Kegiatan, Program, dan Renja yang valid; inilah alasan preview/backup dipisahkan.
5. Jalankan `verify_renja_workspace.sql`, lalu uji insert/update/delete Subkegiatan dan konfirmasi bahwa pagu induk berubah secara atomik. Pastikan audit trigger tidak menghalangi update turunan server-side.
6. T-C.33 mempertahankan indikator/target masing-masing Program/Kegiatan/Subkegiatan. Saat ini tidak ada hubungan Program→Sasaran Renstra yang eksplisit; oleh karena itu semua sasaran ditampilkan sebagai acuan Renja, tetapi tidak disalin secara membabi-buta ke setiap Program. Jika dibutuhkan pemetaan per Program, diperlukan model relasi tersendiri (mis. tabel penghubung) dan persetujuan aturan bisnis.
7. Jika rollback diperlukan, kembalikan `index.html` sebelumnya dan hentikan trigger derivasi baru setelah evaluasi. Jangan menghapus data atau menjalankan backfill pembalik secara tebakan; gunakan backup snapshot yang tervalidasi.

Tidak ada perubahan yang dikirim ke GitHub dan tidak ada migrasi yang dijalankan pada Supabase pengguna.
