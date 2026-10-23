# ARKA PWA — paket v20

## Isi paket
- `index.html`: aplikasi ARKA yang diperbaiki.
- `manifest.webmanifest`: metadata instalasi PWA.
- `sw.js`: cache shell aplikasi; trafik Supabase tidak pernah di-cache.
- `arka-icon.svg`: ikon aplikasi.

## Deploy
1. Unggah ke satu direktori pada hosting HTTPS yang sama: keempat berkas di atas.
2. Pastikan server menyajikan `manifest.webmanifest` dengan MIME type `application/manifest+json` atau `application/manifest+json; charset=utf-8` (browser modern juga menerima `application/manifest+json`).
3. Buka `https://.../` atau URL direktori, kemudian gunakan menu browser “Install app” / “Add to Home Screen”.
4. Uji autentikasi, pembacaan tabel, tambah, ubah, hapus, dan audit log di lingkungan staging terlebih dahulu.

## Batasan yang disengaja
- PWA ini **belum mendukung antrean tulis offline atau sinkronisasi otomatis**. Saat offline, penulisan cloud ditolak di UI. Jangan input data bisnis penting dalam mode lokal dan menganggapnya sudah tersimpan di Supabase.
- Cache hanya untuk shell/skrip statis; respons Supabase REST, Auth, Storage, dan Edge Function tidak di-cache.
- PWA memerlukan HTTPS (kecuali localhost). Membuka berkas HTML langsung (`file://`) tidak mengaktifkan Service Worker.
- Ikon PNG 192×192 dan 512×512 disediakan bersama ikon SVG.

## Status keamanan backend
Perbaikan frontend bukan pengganti Supabase RLS. RLS, Storage policies, Edge Function authorization, dan transaksi audit atomik harus diverifikasi pada proyek backend sebenarnya. Tidak ada kebijakan produksi yang diubah oleh paket ini.


## Audit backend v21 — urutan wajib
1. Backup database dan deploy ke staging.
2. Pastikan `arka_schema.sql` dan (jika digunakan) migrasi `keanggotaan_akd` telah diterapkan.
3. Jalankan `arka_audit_security_migration_v21.sql` di staging.
4. Uji tambah/ubah/hapus dengan akun authenticated; pastikan tiap operasi menghasilkan tepat satu catatan trigger dalam `audit_log`.
5. Uji bahwa non-admin tidak bisa membaca/menulis `audit_log`, tidak bisa mengubah `profiles`, dan admin tetap dapat mengelola pengguna melalui Edge Function.
6. Baru deploy `index.html` dari paket ini. Jangan deploy aplikasi tanpa migrasi audit v21, karena CRUD bisnis tidak lagi membuat audit manual.
7. Setelah seluruh uji lulus, jadwalkan jendela perubahan dan terapkan di produksi.
