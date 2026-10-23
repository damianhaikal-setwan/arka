-- ARKA v21: audit trail atomik untuk perubahan record bisnis.
-- PRASYARAT:
--   1. Jalankan arka_schema.sql terlebih dahulu.
--   2. Jalankan ARKA_Migrasi_Keanggotaan_AKD_v13(1).sql jika tabel keanggotaan_akd dipakai.
--   3. Uji di staging dan backup sebelum produksi.
-- Dampak: setelah migrasi, aplikasi klien tidak lagi boleh INSERT langsung ke audit_log.
-- Deploy index.html v21 bersamaan/setelah migrasi ini. Jangan deploy salah satunya saja.

begin;

alter table public.audit_log
  add column if not exists user_id uuid,
  add column if not exists old_data jsonb,
  add column if not exists new_data jsonb,
  add column if not exists sumber text not null default 'legacy_client';

-- Audit log tidak boleh dimanipulasi oleh klien. SELECT tetap hanya admin.
do $$
declare p record;
begin
  for p in
    select policyname from pg_policies
    where schemaname = 'public' and tablename = 'audit_log'
  loop
    execute format('drop policy if exists %I on public.audit_log', p.policyname);
  end loop;
end $$;

alter table public.audit_log enable row level security;
create policy audit_log_baca
  on public.audit_log for select to authenticated
  using (public.arka_peran() = 'admin');

revoke all on table public.audit_log from public, anon, authenticated;
grant select on table public.audit_log to authenticated;
grant select, insert on table public.audit_log to service_role;

-- Profil hanya dapat dibaca pemiliknya dari klien.
-- Perubahan peran/profil dilakukan melalui Edge Function admin.
do $$
declare p record;
begin
  for p in
    select policyname from pg_policies
    where schemaname = 'public' and tablename = 'profiles'
  loop
    execute format('drop policy if exists %I on public.profiles', p.policyname);
  end loop;
end $$;

alter table public.profiles enable row level security;
create policy profiles_baca_sendiri
  on public.profiles for select to authenticated
  using (id = auth.uid());

revoke insert, update, delete, truncate on table public.profiles from public, anon, authenticated;
grant select on table public.profiles to authenticated;
grant select, insert, update, delete on table public.profiles to service_role;

-- Trigger ini berjalan di transaksi yang sama dengan INSERT/UPDATE/DELETE.
-- Jika audit gagal, perubahan record bisnis ikut gagal/rollback.
create or replace function public.arka_audit_row_change()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_actor uuid;
  v_actor_name text;
  v_email text;
  v_old jsonb;
  v_new jsonb;
  v_ref text;
  v_action text;
begin
  v_actor := auth.uid();
  v_email := nullif(current_setting('request.jwt.claim.email', true), '');

  if TG_OP = 'INSERT' then
    v_action := 'TAMBAH';
    v_new := to_jsonb(NEW);
    v_old := null;
  elsif TG_OP = 'UPDATE' then
    if to_jsonb(NEW) is not distinct from to_jsonb(OLD) then
      return NEW;
    end if;
    v_action := 'UBAH';
    v_old := to_jsonb(OLD);
    v_new := to_jsonb(NEW);
  elsif TG_OP = 'DELETE' then
    v_action := 'HAPUS';
    v_old := to_jsonb(OLD);
    v_new := null;
  else
    return null;
  end if;

  if v_actor is not null then
    select nullif(btrim(p.nama), '')
      into v_actor_name
      from public.profiles p
      where p.id = v_actor;
  end if;

  v_ref := coalesce(
    v_new->>'nama', v_new->>'kode', v_new->>'nip', v_new->>'id',
    v_old->>'nama', v_old->>'kode', v_old->>'nip', v_old->>'id'
  );

  insert into public.audit_log
    (waktu, aksi, modul, ref, user_name, user_id, old_data, new_data, sumber)
  values
    (clock_timestamp(), v_action, TG_TABLE_NAME, v_ref,
     coalesce(v_actor_name, v_email, v_actor::text, 'konteks sistem'),
     v_actor, v_old, v_new, 'database_trigger');

  if TG_OP = 'DELETE' then
    return OLD;
  end if;
  return NEW;
end;
$$;

-- Pasang trigger pada semua tabel modul yang terdaftar, plus lampiran dan keanggotaan AKD.
do $$
declare v_table text;
begin
  for v_table in
    select t.table_name
    from information_schema.tables t
    where t.table_schema = 'public'
      and t.table_type = 'BASE TABLE'
      and t.table_name in (
        select ma.tabel from public.modul_akses ma
        union select 'lampiran'
        union select 'keanggotaan_akd'
      )
  loop
    execute format('drop trigger if exists arka_audit_row_change on public.%I', v_table);
    execute format(
      'create trigger arka_audit_row_change after insert or update or delete on public.%I for each row execute function public.arka_audit_row_change()',
      v_table
    );
  end loop;
end $$;

-- Tidak memberi hak tulis audit kepada pengguna aplikasi.
-- Trigger SECURITY DEFINER menulis sebagai pemilik fungsi; Edge Function service_role
-- tetap dapat menulis audit tindakan administrasi pengguna.
revoke all on function public.arka_audit_row_change() from public, anon, authenticated;

commit;

-- VERIFIKASI SETELAH MIGRASI:
-- select tablename, policyname, cmd, qual, with_check
-- from pg_policies
-- where schemaname='public' and tablename in ('audit_log','profiles')
-- order by tablename, policyname;
--
-- select event_object_table, trigger_name
-- from information_schema.triggers
-- where trigger_schema='public' and trigger_name='arka_audit_row_change'
-- order by event_object_table;
--
-- Uji staging: insert/update/delete satu record uji dengan akun authenticated,
-- pastikan audit_log memiliki aksi/modul/ref/user_id/old_data/new_data,
-- lalu pastikan pengguna non-admin tidak dapat SELECT atau INSERT audit_log.
