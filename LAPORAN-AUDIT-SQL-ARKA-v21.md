# ARKA — Audit seluruh berkas SQL dan Edge Function
Tanggal pemeriksaan: 23 Oktober 2026

## Inventaris
- `arka_schema.sql`: 2.144 baris, 84 tabel didefinisikan, 84 tabel mendapat `ENABLE ROW LEVEL SECURITY`, sekitar 330 policy dibuat.
- `arka schema.sql`: identik byte-per-byte dengan `arka_schema.sql` (SHA-256 sama: `8d036f885ca02a928e7302cad3c3678ac73ba03332c7e07c8613b2503a7eb9fe`).
- `arka_migrasi_unit.sql`: migrasi peran/unit dan normalisasi label unit pada data yang sudah ada.
- `arka seed.sql`: data contoh fiktif, harus dijalankan hanya pada database pengujian dan satu kali.
- `ARKA_Migrasi_Keanggotaan_AKD_v13(1).sql`: tabel relasi AKD, FK ke `alat`/`anggota`, unique `(alat, anggota)`, RLS empat aksi.
- `arka_pengguna_hak_akses_migration.sql`: membatasi policy `profiles` dengan daftar nama policy tertentu dan menambah constraint.
- `index(1).ts`: Edge Function admin pengguna.

## Temuan prioritas

### P1 — Audit log dapat dipalsukan oleh klien
**Lokasi:** `arka_schema.sql` bagian keamanan RLS, baris 1259–1262 (policy `audit_log_baca` dan `audit_log_tambah`); `index(1).ts` baris 91–96.
- Policy mengizinkan pengguna terautentikasi dengan profil apa pun menulis ke `audit_log`.
- Nilai `aksi`, `modul`, `ref`, dan `user_name` berasal dari klien; user_name bukan identitas tepercaya.
- Edge Function `audit()` juga hanya menulis error ke console dan tetap melanjutkan respons sukses.
**Risiko:** catatan audit palsu atau hilang tanpa kegagalan yang diketahui pemanggil.
**Perbaikan:** migrasi v21 menambah metadata pelaku dan snapshot baris, mengunci tulis audit langsung dari klien, dan mencatat INSERT/UPDATE/DELETE melalui trigger database dalam transaksi yang sama. Perubahan profil/admin tetap perlu Edge Function; kegagalan audit di sana belum atomik terhadap operasi Supabase Auth.

### P1 — CRUD bisnis dan audit bukan transaksi yang sama
**Lokasi:** `index.html` fungsi `arkaWrite`/alur hapus; schema audit lama hanya mencatat INSERT dari aplikasi.
- Sebelum patch, aplikasi menulis record lalu menulis audit sebagai permintaan kedua.
- Kegagalan audit dapat terjadi setelah record tersimpan.
**Perbaikan:** paket v21 menghapus insert audit manual untuk CRUD bisnis dan bergantung pada trigger database. SQL v21 wajib diterapkan sebelum aplikasi v21; jika hanya aplikasi yang dideploy tanpa migrasi, CRUD tidak menghasilkan audit otomatis.

### P1 — Kebijakan `profiles` berpotensi mewarisi policy lama yang tidak dikenal
**Lokasi:** `arka_pengguna_hak_akses_migration.sql` baris 14–19; `arka_schema.sql` baris 33–35.
- Migrasi hanya menghapus empat nama policy yang diketahui. PostgreSQL menggabungkan policy permissive dengan OR, sehingga policy lama dengan nama lain bisa memperluas akses.
**Perbaikan:** migrasi v21 menghapus seluruh policy yang ada pada `profiles`, lalu membangun ulang policy SELECT pemilik sendiri dan mencabut DML dari role klien. Edge Function service_role tetap menjadi jalur administrasi pengguna.

### P2 — Hak hapus lampiran berbeda dari aturan hapus modul
**Lokasi:** `arka_schema.sql` bagian `lampiran` dan `storage.objects`.
- Tabel modul utama mensyaratkan `arka_peran() = 'admin'` untuk DELETE.
- Metadata lampiran dan objek Storage mengizinkan DELETE bagi pengelola yang memiliki hak tulis modul (`arka_tulis`).
**Risiko:** pengelola unit dapat menghapus bukti/lampiran meski tidak memiliki hak hapus record modul. Ini mungkin desain yang disengaja, tetapi perlu keputusan eksplisit.
**Tindakan:** belum diubah otomatis karena perubahan ini bisa menghambat alur pengelolaan lampiran. Tetapkan apakah penghapusan lampiran mengikuti hak tulis modul atau admin saja.

### P2 — Pembacaan audit hanya admin
**Lokasi:** `arka_schema.sql` policy `audit_log_baca`; aplikasi v20 `arkaLoadAudit()`.
- Policy database hanya memperbolehkan admin membaca audit, sementara aplikasi memanggilnya untuk semua peran.
**Perbaikan:** aplikasi v21 hanya memuat riwayat server untuk admin dan mengosongkan daftar audit lokal untuk pengguna non-admin.

### P2 — Operasi hapus dapat mengosongkan relasi dalam beberapa transaksi
**Lokasi:** `index.html` alur penghapusan yang memproses `refs` sebelum menghapus record induk.
- Perubahan referensi dilakukan satu per satu sebelum DELETE utama. Jika langkah berikutnya gagal dan rollback kompensasi juga gagal, data dapat tertinggal sebagian.
**Tindakan:** belum ditransformasikan menjadi RPC dinamis tanpa uji skema dan semua relasi. Perlu daftar relasi final lalu satu fungsi transaksi server.

### P2 — Keanggotaan AKD
**Lokasi:** `ARKA_Migrasi_Keanggotaan_AKD_v13(1).sql` baris 11–21 dan 27–77.
- Struktur relasi dan unique `(alat, anggota)` sudah mencegah duplikasi pasangan dan FK memakai `ON DELETE RESTRICT`.
- RLS memberi hak tulis kepada admin/pengelola `persidangan`, dan baca kepada tiga peran yang terdaftar.
**Tindakan:** pertahankan. Uji bahwa `profiles.id` benar-benar sama dengan `auth.uid()` dan bahwa nama peran/unit sesuai data produksi.

### P3 — Seed dan urutan migrasi
- `arka seed.sql` berisi data contoh fiktif; jangan jalankan pada produksi.
- `arka_migrasi_unit.sql` memerlukan unit profil pengelola diisi sebelum skema dijalankan ulang, sesuai komentar file; lakukan backup karena migrasi mengubah label unit di banyak tabel.
- `arka_schema.sql` dan `arka schema.sql` duplikat; pilih satu sumber kanonis untuk menghindari versi drift.
- Migrasi keanggotaan AKD perlu dijalankan setelah tabel `alat` dan `anggota` ada.

## Perubahan file yang disertakan
- `arka_audit_security_migration_v21.sql`: migrasi usulan untuk audit atomik, penguncian audit log, dan pembatasan DML profil.
- `index.html`: CRUD bisnis tidak lagi menyisipkan audit manual; aplikasi mengandalkan trigger database dan hanya admin yang memuat audit server.
- `README-PWA.md`, `manifest.webmanifest`, `sw.js`, ikon: dipertahankan dari paket v20.

## Batas bukti
Tidak ada koneksi langsung ke database Supabase produksi pada pemeriksaan ini. SQL v21 belum dijalankan terhadap database. Wajib backup, staging, dan uji negatif sebelum produksi. Migrasi trigger ini mencatat snapshot JSON baris; karena dapat berisi data personal (misalnya NIP), akses audit dibatasi admin dan retensi harus ditetapkan.
