# Validasi wajib sebelum produksi Supabase

Status saat paket dibuat: **BELUM TERVERIFIKASI** — paket ini tidak memiliki bukti konfigurasi RLS/Storage/Edge Function produksi.

## Wajib dibuktikan di proyek Supabase yang sebenarnya
- [ ] RLS aktif pada semua tabel modul, `profiles`, `audit_log`, dan tabel metadata lampiran.
- [ ] SELECT dibatasi sesuai peran; `pimpinan` hanya baca; `pengelola` hanya tulis modul unitnya; admin sesuai kewenangan formal.
- [ ] INSERT/UPDATE/DELETE diperiksa oleh policy database, bukan hanya `canWrite`/`canDelete` di browser.
- [ ] Pengguna tidak dapat mengubah `profiles.peran` atau `profiles.unit` miliknya sendiri untuk menaikkan hak akses.
- [ ] `audit_log` tidak dapat diubah/dihapus oleh pengguna aplikasi biasa; pelaku diambil dari `auth.uid()` di server, bukan dipercaya dari browser.
- [ ] Storage upload/download/delete menggunakan policy yang sesuai, termasuk pembatasan folder/record dan MIME/ukuran.
- [ ] Edge Function memvalidasi JWT, peran, input, dan akses data; tidak mempercayai nama/peran yang dikirim klien.
- [ ] Perubahan record bisnis dan audit dilakukan atomik melalui database trigger atau RPC transaksi. Insert data lalu insert audit dari browser tidak atomik.
- [ ] Uji negatif dengan akun `pimpinan`, `pengelola` tiap unit, dan admin: baca silang unit, tulis silang unit, delete, ubah profil, akses lampiran, dan panggil REST langsung.
- [ ] Uji perubahan yang berhasil tetapi audit gagal, jaringan putus saat simpan, dan konflik dua pengguna.

Jangan aktifkan policy generik atau menebak nama kolom sebelum skema dan peran yang berlaku diverifikasi. Pengujian harus dilakukan pada staging dengan salinan aman, bukan menghapus/mengubah data produksi untuk uji coba.
