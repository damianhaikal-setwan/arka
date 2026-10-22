# ARKA – Arsitektur Rekam Kinerja dan Administrasi DPRD

Aplikasi web satu halaman untuk Sekretariat DPRD Kabupaten Kapuas Hulu.
Berjalan sebagai situs statis (HTML, CSS, dan JavaScript tanpa framework), dengan data di Supabase.

## Struktur repositori

```
arka/
├── index.html            ← aplikasi (salinan ARKA.html, diberi nama index.html)
├── KAMUS_DATA.md         ← kamus data: tabel, kolom, relasi, peran akses
├── README.md             ← panduan ini
├── .gitignore
└── supabase/
    ├── arka_schema.sql   ← tabel, peran, RLS, bucket lampiran
    └── arka_seed.sql     ← data contoh (fiktif), opsional
```

Cloudflare Pages menyajikan `index.html` sebagai halaman utama. Jika memakai nama lain, alamat akan memuat `/ARKA.html`.

## Dua mode

| Mode | Syarat | Kegunaan |
|---|---|---|
| **Lokal** | `SUPABASE_URL` dan `SUPABASE_ANON_KEY` di `index.html` dibiarkan kosong | Uji tampilan, Daftar Uji, dan demo. Tanpa login. Data hilang saat halaman dimuat ulang. |
| **Cloud** | Kedua konstanta diisi dengan URL dan anon key proyek Supabase | Penggunaan sebenarnya. Wajib login dan memiliki baris di tabel `profiles`. |

Anon key boleh berada di HTML karena sifatnya publik. Keamanan data bergantung pada RLS, bukan pada kerahasiaan key ini.
**Jangan pernah memasukkan `service_role` key ke repositori.**

## Menjalankan di komputer

Dari folder repositori:

```
python3 -m http.server 8080
```

Buka `http://localhost:8080/index.html`.

Untuk membuka dari iPhone di Wi-Fi yang sama, gunakan `http://IP-komputer:8080/index.html`. Pastikan firewall mengizinkan koneksi masuk.

Aplikasi memerlukan internet untuk memuat pustaka dari CDN (supabase-js dan three.js).

## Menyiapkan Supabase (sekali, di proyek staging dulu)

1. Buat proyek di Supabase.
2. Di SQL Editor, jalankan `supabase/arka_schema.sql`.
3. Buat akun di **Authentication > Users**.
4. Tambahkan profil peran untuk setiap akun:
   ```sql
   insert into public.profiles (id, nama, peran)
   select id, 'Nama Lengkap', 'operator' from auth.users where email = 'nama@dprd.go.id';
   ```
   Peran yang tersedia: `admin`, `operator`, `pimpinan`.
5. Opsional, untuk data contoh: jalankan `supabase/arka_seed.sql` **sekali saja**. Berkas ini memakai INSERT biasa, sehingga menjalankannya dua kali akan gagal karena ID sudah ada.
6. Isi `SUPABASE_URL` dan `SUPABASE_ANON_KEY` di `index.html`.
7. Di **Authentication > Providers > Email**, matikan pendaftaran mandiri.
8. Di **Authentication > URL Configuration**, isi Site URL dengan alamat aplikasi.

## Hak akses

| Peran | Baca | Tambah dan ubah | Hapus |
|---|---|---|---|
| admin | semua | semua | semua |
| operator | semua | semua | tidak |
| pimpinan | semua, kecuali `bk` dan `pengaduan` | tidak | tidak |

Tabel `bk` (Badan Kehormatan) dan `pengaduan` hanya dapat dibaca admin dan operator.

## Sebelum deploy

Lakukan urutan ini setiap kali ada perubahan besar:

1. **Pemeriksaan Sistem** (admin): semua baris harus OK. Pastikan tidak ada status Gagal.
2. **Sidik struktur**: bandingkan kode di menu Pemeriksaan Sistem dengan sidik di `KAMUS_DATA.md`.
   - Jika berbeda, klik **Kamus Data (.md)** di menu Pemeriksaan Sistem, lalu ganti `KAMUS_DATA.md`.
3. **Daftar Uji**: jalankan skenario penting di setiap grup, lalu unduh hasilnya sebagai CSV sebagai catatan.
4. **Uji di iPhone** lewat Safari, bukan aplikasi preview. Aplikasi preview biasanya tidak menjalankan JavaScript.
5. Jika skema SQL berubah, jalankan `arka_schema.sql` lagi. Berkas ini aman dijalankan ulang untuk tabel dan kebijakan.

## Deploy ke Cloudflare Pages

1. Hubungkan repositori GitHub ke Cloudflare Pages.
2. Build command dikosongkan. Output directory diisi `/`.
3. Deploy pertama ke branch `staging` untuk mendapatkan URL pratinjau. Uji di sana, lalu gabungkan ke branch utama.
4. Tambahkan URL pratinjau ke daftar Redirect URLs di Supabase.
5. Pertimbangkan Cloudflare Access untuk membatasi halaman ke alamat email kantor.

Setiap push ke branch akan memicu deploy otomatis. Karena itu, perubahan `index.html`, `KAMUS_DATA.md`, dan skema SQL sebaiknya dikomit bersamaan.

## Mengubah struktur data

Setiap perubahan `MENU` atau `FIELDS` di `index.html` harus diikuti:
1. Perbarui `supabase/arka_schema.sql`, lalu jalankan di Supabase.
2. Buat ulang `KAMUS_DATA.md` dari menu Pemeriksaan Sistem.
3. Perbarui sidik di catatan rilis jika ada.

## Catatan keamanan

- Jangan commit berkas berisi password, `service_role` key, atau data pribadi asli pegawai.
- Data contoh bersifat fiktif. Ganti dengan data resmi sebelum digunakan.
- Berkas lampiran tersimpan di bucket privat `arka-lampiran`. Akses dibatasi oleh peran.
- Mode lokal tidak menyimpan data secara permanen. Gunakan tombol cadangan JSON bila perlu.
