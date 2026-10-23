# ARKA PWA — paket v23

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


## Perbaikan login v22 dan email dummy
- Pesan login sekarang membedakan kredensial salah, email belum terkonfirmasi, dan kegagalan koneksi/DNS.
- **Aplikasi tidak dapat mematikan konfirmasi email dari sisi browser.** Pengaturan ini harus diubah pada proyek Supabase yang benar: `Authentication → Providers → Email → Confirm email` menjadi OFF, lalu simpan. Nama menu dapat sedikit berbeda menurut versi dashboard.
- Untuk akun dummy yang sudah dibuat saat Confirm email ON, perubahan pengaturan belum tentu otomatis memverifikasi akun lama. Periksa `Authentication → Users`; konfirmasi akun yang memang Anda kendalikan atau hapus dan buat ulang akun uji setelah Confirm email OFF.
- Gunakan alamat dummy hanya untuk pengujian. Jangan menonaktifkan konfirmasi email untuk aplikasi publik/produksi tanpa menilai risikonya.
- Screenshot sebelumnya menunjukkan `ERR_NAME_NOT_RESOLVED` / `Failed to fetch`. Itu menandakan browser tidak dapat menemukan/menghubungi hostname Supabase (sering karena Project URL salah, proyek tidak aktif, atau DNS/jaringan). Menonaktifkan Confirm email **tidak memperbaiki** masalah DNS. Buka `⚙ Konfigurasi koneksi Supabase`, salin Project URL persis dari `Supabase → Project Settings → API`, dan pastikan anon/publishable key berasal dari proyek yang sama.

## Setelah mengganti versi
Unggah ulang `index.html`, `sw.js`, `manifest.webmanifest`, dan ikon dari paket ini ke hosting HTTPS. Cache PWA v23 sudah dibedakan dari v21; tutup lalu buka ulang aplikasi. Pastikan URL dan key Supabase benar sebelum mencoba login.


## Konfigurasi Supabase tertanam v23

Project URL, publishable key, dan slug Edge Function `arka-users-admin` sudah ditanamkan di `index.html`. Konfigurasi lokal lama dari proyek lain tidak akan menimpa Project URL bawaan. Publishable/anon key boleh berada di browser; jangan pernah menanamkan service_role/secret key. Keamanan data tetap bergantung pada RLS, grants, dan pemeriksaan otorisasi Edge Function.

Project URL tertanam: `https://gsmrhrgcilzuelrorarr.supabase.co`. Deploy ulang `index.html` dan `sw.js` dari paket v23 pada hosting HTTPS.
