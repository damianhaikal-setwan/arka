-- ARKA: migrasi satu kali untuk database yang sudah menjalankan skema lama.
-- Urutan wajib:
--   1. Jalankan berkas ini (sekali).
--   2. Isi unit kerja pengguna pengelola (langkah A di bawah) SEBELUM langkah 3 dijalankan.
--   3. Jalankan ulang arka_schema.sql.
-- JANGAN jalankan arka_seed.sql lagi: data contoh sudah ada, dan INSERT akan gagal karena ID sudah terpakai.

-- 1. Kolom unit kerja pada profil
alter table public.profiles add column if not exists unit text;

-- 2. Buang check peran lama (nama default Postgres)
alter table public.profiles drop constraint if exists profiles_peran_check;

-- 3. Peran lama 'operator' menjadi 'pengelola'
update public.profiles set peran = 'pengelola' where peran = 'operator';

-- A. Isi unit kerja untuk setiap pengguna pengelola (pilih salah satu: umum_keuangan, persidangan, fasilitasi)
--    select id, nama, peran, unit from public.profiles;
--    contoh (ganti UUID dengan id dari daftar di atas):
--    update public.profiles set unit = 'umum_keuangan' where id = 'UUID-PENGGUNA';

-- B. Pasang check baru (hanya berhasil jika semua pengelola sudah punya unit)
do $$ begin
  alter table public.profiles add constraint profiles_peran_check check (peran in ('admin','pengelola','pimpinan'));
exception when duplicate_object then null; end $$;
do $$ begin
  alter table public.profiles add constraint profiles_unit_check check (unit is null or unit in ('umum_keuangan','persidangan','fasilitasi'));
exception when duplicate_object then null; end $$;
do $$ begin
  alter table public.profiles add constraint profiles_unit_wajib check (peran <> 'pengelola' or unit is not null);
exception when duplicate_object then null; end $$;

-- 4. Samakan nama unit pada data yang sudah tersimpan dengan Perbup Nomor 57 Tahun 2021
update public.pegawai set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Umum';
update public.pegawai set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Keuangan';
update public.pegawai set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Persidangan';
update public.pegawai set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Legislasi';
update public.pegawai set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Humas';
update public.pegawai set unit = 'Subbagian Tata Usaha dan Kepegawaian' where unit = 'Bagian Kepegawaian';
update public.pegawai set unit = 'Sekretaris Dewan' where unit = 'Sekretaris DPRD';
update public.program set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Umum';
update public.program set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Keuangan';
update public.program set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Persidangan';
update public.program set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Legislasi';
update public.program set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Humas';
update public.program set unit = 'Subbagian Tata Usaha dan Kepegawaian' where unit = 'Bagian Kepegawaian';
update public.program set unit = 'Sekretaris Dewan' where unit = 'Sekretaris DPRD';
update public.sasaran set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Umum';
update public.sasaran set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Keuangan';
update public.sasaran set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Persidangan';
update public.sasaran set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Legislasi';
update public.sasaran set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Humas';
update public.sasaran set unit = 'Subbagian Tata Usaha dan Kepegawaian' where unit = 'Bagian Kepegawaian';
update public.sasaran set unit = 'Sekretaris Dewan' where unit = 'Sekretaris DPRD';
update public.iku set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Umum';
update public.iku set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Keuangan';
update public.iku set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Persidangan';
update public.iku set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Legislasi';
update public.iku set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Humas';
update public.iku set unit = 'Subbagian Tata Usaha dan Kepegawaian' where unit = 'Bagian Kepegawaian';
update public.iku set unit = 'Sekretaris Dewan' where unit = 'Sekretaris DPRD';
update public.perjanjian set pejabat = 'Bagian Umum dan Keuangan' where pejabat = 'Bagian Umum';
update public.perjanjian set pejabat = 'Bagian Umum dan Keuangan' where pejabat = 'Bagian Keuangan';
update public.perjanjian set pejabat = 'Bagian Persidangan dan Perundang-undangan' where pejabat = 'Bagian Persidangan';
update public.perjanjian set pejabat = 'Bagian Persidangan dan Perundang-undangan' where pejabat = 'Bagian Legislasi';
update public.perjanjian set pejabat = 'Bagian Persidangan dan Perundang-undangan' where pejabat = 'Bagian Humas';
update public.perjanjian set pejabat = 'Subbagian Tata Usaha dan Kepegawaian' where pejabat = 'Bagian Kepegawaian';
update public.perjanjian set pejabat = 'Sekretaris Dewan' where pejabat = 'Sekretaris DPRD';
update public.rencanaaksi set pj = 'Bagian Umum dan Keuangan' where pj = 'Bagian Umum';
update public.rencanaaksi set pj = 'Bagian Umum dan Keuangan' where pj = 'Bagian Keuangan';
update public.rencanaaksi set pj = 'Bagian Persidangan dan Perundang-undangan' where pj = 'Bagian Persidangan';
update public.rencanaaksi set pj = 'Bagian Persidangan dan Perundang-undangan' where pj = 'Bagian Legislasi';
update public.rencanaaksi set pj = 'Bagian Persidangan dan Perundang-undangan' where pj = 'Bagian Humas';
update public.rencanaaksi set pj = 'Subbagian Tata Usaha dan Kepegawaian' where pj = 'Bagian Kepegawaian';
update public.rencanaaksi set pj = 'Sekretaris Dewan' where pj = 'Sekretaris DPRD';
update public.arsip set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Umum';
update public.arsip set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Keuangan';
update public.arsip set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Persidangan';
update public.arsip set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Legislasi';
update public.arsip set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Humas';
update public.arsip set unit = 'Subbagian Tata Usaha dan Kepegawaian' where unit = 'Bagian Kepegawaian';
update public.arsip set unit = 'Sekretaris Dewan' where unit = 'Sekretaris DPRD';
update public.rumahtangga set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Umum';
update public.rumahtangga set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Keuangan';
update public.rumahtangga set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Persidangan';
update public.rumahtangga set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Legislasi';
update public.rumahtangga set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Humas';
update public.rumahtangga set unit = 'Subbagian Tata Usaha dan Kepegawaian' where unit = 'Bagian Kepegawaian';
update public.rumahtangga set unit = 'Sekretaris Dewan' where unit = 'Sekretaris DPRD';
update public.kendaraan set pengguna = 'Bagian Umum dan Keuangan' where pengguna = 'Bagian Umum';
update public.kendaraan set pengguna = 'Bagian Umum dan Keuangan' where pengguna = 'Bagian Keuangan';
update public.kendaraan set pengguna = 'Bagian Persidangan dan Perundang-undangan' where pengguna = 'Bagian Persidangan';
update public.kendaraan set pengguna = 'Bagian Persidangan dan Perundang-undangan' where pengguna = 'Bagian Legislasi';
update public.kendaraan set pengguna = 'Bagian Persidangan dan Perundang-undangan' where pengguna = 'Bagian Humas';
update public.kendaraan set pengguna = 'Subbagian Tata Usaha dan Kepegawaian' where pengguna = 'Bagian Kepegawaian';
update public.kendaraan set pengguna = 'Sekretaris Dewan' where pengguna = 'Sekretaris DPRD';
update public.inventaris set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Umum';
update public.inventaris set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Keuangan';
update public.inventaris set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Persidangan';
update public.inventaris set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Legislasi';
update public.inventaris set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Humas';
update public.inventaris set unit = 'Subbagian Tata Usaha dan Kepegawaian' where unit = 'Bagian Kepegawaian';
update public.inventaris set unit = 'Sekretaris Dewan' where unit = 'Sekretaris DPRD';
update public.mutasi set unit_asal = 'Bagian Umum dan Keuangan' where unit_asal = 'Bagian Umum';
update public.mutasi set unit_asal = 'Bagian Umum dan Keuangan' where unit_asal = 'Bagian Keuangan';
update public.mutasi set unit_asal = 'Bagian Persidangan dan Perundang-undangan' where unit_asal = 'Bagian Persidangan';
update public.mutasi set unit_asal = 'Bagian Persidangan dan Perundang-undangan' where unit_asal = 'Bagian Legislasi';
update public.mutasi set unit_asal = 'Bagian Persidangan dan Perundang-undangan' where unit_asal = 'Bagian Humas';
update public.mutasi set unit_asal = 'Subbagian Tata Usaha dan Kepegawaian' where unit_asal = 'Bagian Kepegawaian';
update public.mutasi set unit_asal = 'Sekretaris Dewan' where unit_asal = 'Sekretaris DPRD';
update public.mutasi set unit_tujuan = 'Bagian Umum dan Keuangan' where unit_tujuan = 'Bagian Umum';
update public.mutasi set unit_tujuan = 'Bagian Umum dan Keuangan' where unit_tujuan = 'Bagian Keuangan';
update public.mutasi set unit_tujuan = 'Bagian Persidangan dan Perundang-undangan' where unit_tujuan = 'Bagian Persidangan';
update public.mutasi set unit_tujuan = 'Bagian Persidangan dan Perundang-undangan' where unit_tujuan = 'Bagian Legislasi';
update public.mutasi set unit_tujuan = 'Bagian Persidangan dan Perundang-undangan' where unit_tujuan = 'Bagian Humas';
update public.mutasi set unit_tujuan = 'Subbagian Tata Usaha dan Kepegawaian' where unit_tujuan = 'Bagian Kepegawaian';
update public.mutasi set unit_tujuan = 'Sekretaris Dewan' where unit_tujuan = 'Sekretaris DPRD';
update public.pengaduan set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Umum';
update public.pengaduan set unit = 'Bagian Umum dan Keuangan' where unit = 'Bagian Keuangan';
update public.pengaduan set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Persidangan';
update public.pengaduan set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Legislasi';
update public.pengaduan set unit = 'Bagian Persidangan dan Perundang-undangan' where unit = 'Bagian Humas';
update public.pengaduan set unit = 'Subbagian Tata Usaha dan Kepegawaian' where unit = 'Bagian Kepegawaian';
update public.pengaduan set unit = 'Sekretaris Dewan' where unit = 'Sekretaris DPRD';

-- Pengguna yang sudah ada: pastikan peran dan unit sesuai (lihat KAMUS_DATA.md)
