# Laporan Perbaikan ARKA v23 — Konfigurasi Supabase Tertanam

## Perubahan
- Menanamkan Project URL Supabase yang diberikan pengguna ke `index.html`.
- Menanamkan publishable key yang diberikan pengguna; tidak menggunakan legacy anon JWT sebagai default.
- Mengatur slug Edge Function menjadi `arka-users-admin`.
- Konfigurasi lama yang menunjuk ke proyek lain tidak lagi menimpa URL/key bawaan. Konfigurasi tersimpan hanya dipakai jika URL-nya cocok dengan proyek tertanam.
- Cache PWA dinaikkan ke `arka-shell-v23`; versi aplikasi menjadi `23.0.0`.

## Validasi dan batasan
- Konfigurasi URL, key, dan slug ditanamkan secara statis; JavaScript syntax perlu diverifikasi sebelum deploy.
- Tidak ada koneksi langsung ke proyek Supabase pengguna dari lingkungan ini. Login, keberadaan Edge Function, konfigurasi secrets, RLS, dan izin akun belum diuji live.
- Publishable key aman untuk dipublikasikan sebagai key client; jangan pernah memasukkan `service_role`/secret key ke HTML.
- Deploy ulang `index.html`, `sw.js`, manifest, dan ikon dari paket ini pada hosting HTTPS.
