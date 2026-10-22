-- ARKA: skema Supabase (PostgreSQL)
-- Dibuat otomatis dari ARKA.html (konfigurasi modul, unit, dan hak akses).
-- Dijalankan di SQL Editor. Aman dijalankan ulang untuk tabel dan kebijakan.

create extension if not exists pgcrypto;

create table if not exists public.audit_log (
  id bigint generated always as identity primary key,
  waktu timestamptz not null default now(),
  aksi text not null,
  modul text not null,
  ref text,
  user_name text
);

-- ===== PENGGUNA: peran dan unit kerja =====
-- Peran: admin (semua), pengelola (menulis modul unit kerjanya), pimpinan (Sekretaris Dewan, hanya baca).
-- Unit: umum_keuangan, persidangan, fasilitasi. Wajib diisi untuk peran pengelola.
-- Cara menambahkan pengguna (admin, di SQL Editor, setelah akun dibuat di Authentication):
--   insert into public.profiles (id, nama, peran, unit)
--   select id, 'Nama Lengkap', 'pengelola', 'umum_keuangan' from auth.users where email = 'nama@dprd.go.id';
-- Pimpinan tidak memerlukan unit:
--   insert into public.profiles (id, nama, peran)
--   select id, 'Sekretaris Dewan', 'pimpinan' from auth.users where email = 'sekwan@dprd.go.id';

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nama text,
  peran text not null check (peran in ('admin','pengelola','pimpinan')),
  unit text check (unit is null or unit in ('umum_keuangan','persidangan','fasilitasi')),
  constraint profiles_unit_wajib check (peran <> 'pengelola' or unit is not null)
);
alter table public.profiles enable row level security;
drop policy if exists "profiles_baca_sendiri" on public.profiles;
create policy "profiles_baca_sendiri" on public.profiles for select to authenticated using (id = auth.uid());

create or replace function public.arka_peran() returns text
language sql stable security definer set search_path = public
as $$ select peran from public.profiles where id = auth.uid() $$;

create or replace function public.arka_unit() returns text
language sql stable security definer set search_path = public
as $$ select unit from public.profiles where id = auth.uid() $$;

-- ===== PEMETAAN MODUL KE UNIT (Perbup Kapuas Hulu Nomor 57 Tahun 2021) =====
-- unit_pengelola: unit yang boleh menambah dan mengubah modul.
-- baca_unit: jika null, semua pengelola boleh membaca; jika diisi, hanya unit tersebut (dan admin, pimpinan).
create table if not exists public.modul_akses (
  tabel text primary key,
  unit_pengelola text not null check (unit_pengelola in ('umum_keuangan','persidangan','fasilitasi')),
  baca_unit text[]
);
alter table public.modul_akses enable row level security;
drop policy if exists "modul_akses_baca" on public.modul_akses;
create policy "modul_akses_baca" on public.modul_akses for select to authenticated using (true);

insert into public.modul_akses (tabel, unit_pengelola, baca_unit) values
  ('pegawai', 'umum_keuangan', null),
  ('anggota', 'umum_keuangan', null),
  ('komisi', 'persidangan', null),
  ('fraksi', 'umum_keuangan', null),
  ('alat', 'persidangan', null),
  ('tenaga', 'umum_keuangan', null),
  ('mitra', 'fasilitasi', null),
  ('program', 'umum_keuangan', null),
  ('kegiatan', 'umum_keuangan', null),
  ('subkegiatan', 'umum_keuangan', null),
  ('sasaran', 'umum_keuangan', null),
  ('iku', 'umum_keuangan', null),
  ('iki', 'umum_keuangan', null),
  ('regulasi', 'persidangan', null),
  ('rpjmd', 'umum_keuangan', null),
  ('renstra', 'umum_keuangan', null),
  ('renja', 'umum_keuangan', null),
  ('cascading', 'umum_keuangan', null),
  ('pohon', 'umum_keuangan', null),
  ('perjanjian', 'umum_keuangan', null),
  ('rencanaaksi', 'umum_keuangan', null),
  ('ikuk', 'umum_keuangan', null),
  ('ikik', 'umum_keuangan', null),
  ('monitoring', 'umum_keuangan', null),
  ('evaluasi', 'umum_keuangan', null),
  ('persuratan', 'umum_keuangan', null),
  ('arsip', 'umum_keuangan', null),
  ('perjalanan', 'umum_keuangan', null),
  ('kepegawaian', 'umum_keuangan', null),
  ('rumahtangga', 'umum_keuangan', null),
  ('kendaraan', 'umum_keuangan', null),
  ('anggaran', 'umum_keuangan', null),
  ('spj', 'umum_keuangan', null),
  ('aset_rencana', 'umum_keuangan', null),
  ('inventaris', 'umum_keuangan', null),
  ('pemeliharaan', 'umum_keuangan', null),
  ('mutasi', 'umum_keuangan', null),
  ('penghapusan', 'umum_keuangan', null),
  ('rekonsiliasi', 'umum_keuangan', null),
  ('agenda', 'persidangan', null),
  ('jadwal', 'persidangan', null),
  ('rapat', 'persidangan', null),
  ('rapat_komisi', 'persidangan', null),
  ('banggar', 'fasilitasi', null),
  ('bapemperda', 'persidangan', null),
  ('bk', 'fasilitasi', array['fasilitasi']::text[]),
  ('paripurna', 'persidangan', null),
  ('risalah', 'persidangan', null),
  ('notulen', 'persidangan', null),
  ('keputusan', 'persidangan', null),
  ('propemperda', 'persidangan', null),
  ('ranperda', 'persidangan', null),
  ('naskahakademik', 'persidangan', null),
  ('dim', 'persidangan', null),
  ('harmonisasi', 'persidangan', null),
  ('jdih', 'persidangan', null),
  ('kua', 'fasilitasi', null),
  ('ppas', 'fasilitasi', null),
  ('apbd', 'fasilitasi', null),
  ('apbdp', 'fasilitasi', null),
  ('lapsemester', 'fasilitasi', null),
  ('pertanggungjawaban', 'fasilitasi', null),
  ('monopd', 'fasilitasi', null),
  ('monprogram', 'fasilitasi', null),
  ('monproyek', 'fasilitasi', null),
  ('lkpj', 'fasilitasi', null),
  ('temuan', 'fasilitasi', null),
  ('rekomendasi', 'fasilitasi', null),
  ('tindaklanjut', 'fasilitasi', null),
  ('reses', 'fasilitasi', null),
  ('pokir', 'fasilitasi', null),
  ('hearing', 'persidangan', null),
  ('audiensi', 'persidangan', null),
  ('aspirasidigital', 'fasilitasi', null),
  ('pengaduan', 'umum_keuangan', array['umum_keuangan']::text[]),
  ('berita', 'persidangan', null),
  ('publikasi', 'persidangan', null),
  ('dokumentasi', 'persidangan', null),
  ('mediamon', 'persidangan', null),
  ('protokoler', 'persidangan', null)
on conflict (tabel) do update set unit_pengelola = excluded.unit_pengelola, baca_unit = excluded.baca_unit;

create or replace function public.arka_baca(t text) returns boolean
language sql stable security definer set search_path = public
as $$
  select case
    when arka_peran() in ('admin','pimpinan') then true
    when arka_peran() = 'pengelola' then exists (
      select 1 from public.modul_akses m
      where m.tabel = t and (m.baca_unit is null or arka_unit() = any(m.baca_unit)))
    else false end
$$;

create or replace function public.arka_tulis(t text) returns boolean
language sql stable security definer set search_path = public
as $$
  select case
    when arka_peran() = 'admin' then true
    when arka_peran() = 'pengelola' then exists (
      select 1 from public.modul_akses m
      where m.tabel = t and m.unit_pengelola = arka_unit())
    else false end
$$;

create table if not exists public.pegawai (
  id text primary key,
  dibuat date,
  diubah date,
  nip text,
  nama text,
  jabatan text,
  unit text,
  golongan text,
  status text,
  constraint pegawai_status_chk check (status is null or status in ('Aktif', 'Cuti', 'Pensiun'))
);

create table if not exists public.anggota (
  id text primary key,
  dibuat date,
  diubah date,
  nama text,
  fraksi text,
  komisi text,
  dapil text,
  jabatan text,
  status text,
  constraint anggota_status_chk check (status is null or status in ('Aktif', 'Antar Waktu', 'Nonaktif'))
);

create table if not exists public.komisi (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  ketua text,
  mitra text,
  jumlah numeric,
  status text,
  constraint komisi_status_chk check (status is null or status in ('Aktif', 'Nonaktif'))
);

create table if not exists public.fraksi (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  ketua text,
  jumlah numeric,
  status text,
  constraint fraksi_status_chk check (status is null or status in ('Aktif', 'Nonaktif'))
);

create table if not exists public.alat (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  jenis text,
  ketua text,
  jumlah numeric,
  status text,
  constraint alat_jenis_chk check (jenis is null or jenis in ('Badan', 'Panitia', 'Kelompok Kerja')),
  constraint alat_status_chk check (status is null or status in ('Aktif', 'Nonaktif'))
);

create table if not exists public.tenaga (
  id text primary key,
  dibuat date,
  diubah date,
  nama text,
  keahlian text,
  komisi text references public.komisi(id) on delete set null,
  kontrak text,
  status text,
  constraint tenaga_status_chk check (status is null or status in ('Aktif', 'Berakhir'))
);

create table if not exists public.mitra (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  jenis text,
  komisi text references public.komisi(id) on delete set null,
  kontak text,
  status text,
  constraint mitra_jenis_chk check (jenis is null or jenis in ('OPD', 'BUMD', 'Vertikal', 'Lainnya')),
  constraint mitra_status_chk check (status is null or status in ('Aktif', 'Nonaktif'))
);

create table if not exists public.program (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  unit text,
  pagu numeric,
  realisasi numeric,
  status text,
  constraint program_status_chk check (status is null or status in ('Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.kegiatan (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  program text references public.program(id) on delete set null,
  pagu numeric,
  realisasi numeric,
  status text,
  constraint kegiatan_status_chk check (status is null or status in ('Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.subkegiatan (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  kegiatan text references public.kegiatan(id) on delete set null,
  pagu numeric,
  status text,
  constraint subkegiatan_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai'))
);

create table if not exists public.iku (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  unit text,
  target numeric,
  capaian numeric,
  satuan text,
  status text,
  constraint iku_status_chk check (status is null or status in ('Tercapai', 'Proses', 'Tertunda'))
);

create table if not exists public.sasaran (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  unit text,
  iku text references public.iku(id) on delete set null,
  status text,
  constraint sasaran_status_chk check (status is null or status in ('Berjalan', 'Tercapai', 'Tertunda'))
);

create table if not exists public.iki (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  pegawai text references public.pegawai(id) on delete set null,
  target numeric,
  capaian numeric,
  status text,
  constraint iki_status_chk check (status is null or status in ('Tercapai', 'Proses', 'Tertunda'))
);

create table if not exists public.regulasi (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  jenis text,
  status text,
  constraint regulasi_jenis_chk check (jenis is null or jenis in ('Perda', 'Perbup', 'PP', 'Perpres', 'Permen', 'Tatib')),
  constraint regulasi_status_chk check (status is null or status in ('Berlaku', 'Revisi', 'Dicabut'))
);

create table if not exists public.rpjmd (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  periode text,
  status text,
  constraint rpjmd_status_chk check (status is null or status in ('Berjalan', 'Selesai', 'Revisi'))
);

create table if not exists public.renstra (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  unit text,
  periode text,
  status text,
  constraint renstra_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai'))
);

create table if not exists public.renja (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  tahun numeric,
  pagu numeric,
  status text,
  constraint renja_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai'))
);

create table if not exists public.cascading (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  level text,
  sumber text references public.sasaran(id) on delete set null,
  tujuan text references public.sasaran(id) on delete set null,
  status text,
  constraint cascading_level_chk check (level is null or level in ('Bupati / RPJMD', 'Sekda', 'Sekretariat', 'Bagian', 'Sub Bagian')),
  constraint cascading_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai'))
);

create table if not exists public.pohon (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  level text,
  induk text references public.pohon(id) on delete set null,
  status text,
  constraint pohon_level_chk check (level is null or level in ('Sasaran Strategis', 'Sasaran Kegiatan', 'Sasaran Program', 'Indikator')),
  constraint pohon_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai'))
);

create table if not exists public.perjanjian (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  pejabat text,
  tahun numeric,
  status text,
  constraint perjanjian_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai'))
);

create table if not exists public.rencanaaksi (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  sasaran text references public.sasaran(id) on delete set null,
  pj text,
  tanggal date,
  status text,
  constraint rencanaaksi_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.ikuk (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  iku text references public.iku(id) on delete set null,
  target numeric,
  capaian numeric,
  status text,
  constraint ikuk_status_chk check (status is null or status in ('Tercapai', 'Proses', 'Tertunda'))
);

create table if not exists public.ikik (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  iki text references public.iki(id) on delete set null,
  target numeric,
  capaian numeric,
  status text,
  constraint ikik_status_chk check (status is null or status in ('Tercapai', 'Proses', 'Tertunda'))
);

create table if not exists public.monitoring (
  id text primary key,
  dibuat date,
  diubah date,
  tanggal date,
  nama text,
  sasaran text references public.sasaran(id) on delete set null,
  temuan text,
  status text,
  constraint monitoring_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.evaluasi (
  id text primary key,
  dibuat date,
  diubah date,
  tanggal date,
  nama text,
  nilai numeric,
  rekomendasi text,
  status text,
  constraint evaluasi_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai'))
);

create table if not exists public.persuratan (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  jenis text,
  pengirim text,
  tanggal date,
  status text,
  constraint persuratan_jenis_chk check (jenis is null or jenis in ('Masuk', 'Keluar')),
  constraint persuratan_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.arsip (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  surat text references public.persuratan(id) on delete set null,
  unit text,
  retensi numeric,
  status text,
  constraint arsip_status_chk check (status is null or status in ('Aktif', 'Inaktif', 'Musnah'))
);

create table if not exists public.perjalanan (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  pegawai text references public.pegawai(id) on delete set null,
  tanggal date,
  nilai numeric,
  status text,
  constraint perjalanan_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.kepegawaian (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  pegawai text references public.pegawai(id) on delete set null,
  jenis text,
  tanggal date,
  status text,
  constraint kepegawaian_jenis_chk check (jenis is null or jenis in ('Kenaikan Pangkat', 'Cuti', 'KGB', 'Mutasi', 'Diklat')),
  constraint kepegawaian_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.rumahtangga (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  jenis text,
  unit text,
  nilai numeric,
  tanggal date,
  status text,
  constraint rumahtangga_jenis_chk check (jenis is null or jenis in ('ATK', 'Kebersihan', 'Listrik & Air', 'Konsumsi', 'Pemeliharaan Gedung')),
  constraint rumahtangga_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.kendaraan (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  pengguna text,
  tanggal date,
  status text,
  constraint kendaraan_status_chk check (status is null or status in ('Aktif', 'Servis', 'Tidak Layak'))
);

create table if not exists public.anggaran (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  subkegiatan text references public.subkegiatan(id) on delete set null,
  pagu numeric,
  realisasi numeric,
  status text,
  constraint anggaran_status_chk check (status is null or status in ('Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.spj (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  anggaran text references public.anggaran(id) on delete set null,
  tanggal date,
  nilai numeric,
  status text,
  constraint spj_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.aset_rencana (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  anggaran text references public.anggaran(id) on delete set null,
  jenis text,
  nilai numeric,
  tanggal date,
  status text,
  constraint aset_rencana_jenis_chk check (jenis is null or jenis in ('Kendaraan', 'Peralatan Kantor', 'Elektronik', 'Tanah & Bangunan', 'Lainnya')),
  constraint aset_rencana_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.inventaris (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  jenis text,
  unit text,
  tahun numeric,
  nilai numeric,
  status text,
  constraint inventaris_jenis_chk check (jenis is null or jenis in ('Kendaraan', 'Peralatan Kantor', 'Elektronik', 'Tanah & Bangunan', 'Lainnya')),
  constraint inventaris_status_chk check (status is null or status in ('Baik', 'Rusak Ringan', 'Rusak Berat'))
);

create table if not exists public.pemeliharaan (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  barang text references public.inventaris(id) on delete set null,
  tanggal date,
  nilai numeric,
  status text,
  constraint pemeliharaan_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.mutasi (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  barang text references public.inventaris(id) on delete set null,
  unit_asal text,
  unit_tujuan text,
  jenis text,
  tanggal date,
  status text,
  constraint mutasi_jenis_chk check (jenis is null or jenis in ('Pindah Tugas', 'Pindah Pengguna', 'Hibah', 'Lainnya')),
  constraint mutasi_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai'))
);

create table if not exists public.penghapusan (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  barang text references public.inventaris(id) on delete set null,
  alasan text,
  tanggal date,
  status text,
  constraint penghapusan_alasan_chk check (alasan is null or alasan in ('Rusak Berat', 'Hilang', 'Dijual', 'Hibah', 'Musnah')),
  constraint penghapusan_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai'))
);

create table if not exists public.rekonsiliasi (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  unit text,
  tanggal date,
  jumlah_sim numeric,
  jumlah_fisik numeric,
  status text,
  constraint rekonsiliasi_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.agenda (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  jenis text,
  tanggal date,
  status text,
  constraint agenda_jenis_chk check (jenis is null or jenis in ('Paripurna', 'Komisi', 'Badan Anggaran', 'Bapemperda', 'Badan Kehormatan', 'Lainnya')),
  constraint agenda_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.jadwal (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  agenda text references public.agenda(id) on delete set null,
  tanggal date,
  tempat text,
  status text,
  constraint jadwal_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.rapat (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  jenis text,
  komisi text references public.komisi(id) on delete set null,
  pimpinan text,
  tanggal date,
  status text,
  constraint rapat_jenis_chk check (jenis is null or jenis in ('Rapat Komisi', 'Rapat Badan', 'Rapat Internal', 'Rapat Konsultasi')),
  constraint rapat_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.rapat_komisi (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  komisi text references public.komisi(id) on delete set null,
  pimpinan text,
  tanggal date,
  status text,
  constraint rapat_komisi_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.banggar (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  pimpinan text,
  tanggal date,
  status text,
  constraint banggar_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.bapemperda (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  pimpinan text,
  tanggal date,
  status text,
  constraint bapemperda_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.bk (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  anggota text references public.anggota(id) on delete set null,
  tanggal date,
  status text,
  constraint bk_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.paripurna (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  agenda text references public.agenda(id) on delete set null,
  jenis text,
  tanggal date,
  status text,
  constraint paripurna_jenis_chk check (jenis is null or jenis in ('Pembukaan Masa Sidang', 'Penutupan Masa Sidang', 'Pengambilan Keputusan', 'Pidato Kepala Daerah')),
  constraint paripurna_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.risalah (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  rapat text references public.rapat(id) on delete set null,
  halaman numeric,
  tanggal date,
  status text,
  constraint risalah_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.notulen (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  rapat text references public.rapat(id) on delete set null,
  peserta numeric,
  tanggal date,
  status text,
  constraint notulen_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.keputusan (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  jenis text,
  paripurna text references public.paripurna(id) on delete set null,
  tanggal date,
  status text,
  constraint keputusan_jenis_chk check (jenis is null or jenis in ('Keputusan DPRD', 'Keputusan Pimpinan', 'Keputusan Badan Kehormatan')),
  constraint keputusan_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.propemperda (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  pengusul text,
  tahun numeric,
  tanggal date,
  status text,
  constraint propemperda_pengusul_chk check (pengusul is null or pengusul in ('DPRD', 'Pemerintah Daerah', 'Usulan Masyarakat')),
  constraint propemperda_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.ranperda (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  propemperda text references public.propemperda(id) on delete set null,
  pengusul text,
  tahapan text,
  status text,
  constraint ranperda_tahapan_chk check (tahapan is null or tahapan in ('Penyusunan', 'Pembahasan Tingkat I', 'Pembahasan Tingkat II', 'Persetujuan Bersama', 'Ditetapkan')),
  constraint ranperda_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.naskahakademik (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  ranperda text references public.ranperda(id) on delete set null,
  penyusun text,
  tanggal date,
  status text,
  constraint naskahakademik_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.dim (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  ranperda text references public.ranperda(id) on delete set null,
  pasal text,
  jenis text,
  status text,
  constraint dim_jenis_chk check (jenis is null or jenis in ('Perubahan', 'Penambahan', 'Penghapusan', 'Tetap')),
  constraint dim_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.harmonisasi (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  ranperda text references public.ranperda(id) on delete set null,
  tanggal date,
  catatan text,
  status text,
  constraint harmonisasi_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.jdih (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  regulasi text references public.regulasi(id) on delete set null,
  jenis text,
  status text,
  constraint jdih_jenis_chk check (jenis is null or jenis in ('Perda', 'Perbup', 'Keputusan DPRD', 'Peraturan DPRD', 'Peraturan Pemerintah')),
  constraint jdih_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai'))
);

create table if not exists public.kua (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  tahun numeric,
  pagu numeric,
  tanggal date,
  status text,
  constraint kua_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.ppas (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  kua text references public.kua(id) on delete set null,
  tahun numeric,
  pagu numeric,
  tanggal date,
  status text,
  constraint ppas_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.apbd (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  ppas text references public.ppas(id) on delete set null,
  tahun numeric,
  pagu numeric,
  tanggal date,
  status text,
  constraint apbd_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.apbdp (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  apbd text references public.apbd(id) on delete set null,
  tahun numeric,
  pagu numeric,
  tanggal date,
  status text,
  constraint apbdp_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.lapsemester (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  apbd text references public.apbd(id) on delete set null,
  periode text,
  realisasi numeric,
  tanggal date,
  status text,
  constraint lapsemester_periode_chk check (periode is null or periode in ('Semester I', 'Semester II')),
  constraint lapsemester_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.pertanggungjawaban (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  apbd text references public.apbd(id) on delete set null,
  tahun numeric,
  realisasi numeric,
  tanggal date,
  status text,
  constraint pertanggungjawaban_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.monopd (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  opd text,
  tanggal date,
  jumlah_temuan numeric,
  status text,
  constraint monopd_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.monprogram (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  program text references public.program(id) on delete set null,
  tanggal date,
  capaian numeric,
  status text,
  constraint monprogram_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.monproyek (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  kegiatan text references public.kegiatan(id) on delete set null,
  lokasi text,
  pagu numeric,
  progres numeric,
  status text,
  constraint monproyek_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.lkpj (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  tahun numeric,
  opd text,
  tanggal date,
  status text,
  constraint lkpj_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.temuan (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  proyek text references public.monproyek(id) on delete set null,
  jenis text,
  nilai numeric,
  status text,
  constraint temuan_jenis_chk check (jenis is null or jenis in ('Administrasi', 'Kualitas', 'Volume', 'Keterlambatan')),
  constraint temuan_status_chk check (status is null or status in ('Terbuka', 'Dalam Tindak Lanjut', 'Selesai'))
);

create table if not exists public.rekomendasi (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  temuan text references public.temuan(id) on delete set null,
  tenggat date,
  status text,
  constraint rekomendasi_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.tindaklanjut (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  rekomendasi text references public.rekomendasi(id) on delete set null,
  tanggal date,
  status text,
  constraint tindaklanjut_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.reses (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  anggota text references public.anggota(id) on delete set null,
  dapil text,
  tanggal date,
  peserta numeric,
  status text,
  constraint reses_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.pokir (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  anggota text references public.anggota(id) on delete set null,
  dapil text,
  usulan numeric,
  status text,
  constraint pokir_status_chk check (status is null or status in ('Diusulkan', 'Disinkronkan', 'Masuk APBD', 'Ditolak'))
);

create table if not exists public.hearing (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  komisi text references public.komisi(id) on delete set null,
  narasumber text,
  tanggal date,
  status text,
  constraint hearing_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.audiensi (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  penerima text references public.anggota(id) on delete set null,
  tanggal date,
  tuntutan text,
  status text,
  constraint audiensi_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.aspirasidigital (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  kanal text,
  dapil text,
  tanggal date,
  status text,
  constraint aspirasidigital_kanal_chk check (kanal is null or kanal in ('Portal Web', 'Aplikasi', 'Media Sosial', 'Surat Elektronik')),
  constraint aspirasidigital_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.pengaduan (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  kanal text,
  unit text,
  tenggat date,
  status text,
  constraint pengaduan_kanal_chk check (kanal is null or kanal in ('Langsung', 'Surat', 'Portal Web', 'Media Sosial')),
  constraint pengaduan_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.berita (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  kategori text,
  penulis text,
  tanggal date,
  status text,
  constraint berita_kategori_chk check (kategori is null or kategori in ('Persidangan', 'Legislasi', 'Pengawasan', 'Aspirasi', 'Kegiatan Umum')),
  constraint berita_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.publikasi (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  jenis text,
  kanal text,
  tanggal date,
  status text,
  constraint publikasi_jenis_chk check (jenis is null or jenis in ('Siaran Pers', 'Buletin', 'Laporan Tahunan', 'Infografis', 'Video')),
  constraint publikasi_kanal_chk check (kanal is null or kanal in ('Website', 'Media Sosial', 'Media Cetak', 'YouTube')),
  constraint publikasi_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.dokumentasi (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  kegiatan text references public.rapat(id) on delete set null,
  jumlah numeric,
  tanggal date,
  status text,
  constraint dokumentasi_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai'))
);

create table if not exists public.mediamon (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  media text,
  sentimen text,
  tanggal date,
  status text,
  constraint mediamon_sentimen_chk check (sentimen is null or sentimen in ('Positif', 'Netral', 'Negatif')),
  constraint mediamon_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

create table if not exists public.protokoler (
  id text primary key,
  dibuat date,
  diubah date,
  kode text,
  nama text,
  tamu text,
  jenis text,
  tanggal date,
  status text,
  constraint protokoler_jenis_chk check (jenis is null or jenis in ('Kunjungan Tamu', 'Upacara', 'Acara Resmi', 'Penerimaan Delegasi')),
  constraint protokoler_status_chk check (status is null or status in ('Draft', 'Berjalan', 'Selesai', 'Terlambat'))
);

-- ===== LAMPIRAN =====
-- Berkas di bucket privat Supabase Storage; catatan di tabel lampiran (modul = nama tabel modul).
create table if not exists public.lampiran (
  id text primary key,
  modul text not null,
  record_id text not null,
  nama_file text not null,
  path text not null,
  ukuran bigint,
  tipe text,
  tanggal date
);
alter table public.lampiran enable row level security;
drop policy if exists "lampiran_baca" on public.lampiran;
create policy "lampiran_baca" on public.lampiran for select to authenticated using (arka_baca(modul));
drop policy if exists "lampiran_tulis" on public.lampiran;
create policy "lampiran_tulis" on public.lampiran for insert to authenticated with check (arka_tulis(modul));
drop policy if exists "lampiran_hapus" on public.lampiran;
create policy "lampiran_hapus" on public.lampiran for delete to authenticated using (arka_tulis(modul));

insert into storage.buckets (id, name, public) values ('arka-lampiran', 'arka-lampiran', false)
  on conflict (id) do nothing;
drop policy if exists "arka_lampiran_baca" on storage.objects;
create policy "arka_lampiran_baca" on storage.objects for select to authenticated
  using (bucket_id = 'arka-lampiran' and arka_baca((storage.foldername(name))[1]));
drop policy if exists "arka_lampiran_tulis" on storage.objects;
create policy "arka_lampiran_tulis" on storage.objects for insert to authenticated
  with check (bucket_id = 'arka-lampiran' and arka_tulis((storage.foldername(name))[1]));
drop policy if exists "arka_lampiran_hapus" on storage.objects;
create policy "arka_lampiran_hapus" on storage.objects for delete to authenticated
  using (bucket_id = 'arka-lampiran' and arka_tulis((storage.foldername(name))[1]));

-- ===== KEAMANAN BARIS (RLS) =====
-- Baca: sesuai arka_baca(). Tambah dan ubah: sesuai arka_tulis(). Hapus: admin saja.
-- Audit log: dibaca admin; setiap pengguna terautentikasi boleh menambah catatan.
drop policy if exists "audit_log_akses_terautentikasi" on public.audit_log;
alter table public.audit_log enable row level security;
drop policy if exists "audit_log_baca" on public.audit_log;
create policy "audit_log_baca" on public.audit_log for select to authenticated using (arka_peran() = 'admin');
drop policy if exists "audit_log_tambah" on public.audit_log;
create policy "audit_log_tambah" on public.audit_log for insert to authenticated with check (arka_peran() is not null);

drop policy if exists "pegawai_akses_terautentikasi" on public.pegawai;
alter table public.pegawai enable row level security;
drop policy if exists "pegawai_baca" on public.pegawai;
create policy "pegawai_baca" on public.pegawai for select to authenticated using (arka_baca('pegawai'));
drop policy if exists "pegawai_tambah" on public.pegawai;
create policy "pegawai_tambah" on public.pegawai for insert to authenticated with check (arka_tulis('pegawai'));
drop policy if exists "pegawai_ubah" on public.pegawai;
create policy "pegawai_ubah" on public.pegawai for update to authenticated using (arka_tulis('pegawai')) with check (arka_tulis('pegawai'));
drop policy if exists "pegawai_hapus" on public.pegawai;
create policy "pegawai_hapus" on public.pegawai for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "anggota_akses_terautentikasi" on public.anggota;
alter table public.anggota enable row level security;
drop policy if exists "anggota_baca" on public.anggota;
create policy "anggota_baca" on public.anggota for select to authenticated using (arka_baca('anggota'));
drop policy if exists "anggota_tambah" on public.anggota;
create policy "anggota_tambah" on public.anggota for insert to authenticated with check (arka_tulis('anggota'));
drop policy if exists "anggota_ubah" on public.anggota;
create policy "anggota_ubah" on public.anggota for update to authenticated using (arka_tulis('anggota')) with check (arka_tulis('anggota'));
drop policy if exists "anggota_hapus" on public.anggota;
create policy "anggota_hapus" on public.anggota for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "komisi_akses_terautentikasi" on public.komisi;
alter table public.komisi enable row level security;
drop policy if exists "komisi_baca" on public.komisi;
create policy "komisi_baca" on public.komisi for select to authenticated using (arka_baca('komisi'));
drop policy if exists "komisi_tambah" on public.komisi;
create policy "komisi_tambah" on public.komisi for insert to authenticated with check (arka_tulis('komisi'));
drop policy if exists "komisi_ubah" on public.komisi;
create policy "komisi_ubah" on public.komisi for update to authenticated using (arka_tulis('komisi')) with check (arka_tulis('komisi'));
drop policy if exists "komisi_hapus" on public.komisi;
create policy "komisi_hapus" on public.komisi for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "fraksi_akses_terautentikasi" on public.fraksi;
alter table public.fraksi enable row level security;
drop policy if exists "fraksi_baca" on public.fraksi;
create policy "fraksi_baca" on public.fraksi for select to authenticated using (arka_baca('fraksi'));
drop policy if exists "fraksi_tambah" on public.fraksi;
create policy "fraksi_tambah" on public.fraksi for insert to authenticated with check (arka_tulis('fraksi'));
drop policy if exists "fraksi_ubah" on public.fraksi;
create policy "fraksi_ubah" on public.fraksi for update to authenticated using (arka_tulis('fraksi')) with check (arka_tulis('fraksi'));
drop policy if exists "fraksi_hapus" on public.fraksi;
create policy "fraksi_hapus" on public.fraksi for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "alat_akses_terautentikasi" on public.alat;
alter table public.alat enable row level security;
drop policy if exists "alat_baca" on public.alat;
create policy "alat_baca" on public.alat for select to authenticated using (arka_baca('alat'));
drop policy if exists "alat_tambah" on public.alat;
create policy "alat_tambah" on public.alat for insert to authenticated with check (arka_tulis('alat'));
drop policy if exists "alat_ubah" on public.alat;
create policy "alat_ubah" on public.alat for update to authenticated using (arka_tulis('alat')) with check (arka_tulis('alat'));
drop policy if exists "alat_hapus" on public.alat;
create policy "alat_hapus" on public.alat for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "tenaga_akses_terautentikasi" on public.tenaga;
alter table public.tenaga enable row level security;
drop policy if exists "tenaga_baca" on public.tenaga;
create policy "tenaga_baca" on public.tenaga for select to authenticated using (arka_baca('tenaga'));
drop policy if exists "tenaga_tambah" on public.tenaga;
create policy "tenaga_tambah" on public.tenaga for insert to authenticated with check (arka_tulis('tenaga'));
drop policy if exists "tenaga_ubah" on public.tenaga;
create policy "tenaga_ubah" on public.tenaga for update to authenticated using (arka_tulis('tenaga')) with check (arka_tulis('tenaga'));
drop policy if exists "tenaga_hapus" on public.tenaga;
create policy "tenaga_hapus" on public.tenaga for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "mitra_akses_terautentikasi" on public.mitra;
alter table public.mitra enable row level security;
drop policy if exists "mitra_baca" on public.mitra;
create policy "mitra_baca" on public.mitra for select to authenticated using (arka_baca('mitra'));
drop policy if exists "mitra_tambah" on public.mitra;
create policy "mitra_tambah" on public.mitra for insert to authenticated with check (arka_tulis('mitra'));
drop policy if exists "mitra_ubah" on public.mitra;
create policy "mitra_ubah" on public.mitra for update to authenticated using (arka_tulis('mitra')) with check (arka_tulis('mitra'));
drop policy if exists "mitra_hapus" on public.mitra;
create policy "mitra_hapus" on public.mitra for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "program_akses_terautentikasi" on public.program;
alter table public.program enable row level security;
drop policy if exists "program_baca" on public.program;
create policy "program_baca" on public.program for select to authenticated using (arka_baca('program'));
drop policy if exists "program_tambah" on public.program;
create policy "program_tambah" on public.program for insert to authenticated with check (arka_tulis('program'));
drop policy if exists "program_ubah" on public.program;
create policy "program_ubah" on public.program for update to authenticated using (arka_tulis('program')) with check (arka_tulis('program'));
drop policy if exists "program_hapus" on public.program;
create policy "program_hapus" on public.program for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "kegiatan_akses_terautentikasi" on public.kegiatan;
alter table public.kegiatan enable row level security;
drop policy if exists "kegiatan_baca" on public.kegiatan;
create policy "kegiatan_baca" on public.kegiatan for select to authenticated using (arka_baca('kegiatan'));
drop policy if exists "kegiatan_tambah" on public.kegiatan;
create policy "kegiatan_tambah" on public.kegiatan for insert to authenticated with check (arka_tulis('kegiatan'));
drop policy if exists "kegiatan_ubah" on public.kegiatan;
create policy "kegiatan_ubah" on public.kegiatan for update to authenticated using (arka_tulis('kegiatan')) with check (arka_tulis('kegiatan'));
drop policy if exists "kegiatan_hapus" on public.kegiatan;
create policy "kegiatan_hapus" on public.kegiatan for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "subkegiatan_akses_terautentikasi" on public.subkegiatan;
alter table public.subkegiatan enable row level security;
drop policy if exists "subkegiatan_baca" on public.subkegiatan;
create policy "subkegiatan_baca" on public.subkegiatan for select to authenticated using (arka_baca('subkegiatan'));
drop policy if exists "subkegiatan_tambah" on public.subkegiatan;
create policy "subkegiatan_tambah" on public.subkegiatan for insert to authenticated with check (arka_tulis('subkegiatan'));
drop policy if exists "subkegiatan_ubah" on public.subkegiatan;
create policy "subkegiatan_ubah" on public.subkegiatan for update to authenticated using (arka_tulis('subkegiatan')) with check (arka_tulis('subkegiatan'));
drop policy if exists "subkegiatan_hapus" on public.subkegiatan;
create policy "subkegiatan_hapus" on public.subkegiatan for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "iku_akses_terautentikasi" on public.iku;
alter table public.iku enable row level security;
drop policy if exists "iku_baca" on public.iku;
create policy "iku_baca" on public.iku for select to authenticated using (arka_baca('iku'));
drop policy if exists "iku_tambah" on public.iku;
create policy "iku_tambah" on public.iku for insert to authenticated with check (arka_tulis('iku'));
drop policy if exists "iku_ubah" on public.iku;
create policy "iku_ubah" on public.iku for update to authenticated using (arka_tulis('iku')) with check (arka_tulis('iku'));
drop policy if exists "iku_hapus" on public.iku;
create policy "iku_hapus" on public.iku for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "sasaran_akses_terautentikasi" on public.sasaran;
alter table public.sasaran enable row level security;
drop policy if exists "sasaran_baca" on public.sasaran;
create policy "sasaran_baca" on public.sasaran for select to authenticated using (arka_baca('sasaran'));
drop policy if exists "sasaran_tambah" on public.sasaran;
create policy "sasaran_tambah" on public.sasaran for insert to authenticated with check (arka_tulis('sasaran'));
drop policy if exists "sasaran_ubah" on public.sasaran;
create policy "sasaran_ubah" on public.sasaran for update to authenticated using (arka_tulis('sasaran')) with check (arka_tulis('sasaran'));
drop policy if exists "sasaran_hapus" on public.sasaran;
create policy "sasaran_hapus" on public.sasaran for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "iki_akses_terautentikasi" on public.iki;
alter table public.iki enable row level security;
drop policy if exists "iki_baca" on public.iki;
create policy "iki_baca" on public.iki for select to authenticated using (arka_baca('iki'));
drop policy if exists "iki_tambah" on public.iki;
create policy "iki_tambah" on public.iki for insert to authenticated with check (arka_tulis('iki'));
drop policy if exists "iki_ubah" on public.iki;
create policy "iki_ubah" on public.iki for update to authenticated using (arka_tulis('iki')) with check (arka_tulis('iki'));
drop policy if exists "iki_hapus" on public.iki;
create policy "iki_hapus" on public.iki for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "regulasi_akses_terautentikasi" on public.regulasi;
alter table public.regulasi enable row level security;
drop policy if exists "regulasi_baca" on public.regulasi;
create policy "regulasi_baca" on public.regulasi for select to authenticated using (arka_baca('regulasi'));
drop policy if exists "regulasi_tambah" on public.regulasi;
create policy "regulasi_tambah" on public.regulasi for insert to authenticated with check (arka_tulis('regulasi'));
drop policy if exists "regulasi_ubah" on public.regulasi;
create policy "regulasi_ubah" on public.regulasi for update to authenticated using (arka_tulis('regulasi')) with check (arka_tulis('regulasi'));
drop policy if exists "regulasi_hapus" on public.regulasi;
create policy "regulasi_hapus" on public.regulasi for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "rpjmd_akses_terautentikasi" on public.rpjmd;
alter table public.rpjmd enable row level security;
drop policy if exists "rpjmd_baca" on public.rpjmd;
create policy "rpjmd_baca" on public.rpjmd for select to authenticated using (arka_baca('rpjmd'));
drop policy if exists "rpjmd_tambah" on public.rpjmd;
create policy "rpjmd_tambah" on public.rpjmd for insert to authenticated with check (arka_tulis('rpjmd'));
drop policy if exists "rpjmd_ubah" on public.rpjmd;
create policy "rpjmd_ubah" on public.rpjmd for update to authenticated using (arka_tulis('rpjmd')) with check (arka_tulis('rpjmd'));
drop policy if exists "rpjmd_hapus" on public.rpjmd;
create policy "rpjmd_hapus" on public.rpjmd for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "renstra_akses_terautentikasi" on public.renstra;
alter table public.renstra enable row level security;
drop policy if exists "renstra_baca" on public.renstra;
create policy "renstra_baca" on public.renstra for select to authenticated using (arka_baca('renstra'));
drop policy if exists "renstra_tambah" on public.renstra;
create policy "renstra_tambah" on public.renstra for insert to authenticated with check (arka_tulis('renstra'));
drop policy if exists "renstra_ubah" on public.renstra;
create policy "renstra_ubah" on public.renstra for update to authenticated using (arka_tulis('renstra')) with check (arka_tulis('renstra'));
drop policy if exists "renstra_hapus" on public.renstra;
create policy "renstra_hapus" on public.renstra for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "renja_akses_terautentikasi" on public.renja;
alter table public.renja enable row level security;
drop policy if exists "renja_baca" on public.renja;
create policy "renja_baca" on public.renja for select to authenticated using (arka_baca('renja'));
drop policy if exists "renja_tambah" on public.renja;
create policy "renja_tambah" on public.renja for insert to authenticated with check (arka_tulis('renja'));
drop policy if exists "renja_ubah" on public.renja;
create policy "renja_ubah" on public.renja for update to authenticated using (arka_tulis('renja')) with check (arka_tulis('renja'));
drop policy if exists "renja_hapus" on public.renja;
create policy "renja_hapus" on public.renja for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "cascading_akses_terautentikasi" on public.cascading;
alter table public.cascading enable row level security;
drop policy if exists "cascading_baca" on public.cascading;
create policy "cascading_baca" on public.cascading for select to authenticated using (arka_baca('cascading'));
drop policy if exists "cascading_tambah" on public.cascading;
create policy "cascading_tambah" on public.cascading for insert to authenticated with check (arka_tulis('cascading'));
drop policy if exists "cascading_ubah" on public.cascading;
create policy "cascading_ubah" on public.cascading for update to authenticated using (arka_tulis('cascading')) with check (arka_tulis('cascading'));
drop policy if exists "cascading_hapus" on public.cascading;
create policy "cascading_hapus" on public.cascading for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "pohon_akses_terautentikasi" on public.pohon;
alter table public.pohon enable row level security;
drop policy if exists "pohon_baca" on public.pohon;
create policy "pohon_baca" on public.pohon for select to authenticated using (arka_baca('pohon'));
drop policy if exists "pohon_tambah" on public.pohon;
create policy "pohon_tambah" on public.pohon for insert to authenticated with check (arka_tulis('pohon'));
drop policy if exists "pohon_ubah" on public.pohon;
create policy "pohon_ubah" on public.pohon for update to authenticated using (arka_tulis('pohon')) with check (arka_tulis('pohon'));
drop policy if exists "pohon_hapus" on public.pohon;
create policy "pohon_hapus" on public.pohon for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "perjanjian_akses_terautentikasi" on public.perjanjian;
alter table public.perjanjian enable row level security;
drop policy if exists "perjanjian_baca" on public.perjanjian;
create policy "perjanjian_baca" on public.perjanjian for select to authenticated using (arka_baca('perjanjian'));
drop policy if exists "perjanjian_tambah" on public.perjanjian;
create policy "perjanjian_tambah" on public.perjanjian for insert to authenticated with check (arka_tulis('perjanjian'));
drop policy if exists "perjanjian_ubah" on public.perjanjian;
create policy "perjanjian_ubah" on public.perjanjian for update to authenticated using (arka_tulis('perjanjian')) with check (arka_tulis('perjanjian'));
drop policy if exists "perjanjian_hapus" on public.perjanjian;
create policy "perjanjian_hapus" on public.perjanjian for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "rencanaaksi_akses_terautentikasi" on public.rencanaaksi;
alter table public.rencanaaksi enable row level security;
drop policy if exists "rencanaaksi_baca" on public.rencanaaksi;
create policy "rencanaaksi_baca" on public.rencanaaksi for select to authenticated using (arka_baca('rencanaaksi'));
drop policy if exists "rencanaaksi_tambah" on public.rencanaaksi;
create policy "rencanaaksi_tambah" on public.rencanaaksi for insert to authenticated with check (arka_tulis('rencanaaksi'));
drop policy if exists "rencanaaksi_ubah" on public.rencanaaksi;
create policy "rencanaaksi_ubah" on public.rencanaaksi for update to authenticated using (arka_tulis('rencanaaksi')) with check (arka_tulis('rencanaaksi'));
drop policy if exists "rencanaaksi_hapus" on public.rencanaaksi;
create policy "rencanaaksi_hapus" on public.rencanaaksi for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "ikuk_akses_terautentikasi" on public.ikuk;
alter table public.ikuk enable row level security;
drop policy if exists "ikuk_baca" on public.ikuk;
create policy "ikuk_baca" on public.ikuk for select to authenticated using (arka_baca('ikuk'));
drop policy if exists "ikuk_tambah" on public.ikuk;
create policy "ikuk_tambah" on public.ikuk for insert to authenticated with check (arka_tulis('ikuk'));
drop policy if exists "ikuk_ubah" on public.ikuk;
create policy "ikuk_ubah" on public.ikuk for update to authenticated using (arka_tulis('ikuk')) with check (arka_tulis('ikuk'));
drop policy if exists "ikuk_hapus" on public.ikuk;
create policy "ikuk_hapus" on public.ikuk for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "ikik_akses_terautentikasi" on public.ikik;
alter table public.ikik enable row level security;
drop policy if exists "ikik_baca" on public.ikik;
create policy "ikik_baca" on public.ikik for select to authenticated using (arka_baca('ikik'));
drop policy if exists "ikik_tambah" on public.ikik;
create policy "ikik_tambah" on public.ikik for insert to authenticated with check (arka_tulis('ikik'));
drop policy if exists "ikik_ubah" on public.ikik;
create policy "ikik_ubah" on public.ikik for update to authenticated using (arka_tulis('ikik')) with check (arka_tulis('ikik'));
drop policy if exists "ikik_hapus" on public.ikik;
create policy "ikik_hapus" on public.ikik for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "monitoring_akses_terautentikasi" on public.monitoring;
alter table public.monitoring enable row level security;
drop policy if exists "monitoring_baca" on public.monitoring;
create policy "monitoring_baca" on public.monitoring for select to authenticated using (arka_baca('monitoring'));
drop policy if exists "monitoring_tambah" on public.monitoring;
create policy "monitoring_tambah" on public.monitoring for insert to authenticated with check (arka_tulis('monitoring'));
drop policy if exists "monitoring_ubah" on public.monitoring;
create policy "monitoring_ubah" on public.monitoring for update to authenticated using (arka_tulis('monitoring')) with check (arka_tulis('monitoring'));
drop policy if exists "monitoring_hapus" on public.monitoring;
create policy "monitoring_hapus" on public.monitoring for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "evaluasi_akses_terautentikasi" on public.evaluasi;
alter table public.evaluasi enable row level security;
drop policy if exists "evaluasi_baca" on public.evaluasi;
create policy "evaluasi_baca" on public.evaluasi for select to authenticated using (arka_baca('evaluasi'));
drop policy if exists "evaluasi_tambah" on public.evaluasi;
create policy "evaluasi_tambah" on public.evaluasi for insert to authenticated with check (arka_tulis('evaluasi'));
drop policy if exists "evaluasi_ubah" on public.evaluasi;
create policy "evaluasi_ubah" on public.evaluasi for update to authenticated using (arka_tulis('evaluasi')) with check (arka_tulis('evaluasi'));
drop policy if exists "evaluasi_hapus" on public.evaluasi;
create policy "evaluasi_hapus" on public.evaluasi for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "persuratan_akses_terautentikasi" on public.persuratan;
alter table public.persuratan enable row level security;
drop policy if exists "persuratan_baca" on public.persuratan;
create policy "persuratan_baca" on public.persuratan for select to authenticated using (arka_baca('persuratan'));
drop policy if exists "persuratan_tambah" on public.persuratan;
create policy "persuratan_tambah" on public.persuratan for insert to authenticated with check (arka_tulis('persuratan'));
drop policy if exists "persuratan_ubah" on public.persuratan;
create policy "persuratan_ubah" on public.persuratan for update to authenticated using (arka_tulis('persuratan')) with check (arka_tulis('persuratan'));
drop policy if exists "persuratan_hapus" on public.persuratan;
create policy "persuratan_hapus" on public.persuratan for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "arsip_akses_terautentikasi" on public.arsip;
alter table public.arsip enable row level security;
drop policy if exists "arsip_baca" on public.arsip;
create policy "arsip_baca" on public.arsip for select to authenticated using (arka_baca('arsip'));
drop policy if exists "arsip_tambah" on public.arsip;
create policy "arsip_tambah" on public.arsip for insert to authenticated with check (arka_tulis('arsip'));
drop policy if exists "arsip_ubah" on public.arsip;
create policy "arsip_ubah" on public.arsip for update to authenticated using (arka_tulis('arsip')) with check (arka_tulis('arsip'));
drop policy if exists "arsip_hapus" on public.arsip;
create policy "arsip_hapus" on public.arsip for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "perjalanan_akses_terautentikasi" on public.perjalanan;
alter table public.perjalanan enable row level security;
drop policy if exists "perjalanan_baca" on public.perjalanan;
create policy "perjalanan_baca" on public.perjalanan for select to authenticated using (arka_baca('perjalanan'));
drop policy if exists "perjalanan_tambah" on public.perjalanan;
create policy "perjalanan_tambah" on public.perjalanan for insert to authenticated with check (arka_tulis('perjalanan'));
drop policy if exists "perjalanan_ubah" on public.perjalanan;
create policy "perjalanan_ubah" on public.perjalanan for update to authenticated using (arka_tulis('perjalanan')) with check (arka_tulis('perjalanan'));
drop policy if exists "perjalanan_hapus" on public.perjalanan;
create policy "perjalanan_hapus" on public.perjalanan for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "kepegawaian_akses_terautentikasi" on public.kepegawaian;
alter table public.kepegawaian enable row level security;
drop policy if exists "kepegawaian_baca" on public.kepegawaian;
create policy "kepegawaian_baca" on public.kepegawaian for select to authenticated using (arka_baca('kepegawaian'));
drop policy if exists "kepegawaian_tambah" on public.kepegawaian;
create policy "kepegawaian_tambah" on public.kepegawaian for insert to authenticated with check (arka_tulis('kepegawaian'));
drop policy if exists "kepegawaian_ubah" on public.kepegawaian;
create policy "kepegawaian_ubah" on public.kepegawaian for update to authenticated using (arka_tulis('kepegawaian')) with check (arka_tulis('kepegawaian'));
drop policy if exists "kepegawaian_hapus" on public.kepegawaian;
create policy "kepegawaian_hapus" on public.kepegawaian for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "rumahtangga_akses_terautentikasi" on public.rumahtangga;
alter table public.rumahtangga enable row level security;
drop policy if exists "rumahtangga_baca" on public.rumahtangga;
create policy "rumahtangga_baca" on public.rumahtangga for select to authenticated using (arka_baca('rumahtangga'));
drop policy if exists "rumahtangga_tambah" on public.rumahtangga;
create policy "rumahtangga_tambah" on public.rumahtangga for insert to authenticated with check (arka_tulis('rumahtangga'));
drop policy if exists "rumahtangga_ubah" on public.rumahtangga;
create policy "rumahtangga_ubah" on public.rumahtangga for update to authenticated using (arka_tulis('rumahtangga')) with check (arka_tulis('rumahtangga'));
drop policy if exists "rumahtangga_hapus" on public.rumahtangga;
create policy "rumahtangga_hapus" on public.rumahtangga for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "kendaraan_akses_terautentikasi" on public.kendaraan;
alter table public.kendaraan enable row level security;
drop policy if exists "kendaraan_baca" on public.kendaraan;
create policy "kendaraan_baca" on public.kendaraan for select to authenticated using (arka_baca('kendaraan'));
drop policy if exists "kendaraan_tambah" on public.kendaraan;
create policy "kendaraan_tambah" on public.kendaraan for insert to authenticated with check (arka_tulis('kendaraan'));
drop policy if exists "kendaraan_ubah" on public.kendaraan;
create policy "kendaraan_ubah" on public.kendaraan for update to authenticated using (arka_tulis('kendaraan')) with check (arka_tulis('kendaraan'));
drop policy if exists "kendaraan_hapus" on public.kendaraan;
create policy "kendaraan_hapus" on public.kendaraan for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "anggaran_akses_terautentikasi" on public.anggaran;
alter table public.anggaran enable row level security;
drop policy if exists "anggaran_baca" on public.anggaran;
create policy "anggaran_baca" on public.anggaran for select to authenticated using (arka_baca('anggaran'));
drop policy if exists "anggaran_tambah" on public.anggaran;
create policy "anggaran_tambah" on public.anggaran for insert to authenticated with check (arka_tulis('anggaran'));
drop policy if exists "anggaran_ubah" on public.anggaran;
create policy "anggaran_ubah" on public.anggaran for update to authenticated using (arka_tulis('anggaran')) with check (arka_tulis('anggaran'));
drop policy if exists "anggaran_hapus" on public.anggaran;
create policy "anggaran_hapus" on public.anggaran for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "spj_akses_terautentikasi" on public.spj;
alter table public.spj enable row level security;
drop policy if exists "spj_baca" on public.spj;
create policy "spj_baca" on public.spj for select to authenticated using (arka_baca('spj'));
drop policy if exists "spj_tambah" on public.spj;
create policy "spj_tambah" on public.spj for insert to authenticated with check (arka_tulis('spj'));
drop policy if exists "spj_ubah" on public.spj;
create policy "spj_ubah" on public.spj for update to authenticated using (arka_tulis('spj')) with check (arka_tulis('spj'));
drop policy if exists "spj_hapus" on public.spj;
create policy "spj_hapus" on public.spj for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "aset_rencana_akses_terautentikasi" on public.aset_rencana;
alter table public.aset_rencana enable row level security;
drop policy if exists "aset_rencana_baca" on public.aset_rencana;
create policy "aset_rencana_baca" on public.aset_rencana for select to authenticated using (arka_baca('aset_rencana'));
drop policy if exists "aset_rencana_tambah" on public.aset_rencana;
create policy "aset_rencana_tambah" on public.aset_rencana for insert to authenticated with check (arka_tulis('aset_rencana'));
drop policy if exists "aset_rencana_ubah" on public.aset_rencana;
create policy "aset_rencana_ubah" on public.aset_rencana for update to authenticated using (arka_tulis('aset_rencana')) with check (arka_tulis('aset_rencana'));
drop policy if exists "aset_rencana_hapus" on public.aset_rencana;
create policy "aset_rencana_hapus" on public.aset_rencana for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "inventaris_akses_terautentikasi" on public.inventaris;
alter table public.inventaris enable row level security;
drop policy if exists "inventaris_baca" on public.inventaris;
create policy "inventaris_baca" on public.inventaris for select to authenticated using (arka_baca('inventaris'));
drop policy if exists "inventaris_tambah" on public.inventaris;
create policy "inventaris_tambah" on public.inventaris for insert to authenticated with check (arka_tulis('inventaris'));
drop policy if exists "inventaris_ubah" on public.inventaris;
create policy "inventaris_ubah" on public.inventaris for update to authenticated using (arka_tulis('inventaris')) with check (arka_tulis('inventaris'));
drop policy if exists "inventaris_hapus" on public.inventaris;
create policy "inventaris_hapus" on public.inventaris for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "pemeliharaan_akses_terautentikasi" on public.pemeliharaan;
alter table public.pemeliharaan enable row level security;
drop policy if exists "pemeliharaan_baca" on public.pemeliharaan;
create policy "pemeliharaan_baca" on public.pemeliharaan for select to authenticated using (arka_baca('pemeliharaan'));
drop policy if exists "pemeliharaan_tambah" on public.pemeliharaan;
create policy "pemeliharaan_tambah" on public.pemeliharaan for insert to authenticated with check (arka_tulis('pemeliharaan'));
drop policy if exists "pemeliharaan_ubah" on public.pemeliharaan;
create policy "pemeliharaan_ubah" on public.pemeliharaan for update to authenticated using (arka_tulis('pemeliharaan')) with check (arka_tulis('pemeliharaan'));
drop policy if exists "pemeliharaan_hapus" on public.pemeliharaan;
create policy "pemeliharaan_hapus" on public.pemeliharaan for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "mutasi_akses_terautentikasi" on public.mutasi;
alter table public.mutasi enable row level security;
drop policy if exists "mutasi_baca" on public.mutasi;
create policy "mutasi_baca" on public.mutasi for select to authenticated using (arka_baca('mutasi'));
drop policy if exists "mutasi_tambah" on public.mutasi;
create policy "mutasi_tambah" on public.mutasi for insert to authenticated with check (arka_tulis('mutasi'));
drop policy if exists "mutasi_ubah" on public.mutasi;
create policy "mutasi_ubah" on public.mutasi for update to authenticated using (arka_tulis('mutasi')) with check (arka_tulis('mutasi'));
drop policy if exists "mutasi_hapus" on public.mutasi;
create policy "mutasi_hapus" on public.mutasi for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "penghapusan_akses_terautentikasi" on public.penghapusan;
alter table public.penghapusan enable row level security;
drop policy if exists "penghapusan_baca" on public.penghapusan;
create policy "penghapusan_baca" on public.penghapusan for select to authenticated using (arka_baca('penghapusan'));
drop policy if exists "penghapusan_tambah" on public.penghapusan;
create policy "penghapusan_tambah" on public.penghapusan for insert to authenticated with check (arka_tulis('penghapusan'));
drop policy if exists "penghapusan_ubah" on public.penghapusan;
create policy "penghapusan_ubah" on public.penghapusan for update to authenticated using (arka_tulis('penghapusan')) with check (arka_tulis('penghapusan'));
drop policy if exists "penghapusan_hapus" on public.penghapusan;
create policy "penghapusan_hapus" on public.penghapusan for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "rekonsiliasi_akses_terautentikasi" on public.rekonsiliasi;
alter table public.rekonsiliasi enable row level security;
drop policy if exists "rekonsiliasi_baca" on public.rekonsiliasi;
create policy "rekonsiliasi_baca" on public.rekonsiliasi for select to authenticated using (arka_baca('rekonsiliasi'));
drop policy if exists "rekonsiliasi_tambah" on public.rekonsiliasi;
create policy "rekonsiliasi_tambah" on public.rekonsiliasi for insert to authenticated with check (arka_tulis('rekonsiliasi'));
drop policy if exists "rekonsiliasi_ubah" on public.rekonsiliasi;
create policy "rekonsiliasi_ubah" on public.rekonsiliasi for update to authenticated using (arka_tulis('rekonsiliasi')) with check (arka_tulis('rekonsiliasi'));
drop policy if exists "rekonsiliasi_hapus" on public.rekonsiliasi;
create policy "rekonsiliasi_hapus" on public.rekonsiliasi for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "agenda_akses_terautentikasi" on public.agenda;
alter table public.agenda enable row level security;
drop policy if exists "agenda_baca" on public.agenda;
create policy "agenda_baca" on public.agenda for select to authenticated using (arka_baca('agenda'));
drop policy if exists "agenda_tambah" on public.agenda;
create policy "agenda_tambah" on public.agenda for insert to authenticated with check (arka_tulis('agenda'));
drop policy if exists "agenda_ubah" on public.agenda;
create policy "agenda_ubah" on public.agenda for update to authenticated using (arka_tulis('agenda')) with check (arka_tulis('agenda'));
drop policy if exists "agenda_hapus" on public.agenda;
create policy "agenda_hapus" on public.agenda for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "jadwal_akses_terautentikasi" on public.jadwal;
alter table public.jadwal enable row level security;
drop policy if exists "jadwal_baca" on public.jadwal;
create policy "jadwal_baca" on public.jadwal for select to authenticated using (arka_baca('jadwal'));
drop policy if exists "jadwal_tambah" on public.jadwal;
create policy "jadwal_tambah" on public.jadwal for insert to authenticated with check (arka_tulis('jadwal'));
drop policy if exists "jadwal_ubah" on public.jadwal;
create policy "jadwal_ubah" on public.jadwal for update to authenticated using (arka_tulis('jadwal')) with check (arka_tulis('jadwal'));
drop policy if exists "jadwal_hapus" on public.jadwal;
create policy "jadwal_hapus" on public.jadwal for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "rapat_akses_terautentikasi" on public.rapat;
alter table public.rapat enable row level security;
drop policy if exists "rapat_baca" on public.rapat;
create policy "rapat_baca" on public.rapat for select to authenticated using (arka_baca('rapat'));
drop policy if exists "rapat_tambah" on public.rapat;
create policy "rapat_tambah" on public.rapat for insert to authenticated with check (arka_tulis('rapat'));
drop policy if exists "rapat_ubah" on public.rapat;
create policy "rapat_ubah" on public.rapat for update to authenticated using (arka_tulis('rapat')) with check (arka_tulis('rapat'));
drop policy if exists "rapat_hapus" on public.rapat;
create policy "rapat_hapus" on public.rapat for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "rapat_komisi_akses_terautentikasi" on public.rapat_komisi;
alter table public.rapat_komisi enable row level security;
drop policy if exists "rapat_komisi_baca" on public.rapat_komisi;
create policy "rapat_komisi_baca" on public.rapat_komisi for select to authenticated using (arka_baca('rapat_komisi'));
drop policy if exists "rapat_komisi_tambah" on public.rapat_komisi;
create policy "rapat_komisi_tambah" on public.rapat_komisi for insert to authenticated with check (arka_tulis('rapat_komisi'));
drop policy if exists "rapat_komisi_ubah" on public.rapat_komisi;
create policy "rapat_komisi_ubah" on public.rapat_komisi for update to authenticated using (arka_tulis('rapat_komisi')) with check (arka_tulis('rapat_komisi'));
drop policy if exists "rapat_komisi_hapus" on public.rapat_komisi;
create policy "rapat_komisi_hapus" on public.rapat_komisi for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "banggar_akses_terautentikasi" on public.banggar;
alter table public.banggar enable row level security;
drop policy if exists "banggar_baca" on public.banggar;
create policy "banggar_baca" on public.banggar for select to authenticated using (arka_baca('banggar'));
drop policy if exists "banggar_tambah" on public.banggar;
create policy "banggar_tambah" on public.banggar for insert to authenticated with check (arka_tulis('banggar'));
drop policy if exists "banggar_ubah" on public.banggar;
create policy "banggar_ubah" on public.banggar for update to authenticated using (arka_tulis('banggar')) with check (arka_tulis('banggar'));
drop policy if exists "banggar_hapus" on public.banggar;
create policy "banggar_hapus" on public.banggar for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "bapemperda_akses_terautentikasi" on public.bapemperda;
alter table public.bapemperda enable row level security;
drop policy if exists "bapemperda_baca" on public.bapemperda;
create policy "bapemperda_baca" on public.bapemperda for select to authenticated using (arka_baca('bapemperda'));
drop policy if exists "bapemperda_tambah" on public.bapemperda;
create policy "bapemperda_tambah" on public.bapemperda for insert to authenticated with check (arka_tulis('bapemperda'));
drop policy if exists "bapemperda_ubah" on public.bapemperda;
create policy "bapemperda_ubah" on public.bapemperda for update to authenticated using (arka_tulis('bapemperda')) with check (arka_tulis('bapemperda'));
drop policy if exists "bapemperda_hapus" on public.bapemperda;
create policy "bapemperda_hapus" on public.bapemperda for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "bk_akses_terautentikasi" on public.bk;
alter table public.bk enable row level security;
drop policy if exists "bk_baca" on public.bk;
create policy "bk_baca" on public.bk for select to authenticated using (arka_baca('bk'));
drop policy if exists "bk_tambah" on public.bk;
create policy "bk_tambah" on public.bk for insert to authenticated with check (arka_tulis('bk'));
drop policy if exists "bk_ubah" on public.bk;
create policy "bk_ubah" on public.bk for update to authenticated using (arka_tulis('bk')) with check (arka_tulis('bk'));
drop policy if exists "bk_hapus" on public.bk;
create policy "bk_hapus" on public.bk for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "paripurna_akses_terautentikasi" on public.paripurna;
alter table public.paripurna enable row level security;
drop policy if exists "paripurna_baca" on public.paripurna;
create policy "paripurna_baca" on public.paripurna for select to authenticated using (arka_baca('paripurna'));
drop policy if exists "paripurna_tambah" on public.paripurna;
create policy "paripurna_tambah" on public.paripurna for insert to authenticated with check (arka_tulis('paripurna'));
drop policy if exists "paripurna_ubah" on public.paripurna;
create policy "paripurna_ubah" on public.paripurna for update to authenticated using (arka_tulis('paripurna')) with check (arka_tulis('paripurna'));
drop policy if exists "paripurna_hapus" on public.paripurna;
create policy "paripurna_hapus" on public.paripurna for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "risalah_akses_terautentikasi" on public.risalah;
alter table public.risalah enable row level security;
drop policy if exists "risalah_baca" on public.risalah;
create policy "risalah_baca" on public.risalah for select to authenticated using (arka_baca('risalah'));
drop policy if exists "risalah_tambah" on public.risalah;
create policy "risalah_tambah" on public.risalah for insert to authenticated with check (arka_tulis('risalah'));
drop policy if exists "risalah_ubah" on public.risalah;
create policy "risalah_ubah" on public.risalah for update to authenticated using (arka_tulis('risalah')) with check (arka_tulis('risalah'));
drop policy if exists "risalah_hapus" on public.risalah;
create policy "risalah_hapus" on public.risalah for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "notulen_akses_terautentikasi" on public.notulen;
alter table public.notulen enable row level security;
drop policy if exists "notulen_baca" on public.notulen;
create policy "notulen_baca" on public.notulen for select to authenticated using (arka_baca('notulen'));
drop policy if exists "notulen_tambah" on public.notulen;
create policy "notulen_tambah" on public.notulen for insert to authenticated with check (arka_tulis('notulen'));
drop policy if exists "notulen_ubah" on public.notulen;
create policy "notulen_ubah" on public.notulen for update to authenticated using (arka_tulis('notulen')) with check (arka_tulis('notulen'));
drop policy if exists "notulen_hapus" on public.notulen;
create policy "notulen_hapus" on public.notulen for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "keputusan_akses_terautentikasi" on public.keputusan;
alter table public.keputusan enable row level security;
drop policy if exists "keputusan_baca" on public.keputusan;
create policy "keputusan_baca" on public.keputusan for select to authenticated using (arka_baca('keputusan'));
drop policy if exists "keputusan_tambah" on public.keputusan;
create policy "keputusan_tambah" on public.keputusan for insert to authenticated with check (arka_tulis('keputusan'));
drop policy if exists "keputusan_ubah" on public.keputusan;
create policy "keputusan_ubah" on public.keputusan for update to authenticated using (arka_tulis('keputusan')) with check (arka_tulis('keputusan'));
drop policy if exists "keputusan_hapus" on public.keputusan;
create policy "keputusan_hapus" on public.keputusan for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "propemperda_akses_terautentikasi" on public.propemperda;
alter table public.propemperda enable row level security;
drop policy if exists "propemperda_baca" on public.propemperda;
create policy "propemperda_baca" on public.propemperda for select to authenticated using (arka_baca('propemperda'));
drop policy if exists "propemperda_tambah" on public.propemperda;
create policy "propemperda_tambah" on public.propemperda for insert to authenticated with check (arka_tulis('propemperda'));
drop policy if exists "propemperda_ubah" on public.propemperda;
create policy "propemperda_ubah" on public.propemperda for update to authenticated using (arka_tulis('propemperda')) with check (arka_tulis('propemperda'));
drop policy if exists "propemperda_hapus" on public.propemperda;
create policy "propemperda_hapus" on public.propemperda for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "ranperda_akses_terautentikasi" on public.ranperda;
alter table public.ranperda enable row level security;
drop policy if exists "ranperda_baca" on public.ranperda;
create policy "ranperda_baca" on public.ranperda for select to authenticated using (arka_baca('ranperda'));
drop policy if exists "ranperda_tambah" on public.ranperda;
create policy "ranperda_tambah" on public.ranperda for insert to authenticated with check (arka_tulis('ranperda'));
drop policy if exists "ranperda_ubah" on public.ranperda;
create policy "ranperda_ubah" on public.ranperda for update to authenticated using (arka_tulis('ranperda')) with check (arka_tulis('ranperda'));
drop policy if exists "ranperda_hapus" on public.ranperda;
create policy "ranperda_hapus" on public.ranperda for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "naskahakademik_akses_terautentikasi" on public.naskahakademik;
alter table public.naskahakademik enable row level security;
drop policy if exists "naskahakademik_baca" on public.naskahakademik;
create policy "naskahakademik_baca" on public.naskahakademik for select to authenticated using (arka_baca('naskahakademik'));
drop policy if exists "naskahakademik_tambah" on public.naskahakademik;
create policy "naskahakademik_tambah" on public.naskahakademik for insert to authenticated with check (arka_tulis('naskahakademik'));
drop policy if exists "naskahakademik_ubah" on public.naskahakademik;
create policy "naskahakademik_ubah" on public.naskahakademik for update to authenticated using (arka_tulis('naskahakademik')) with check (arka_tulis('naskahakademik'));
drop policy if exists "naskahakademik_hapus" on public.naskahakademik;
create policy "naskahakademik_hapus" on public.naskahakademik for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "dim_akses_terautentikasi" on public.dim;
alter table public.dim enable row level security;
drop policy if exists "dim_baca" on public.dim;
create policy "dim_baca" on public.dim for select to authenticated using (arka_baca('dim'));
drop policy if exists "dim_tambah" on public.dim;
create policy "dim_tambah" on public.dim for insert to authenticated with check (arka_tulis('dim'));
drop policy if exists "dim_ubah" on public.dim;
create policy "dim_ubah" on public.dim for update to authenticated using (arka_tulis('dim')) with check (arka_tulis('dim'));
drop policy if exists "dim_hapus" on public.dim;
create policy "dim_hapus" on public.dim for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "harmonisasi_akses_terautentikasi" on public.harmonisasi;
alter table public.harmonisasi enable row level security;
drop policy if exists "harmonisasi_baca" on public.harmonisasi;
create policy "harmonisasi_baca" on public.harmonisasi for select to authenticated using (arka_baca('harmonisasi'));
drop policy if exists "harmonisasi_tambah" on public.harmonisasi;
create policy "harmonisasi_tambah" on public.harmonisasi for insert to authenticated with check (arka_tulis('harmonisasi'));
drop policy if exists "harmonisasi_ubah" on public.harmonisasi;
create policy "harmonisasi_ubah" on public.harmonisasi for update to authenticated using (arka_tulis('harmonisasi')) with check (arka_tulis('harmonisasi'));
drop policy if exists "harmonisasi_hapus" on public.harmonisasi;
create policy "harmonisasi_hapus" on public.harmonisasi for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "jdih_akses_terautentikasi" on public.jdih;
alter table public.jdih enable row level security;
drop policy if exists "jdih_baca" on public.jdih;
create policy "jdih_baca" on public.jdih for select to authenticated using (arka_baca('jdih'));
drop policy if exists "jdih_tambah" on public.jdih;
create policy "jdih_tambah" on public.jdih for insert to authenticated with check (arka_tulis('jdih'));
drop policy if exists "jdih_ubah" on public.jdih;
create policy "jdih_ubah" on public.jdih for update to authenticated using (arka_tulis('jdih')) with check (arka_tulis('jdih'));
drop policy if exists "jdih_hapus" on public.jdih;
create policy "jdih_hapus" on public.jdih for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "kua_akses_terautentikasi" on public.kua;
alter table public.kua enable row level security;
drop policy if exists "kua_baca" on public.kua;
create policy "kua_baca" on public.kua for select to authenticated using (arka_baca('kua'));
drop policy if exists "kua_tambah" on public.kua;
create policy "kua_tambah" on public.kua for insert to authenticated with check (arka_tulis('kua'));
drop policy if exists "kua_ubah" on public.kua;
create policy "kua_ubah" on public.kua for update to authenticated using (arka_tulis('kua')) with check (arka_tulis('kua'));
drop policy if exists "kua_hapus" on public.kua;
create policy "kua_hapus" on public.kua for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "ppas_akses_terautentikasi" on public.ppas;
alter table public.ppas enable row level security;
drop policy if exists "ppas_baca" on public.ppas;
create policy "ppas_baca" on public.ppas for select to authenticated using (arka_baca('ppas'));
drop policy if exists "ppas_tambah" on public.ppas;
create policy "ppas_tambah" on public.ppas for insert to authenticated with check (arka_tulis('ppas'));
drop policy if exists "ppas_ubah" on public.ppas;
create policy "ppas_ubah" on public.ppas for update to authenticated using (arka_tulis('ppas')) with check (arka_tulis('ppas'));
drop policy if exists "ppas_hapus" on public.ppas;
create policy "ppas_hapus" on public.ppas for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "apbd_akses_terautentikasi" on public.apbd;
alter table public.apbd enable row level security;
drop policy if exists "apbd_baca" on public.apbd;
create policy "apbd_baca" on public.apbd for select to authenticated using (arka_baca('apbd'));
drop policy if exists "apbd_tambah" on public.apbd;
create policy "apbd_tambah" on public.apbd for insert to authenticated with check (arka_tulis('apbd'));
drop policy if exists "apbd_ubah" on public.apbd;
create policy "apbd_ubah" on public.apbd for update to authenticated using (arka_tulis('apbd')) with check (arka_tulis('apbd'));
drop policy if exists "apbd_hapus" on public.apbd;
create policy "apbd_hapus" on public.apbd for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "apbdp_akses_terautentikasi" on public.apbdp;
alter table public.apbdp enable row level security;
drop policy if exists "apbdp_baca" on public.apbdp;
create policy "apbdp_baca" on public.apbdp for select to authenticated using (arka_baca('apbdp'));
drop policy if exists "apbdp_tambah" on public.apbdp;
create policy "apbdp_tambah" on public.apbdp for insert to authenticated with check (arka_tulis('apbdp'));
drop policy if exists "apbdp_ubah" on public.apbdp;
create policy "apbdp_ubah" on public.apbdp for update to authenticated using (arka_tulis('apbdp')) with check (arka_tulis('apbdp'));
drop policy if exists "apbdp_hapus" on public.apbdp;
create policy "apbdp_hapus" on public.apbdp for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "lapsemester_akses_terautentikasi" on public.lapsemester;
alter table public.lapsemester enable row level security;
drop policy if exists "lapsemester_baca" on public.lapsemester;
create policy "lapsemester_baca" on public.lapsemester for select to authenticated using (arka_baca('lapsemester'));
drop policy if exists "lapsemester_tambah" on public.lapsemester;
create policy "lapsemester_tambah" on public.lapsemester for insert to authenticated with check (arka_tulis('lapsemester'));
drop policy if exists "lapsemester_ubah" on public.lapsemester;
create policy "lapsemester_ubah" on public.lapsemester for update to authenticated using (arka_tulis('lapsemester')) with check (arka_tulis('lapsemester'));
drop policy if exists "lapsemester_hapus" on public.lapsemester;
create policy "lapsemester_hapus" on public.lapsemester for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "pertanggungjawaban_akses_terautentikasi" on public.pertanggungjawaban;
alter table public.pertanggungjawaban enable row level security;
drop policy if exists "pertanggungjawaban_baca" on public.pertanggungjawaban;
create policy "pertanggungjawaban_baca" on public.pertanggungjawaban for select to authenticated using (arka_baca('pertanggungjawaban'));
drop policy if exists "pertanggungjawaban_tambah" on public.pertanggungjawaban;
create policy "pertanggungjawaban_tambah" on public.pertanggungjawaban for insert to authenticated with check (arka_tulis('pertanggungjawaban'));
drop policy if exists "pertanggungjawaban_ubah" on public.pertanggungjawaban;
create policy "pertanggungjawaban_ubah" on public.pertanggungjawaban for update to authenticated using (arka_tulis('pertanggungjawaban')) with check (arka_tulis('pertanggungjawaban'));
drop policy if exists "pertanggungjawaban_hapus" on public.pertanggungjawaban;
create policy "pertanggungjawaban_hapus" on public.pertanggungjawaban for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "monopd_akses_terautentikasi" on public.monopd;
alter table public.monopd enable row level security;
drop policy if exists "monopd_baca" on public.monopd;
create policy "monopd_baca" on public.monopd for select to authenticated using (arka_baca('monopd'));
drop policy if exists "monopd_tambah" on public.monopd;
create policy "monopd_tambah" on public.monopd for insert to authenticated with check (arka_tulis('monopd'));
drop policy if exists "monopd_ubah" on public.monopd;
create policy "monopd_ubah" on public.monopd for update to authenticated using (arka_tulis('monopd')) with check (arka_tulis('monopd'));
drop policy if exists "monopd_hapus" on public.monopd;
create policy "monopd_hapus" on public.monopd for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "monprogram_akses_terautentikasi" on public.monprogram;
alter table public.monprogram enable row level security;
drop policy if exists "monprogram_baca" on public.monprogram;
create policy "monprogram_baca" on public.monprogram for select to authenticated using (arka_baca('monprogram'));
drop policy if exists "monprogram_tambah" on public.monprogram;
create policy "monprogram_tambah" on public.monprogram for insert to authenticated with check (arka_tulis('monprogram'));
drop policy if exists "monprogram_ubah" on public.monprogram;
create policy "monprogram_ubah" on public.monprogram for update to authenticated using (arka_tulis('monprogram')) with check (arka_tulis('monprogram'));
drop policy if exists "monprogram_hapus" on public.monprogram;
create policy "monprogram_hapus" on public.monprogram for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "monproyek_akses_terautentikasi" on public.monproyek;
alter table public.monproyek enable row level security;
drop policy if exists "monproyek_baca" on public.monproyek;
create policy "monproyek_baca" on public.monproyek for select to authenticated using (arka_baca('monproyek'));
drop policy if exists "monproyek_tambah" on public.monproyek;
create policy "monproyek_tambah" on public.monproyek for insert to authenticated with check (arka_tulis('monproyek'));
drop policy if exists "monproyek_ubah" on public.monproyek;
create policy "monproyek_ubah" on public.monproyek for update to authenticated using (arka_tulis('monproyek')) with check (arka_tulis('monproyek'));
drop policy if exists "monproyek_hapus" on public.monproyek;
create policy "monproyek_hapus" on public.monproyek for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "lkpj_akses_terautentikasi" on public.lkpj;
alter table public.lkpj enable row level security;
drop policy if exists "lkpj_baca" on public.lkpj;
create policy "lkpj_baca" on public.lkpj for select to authenticated using (arka_baca('lkpj'));
drop policy if exists "lkpj_tambah" on public.lkpj;
create policy "lkpj_tambah" on public.lkpj for insert to authenticated with check (arka_tulis('lkpj'));
drop policy if exists "lkpj_ubah" on public.lkpj;
create policy "lkpj_ubah" on public.lkpj for update to authenticated using (arka_tulis('lkpj')) with check (arka_tulis('lkpj'));
drop policy if exists "lkpj_hapus" on public.lkpj;
create policy "lkpj_hapus" on public.lkpj for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "temuan_akses_terautentikasi" on public.temuan;
alter table public.temuan enable row level security;
drop policy if exists "temuan_baca" on public.temuan;
create policy "temuan_baca" on public.temuan for select to authenticated using (arka_baca('temuan'));
drop policy if exists "temuan_tambah" on public.temuan;
create policy "temuan_tambah" on public.temuan for insert to authenticated with check (arka_tulis('temuan'));
drop policy if exists "temuan_ubah" on public.temuan;
create policy "temuan_ubah" on public.temuan for update to authenticated using (arka_tulis('temuan')) with check (arka_tulis('temuan'));
drop policy if exists "temuan_hapus" on public.temuan;
create policy "temuan_hapus" on public.temuan for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "rekomendasi_akses_terautentikasi" on public.rekomendasi;
alter table public.rekomendasi enable row level security;
drop policy if exists "rekomendasi_baca" on public.rekomendasi;
create policy "rekomendasi_baca" on public.rekomendasi for select to authenticated using (arka_baca('rekomendasi'));
drop policy if exists "rekomendasi_tambah" on public.rekomendasi;
create policy "rekomendasi_tambah" on public.rekomendasi for insert to authenticated with check (arka_tulis('rekomendasi'));
drop policy if exists "rekomendasi_ubah" on public.rekomendasi;
create policy "rekomendasi_ubah" on public.rekomendasi for update to authenticated using (arka_tulis('rekomendasi')) with check (arka_tulis('rekomendasi'));
drop policy if exists "rekomendasi_hapus" on public.rekomendasi;
create policy "rekomendasi_hapus" on public.rekomendasi for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "tindaklanjut_akses_terautentikasi" on public.tindaklanjut;
alter table public.tindaklanjut enable row level security;
drop policy if exists "tindaklanjut_baca" on public.tindaklanjut;
create policy "tindaklanjut_baca" on public.tindaklanjut for select to authenticated using (arka_baca('tindaklanjut'));
drop policy if exists "tindaklanjut_tambah" on public.tindaklanjut;
create policy "tindaklanjut_tambah" on public.tindaklanjut for insert to authenticated with check (arka_tulis('tindaklanjut'));
drop policy if exists "tindaklanjut_ubah" on public.tindaklanjut;
create policy "tindaklanjut_ubah" on public.tindaklanjut for update to authenticated using (arka_tulis('tindaklanjut')) with check (arka_tulis('tindaklanjut'));
drop policy if exists "tindaklanjut_hapus" on public.tindaklanjut;
create policy "tindaklanjut_hapus" on public.tindaklanjut for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "reses_akses_terautentikasi" on public.reses;
alter table public.reses enable row level security;
drop policy if exists "reses_baca" on public.reses;
create policy "reses_baca" on public.reses for select to authenticated using (arka_baca('reses'));
drop policy if exists "reses_tambah" on public.reses;
create policy "reses_tambah" on public.reses for insert to authenticated with check (arka_tulis('reses'));
drop policy if exists "reses_ubah" on public.reses;
create policy "reses_ubah" on public.reses for update to authenticated using (arka_tulis('reses')) with check (arka_tulis('reses'));
drop policy if exists "reses_hapus" on public.reses;
create policy "reses_hapus" on public.reses for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "pokir_akses_terautentikasi" on public.pokir;
alter table public.pokir enable row level security;
drop policy if exists "pokir_baca" on public.pokir;
create policy "pokir_baca" on public.pokir for select to authenticated using (arka_baca('pokir'));
drop policy if exists "pokir_tambah" on public.pokir;
create policy "pokir_tambah" on public.pokir for insert to authenticated with check (arka_tulis('pokir'));
drop policy if exists "pokir_ubah" on public.pokir;
create policy "pokir_ubah" on public.pokir for update to authenticated using (arka_tulis('pokir')) with check (arka_tulis('pokir'));
drop policy if exists "pokir_hapus" on public.pokir;
create policy "pokir_hapus" on public.pokir for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "hearing_akses_terautentikasi" on public.hearing;
alter table public.hearing enable row level security;
drop policy if exists "hearing_baca" on public.hearing;
create policy "hearing_baca" on public.hearing for select to authenticated using (arka_baca('hearing'));
drop policy if exists "hearing_tambah" on public.hearing;
create policy "hearing_tambah" on public.hearing for insert to authenticated with check (arka_tulis('hearing'));
drop policy if exists "hearing_ubah" on public.hearing;
create policy "hearing_ubah" on public.hearing for update to authenticated using (arka_tulis('hearing')) with check (arka_tulis('hearing'));
drop policy if exists "hearing_hapus" on public.hearing;
create policy "hearing_hapus" on public.hearing for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "audiensi_akses_terautentikasi" on public.audiensi;
alter table public.audiensi enable row level security;
drop policy if exists "audiensi_baca" on public.audiensi;
create policy "audiensi_baca" on public.audiensi for select to authenticated using (arka_baca('audiensi'));
drop policy if exists "audiensi_tambah" on public.audiensi;
create policy "audiensi_tambah" on public.audiensi for insert to authenticated with check (arka_tulis('audiensi'));
drop policy if exists "audiensi_ubah" on public.audiensi;
create policy "audiensi_ubah" on public.audiensi for update to authenticated using (arka_tulis('audiensi')) with check (arka_tulis('audiensi'));
drop policy if exists "audiensi_hapus" on public.audiensi;
create policy "audiensi_hapus" on public.audiensi for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "aspirasidigital_akses_terautentikasi" on public.aspirasidigital;
alter table public.aspirasidigital enable row level security;
drop policy if exists "aspirasidigital_baca" on public.aspirasidigital;
create policy "aspirasidigital_baca" on public.aspirasidigital for select to authenticated using (arka_baca('aspirasidigital'));
drop policy if exists "aspirasidigital_tambah" on public.aspirasidigital;
create policy "aspirasidigital_tambah" on public.aspirasidigital for insert to authenticated with check (arka_tulis('aspirasidigital'));
drop policy if exists "aspirasidigital_ubah" on public.aspirasidigital;
create policy "aspirasidigital_ubah" on public.aspirasidigital for update to authenticated using (arka_tulis('aspirasidigital')) with check (arka_tulis('aspirasidigital'));
drop policy if exists "aspirasidigital_hapus" on public.aspirasidigital;
create policy "aspirasidigital_hapus" on public.aspirasidigital for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "pengaduan_akses_terautentikasi" on public.pengaduan;
alter table public.pengaduan enable row level security;
drop policy if exists "pengaduan_baca" on public.pengaduan;
create policy "pengaduan_baca" on public.pengaduan for select to authenticated using (arka_baca('pengaduan'));
drop policy if exists "pengaduan_tambah" on public.pengaduan;
create policy "pengaduan_tambah" on public.pengaduan for insert to authenticated with check (arka_tulis('pengaduan'));
drop policy if exists "pengaduan_ubah" on public.pengaduan;
create policy "pengaduan_ubah" on public.pengaduan for update to authenticated using (arka_tulis('pengaduan')) with check (arka_tulis('pengaduan'));
drop policy if exists "pengaduan_hapus" on public.pengaduan;
create policy "pengaduan_hapus" on public.pengaduan for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "berita_akses_terautentikasi" on public.berita;
alter table public.berita enable row level security;
drop policy if exists "berita_baca" on public.berita;
create policy "berita_baca" on public.berita for select to authenticated using (arka_baca('berita'));
drop policy if exists "berita_tambah" on public.berita;
create policy "berita_tambah" on public.berita for insert to authenticated with check (arka_tulis('berita'));
drop policy if exists "berita_ubah" on public.berita;
create policy "berita_ubah" on public.berita for update to authenticated using (arka_tulis('berita')) with check (arka_tulis('berita'));
drop policy if exists "berita_hapus" on public.berita;
create policy "berita_hapus" on public.berita for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "publikasi_akses_terautentikasi" on public.publikasi;
alter table public.publikasi enable row level security;
drop policy if exists "publikasi_baca" on public.publikasi;
create policy "publikasi_baca" on public.publikasi for select to authenticated using (arka_baca('publikasi'));
drop policy if exists "publikasi_tambah" on public.publikasi;
create policy "publikasi_tambah" on public.publikasi for insert to authenticated with check (arka_tulis('publikasi'));
drop policy if exists "publikasi_ubah" on public.publikasi;
create policy "publikasi_ubah" on public.publikasi for update to authenticated using (arka_tulis('publikasi')) with check (arka_tulis('publikasi'));
drop policy if exists "publikasi_hapus" on public.publikasi;
create policy "publikasi_hapus" on public.publikasi for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "dokumentasi_akses_terautentikasi" on public.dokumentasi;
alter table public.dokumentasi enable row level security;
drop policy if exists "dokumentasi_baca" on public.dokumentasi;
create policy "dokumentasi_baca" on public.dokumentasi for select to authenticated using (arka_baca('dokumentasi'));
drop policy if exists "dokumentasi_tambah" on public.dokumentasi;
create policy "dokumentasi_tambah" on public.dokumentasi for insert to authenticated with check (arka_tulis('dokumentasi'));
drop policy if exists "dokumentasi_ubah" on public.dokumentasi;
create policy "dokumentasi_ubah" on public.dokumentasi for update to authenticated using (arka_tulis('dokumentasi')) with check (arka_tulis('dokumentasi'));
drop policy if exists "dokumentasi_hapus" on public.dokumentasi;
create policy "dokumentasi_hapus" on public.dokumentasi for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "mediamon_akses_terautentikasi" on public.mediamon;
alter table public.mediamon enable row level security;
drop policy if exists "mediamon_baca" on public.mediamon;
create policy "mediamon_baca" on public.mediamon for select to authenticated using (arka_baca('mediamon'));
drop policy if exists "mediamon_tambah" on public.mediamon;
create policy "mediamon_tambah" on public.mediamon for insert to authenticated with check (arka_tulis('mediamon'));
drop policy if exists "mediamon_ubah" on public.mediamon;
create policy "mediamon_ubah" on public.mediamon for update to authenticated using (arka_tulis('mediamon')) with check (arka_tulis('mediamon'));
drop policy if exists "mediamon_hapus" on public.mediamon;
create policy "mediamon_hapus" on public.mediamon for delete to authenticated using (arka_peran() = 'admin');

drop policy if exists "protokoler_akses_terautentikasi" on public.protokoler;
alter table public.protokoler enable row level security;
drop policy if exists "protokoler_baca" on public.protokoler;
create policy "protokoler_baca" on public.protokoler for select to authenticated using (arka_baca('protokoler'));
drop policy if exists "protokoler_tambah" on public.protokoler;
create policy "protokoler_tambah" on public.protokoler for insert to authenticated with check (arka_tulis('protokoler'));
drop policy if exists "protokoler_ubah" on public.protokoler;
create policy "protokoler_ubah" on public.protokoler for update to authenticated using (arka_tulis('protokoler')) with check (arka_tulis('protokoler'));
drop policy if exists "protokoler_hapus" on public.protokoler;
create policy "protokoler_hapus" on public.protokoler for delete to authenticated using (arka_peran() = 'admin');

