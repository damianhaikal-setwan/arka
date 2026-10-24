# ARKA — Renja Workspace release candidate

Paket ini berisi kandidat HTML workspace Renja, migrasi Supabase aditif, query verifikasi baca-saja, dokumentasi, dan pemeriksaan sintaks lokal.

## Isi paket

- `app/ARKA-v28b-renja-workspace-implementation.html` — kandidat aplikasi yang diuji lokal.
- `supabase/migrations/20261024_renja_workspace_implementation.sql` — migrasi aditif untuk kolom integrasi dan validasi rantai Renja.
- `supabase/verification/verify_renja_workspace.sql` — pemeriksaan skema dan integritas yang hanya membaca data.
- `docs/RENJA_WORKSPACE.md` — arsitektur dan cakupan.
- `docs/TEST_CHECKLIST.md` — daftar pengujian pra-rilis.
- `docs/RELEASE_NOTES.md` — ringkasan perubahan dan batasan.
- `tests/validate-html.mjs` — pemeriksaan statis tanpa dependensi npm.

## Penting sebelum menggabungkan ke repo

1. Tinjau branch dan entrypoint aplikasi yang ada. File kandidat ini **tidak otomatis menggantikan** file entrypoint repo karena struktur repo belum dapat diverifikasi pada proses penyusunan paket.
2. Cadangkan database Supabase dan uji migrasi pada lingkungan nonproduksi terlebih dahulu.
3. Pastikan nama tabel dan kolom di migrasi cocok dengan skema aktual. Migrasi mengasumsikan `public.renja`, `public.program`, `public.kegiatan`, `public.subkegiatan` serta kolom `id`, `tahun`, `program`, dan `kegiatan` telah ada.
4. Jangan otomatis mengaitkan record lama yang belum mempunyai `renja_ref`; lakukan pemetaan setelah diverifikasi oleh operator.
5. Pertahankan kebijakan RLS yang sudah ada dan uji dengan peran pengguna aktual. Paket ini tidak mengubah RLS.

## Uji statis lokal

```sh
node tests/validate-html.mjs app/ARKA-v28b-renja-workspace-implementation.html
```

Ini memeriksa sintaks JavaScript inline, metadata workspace, dan favicon inline. Ini bukan pengganti pengujian integrasi Supabase.
