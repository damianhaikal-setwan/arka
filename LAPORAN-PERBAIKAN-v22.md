# ARKA v22 — perbaikan login

## Perubahan
- Memperjelas pesan login untuk konfigurasi Supabase belum lengkap, kredensial tidak cocok, email belum terkonfirmasi, dan kegagalan fetch/DNS.
- Mengubah cache Service Worker ke `arka-shell-v22` agar shell versi lama tidak terus dipakai.
- Tidak menambahkan bypass autentikasi atau mematikan konfirmasi email dari JavaScript. Konfirmasi email adalah pengaturan Auth di sisi Supabase.

## Langkah wajib
1. Buka Supabase project yang digunakan ARKA.
2. Salin Project URL dan anon/publishable key dari proyek yang sama ke menu konfigurasi ARKA. Jangan gunakan service_role key di browser.
3. Jika email dummy memang hanya untuk uji, ubah `Authentication → Providers → Email → Confirm email` menjadi OFF. Tangani akun uji lama dari `Authentication → Users` bila masih belum terkonfirmasi.
4. Screenshot menunjukkan `ERR_NAME_NOT_RESOLVED` dan `Failed to fetch`; verifikasi URL/DNS/status proyek lebih dahulu. Pengaturan Confirm email tidak memperbaiki DNS.
5. Deploy semua file paket v22 ke hosting HTTPS dan uji dengan akun uji yang tidak memiliki data/akses produksi.

## Batas validasi
Perubahan hanya diuji secara statis. Tidak ada akses ke dashboard atau proyek Supabase pengguna, sehingga URL, key, status proyek, dan hasil login belum dapat diverifikasi langsung.
