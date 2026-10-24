# ARKA — Repository Entry Point dan Renja Workspace

Repository ini menggunakan **`index.html` sebagai entry point aplikasi single-file**. Workspace Renja berada di dalam entry point tersebut; tidak ada file aplikasi terpisah di folder `app/` pada snapshot ini.

## Berkas utama

- `index.html` — aplikasi ARKA, termasuk Workspace Renja, mapping Supabase, validasi, dan keluaran draf T-C.33.
- `supabase/arka_schema.sql` — schema dasar dan policy RLS; cocokkan dengan riwayat migrasi project sebelum digunakan kembali.
- `supabase/arka_audit_security_migration_v21.sql` — migrasi audit server-side dan penguncian DML `audit_log`/`profiles`; pastikan sudah diterapkan pada project cloud sebelum mengandalkan audit atomik dari aplikasi.
- `supabase/migrations/20261024_renja_workspace_implementation.sql` — migrasi awal workspace Renja.
- `supabase/migrations/20261024151600_renja_workspace_guardrails.sql` — perbaikan kontrak status dan referensi Renja untuk penerapan lanjutan.
- `supabase/verification/verify_renja_workspace.sql` — query verifikasi baca-saja.
- `docs/RENJA_WORKSPACE.md` — kontrak data dan batasan workspace.
- `docs/TEST_CHECKLIST.md` — checklist uji penerimaan.
- `tests/validate-html.mjs` — pemeriksaan statis tanpa dependensi npm.

## Uji statis lokal

Dari root repository, jalankan:

```sh
node tests/validate-html.mjs
```

Atau berikan path HTML secara eksplisit:

```sh
node tests/validate-html.mjs index.html
```

Pemeriksaan ini memverifikasi sintaks JavaScript inline dan beberapa kontrak statis workspace/migrasi. Tes ini **bukan** pengganti uji browser end-to-end, Supabase, RLS, audit trigger, atau persistensi lintas pengguna.

## Urutan penerapan yang aman

1. Backup database dan uji pada project/staging nonproduksi terlebih dahulu.
2. Verifikasi schema, policy RLS, serta apakah migrasi audit v21 telah diterapkan. Jangan menjalankan ulang seluruh schema dasar pada project yang sudah bermigrasi tanpa meninjau efeknya.
3. Jika migrasi Renja awal sudah diterapkan, jalankan hanya migrasi guardrails yang baru; jika belum, terapkan migrasi sesuai urutan.
4. Jalankan `supabase/verification/verify_renja_workspace.sql`, periksa orphan/referensi yang tidak valid, dan uji akun peran aktual sebelum deployment.
5. Jangan menganggap audit trail, Realtime lintas pengguna, optimistic locking/version conflict, snapshot publikasi, atau kesiapan produksi telah lulus hanya dari tes statis.

Migrasi guardrails tidak menghapus atau otomatis mengaitkan data historis. Foreign key `NOT VALID` menghindari validasi massal awal, tetapi tetap harus disertai peninjauan data lama dan validasi terencana sebelum menyatakan integritas penuh.
