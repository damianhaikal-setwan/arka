-- ARKA: dukungan administrasi pengguna melalui Supabase Edge Function.
-- Jalankan di Supabase SQL Editor setelah skema utama ARKA.
-- Operasi Auth admin (invite/update/delete akun) TIDAK dilakukan di SQL/HTML;
-- operasi tersebut dijalankan oleh Edge Function arka-users-admin memakai service-role secret.

-- Profil pengguna hanya bisa dibaca oleh pemiliknya lewat client biasa.
-- Edge Function berjalan dengan service role dan memvalidasi bahwa pemanggil adalah admin.
alter table public.profiles enable row level security;
drop policy if exists "profiles_baca_sendiri" on public.profiles;
create policy "profiles_baca_sendiri"
  on public.profiles for select to authenticated
  using (id = auth.uid());

-- Pastikan kebijakan tidak memberi client biasa hak mengubah profil/hak akses.
-- Kebijakan bernama umum yang mungkin ada di instalasi lama dibuang secara eksplisit.
drop policy if exists "profiles_tambah" on public.profiles;
drop policy if exists "profiles_ubah" on public.profiles;
drop policy if exists "profiles_hapus" on public.profiles;
drop policy if exists "profiles_admin_manage" on public.profiles;

-- Validasi peran/unit yang selaras dengan ARKA.
do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'profiles_peran_arka_chk' and conrelid = 'public.profiles'::regclass) then
    alter table public.profiles add constraint profiles_peran_arka_chk
      check (peran in ('admin','pengelola','pimpinan'));
  end if;
  if not exists (select 1 from pg_constraint where conname = 'profiles_unit_arka_chk' and conrelid = 'public.profiles'::regclass) then
    alter table public.profiles add constraint profiles_unit_arka_chk
      check (unit is null or unit in ('umum_keuangan','persidangan','fasilitasi'));
  end if;
  if not exists (select 1 from pg_constraint where conname = 'profiles_unit_wajib_arka_chk' and conrelid = 'public.profiles'::regclass) then
    alter table public.profiles add constraint profiles_unit_wajib_arka_chk
      check (peran <> 'pengelola' or unit is not null);
  end if;
end $$;

-- Indeks untuk pemeriksaan jumlah admin dan pencarian profil berdasarkan peran.
create index if not exists profiles_peran_idx on public.profiles(peran);

-- Catatan:
-- 1) Deploy supabase/functions/arka-users-admin/index.ts sebagai Edge Function.
-- 2) Set secrets SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY.
-- 3) Jangan pernah masukkan SERVICE_ROLE_KEY ke berkas HTML atau browser.
-- 4) Atur ARKA_INVITE_REDIRECT_URL ke URL halaman aplikasi yang menerima link undangan,
--    dan pastikan URL itu masuk ke daftar Redirect URLs di Authentication settings.
