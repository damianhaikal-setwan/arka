# Kamus Data ARKA

- **Sidik struktur:** `48f658ec`
- **Dibuat:** 2026-10-22 dari ARKA.html
- **Tabel modul:** 80, ditambah `audit_log`, `profiles`, dan `lampiran`
- **Baris contoh saat dibuat:** 208

## Cara memperbarui
- Bandingkan sidik struktur di atas dengan sidik yang tampil di menu Pemeriksaan Sistem pada ARKA.html.
- Jika sidiknya berbeda, struktur sudah berubah. Buat ulang berkas ini dengan tombol "Kamus Data (.md)" di menu Pemeriksaan Sistem.
- Setiap perubahan MENU atau FIELDS di ARKA.html wajib diikuti pembaruan berkas ini.
- Setiap tabel modul juga memiliki kolom `id` (teks), `dibuat`, dan `diubah` (tanggal).

## Peran dan akses
| Peran | Baca | Tambah dan ubah | Hapus |
|---|---|---|---|
| admin | semua | semua | semua |
| pengelola (per unit) | semua, kecuali modul yang dibatasi (lihat Pembagian unit) | hanya modul unitnya | tidak |
| pimpinan (Sekretaris Dewan) | semua | tidak | tidak |

Pengelola hanya dapat membaca modul `bk` dari unit Fasilitasi dan `pengaduan` dari unit Umum dan Keuangan, selain admin dan pimpinan.

## Tabel sistem
| Tabel | Fungsi |
|---|---|
| `audit_log` | jejak perubahan (aksi, modul, referensi, pengguna, waktu) |
| `profiles` | peran pengguna (id, nama, peran) |
| `lampiran` | catatan berkas; berkas tersimpan di bucket `arka-lampiran` |
| `modul_akses` | pemetaan modul ke unit pengelola dan pembatasan baca |

## Pembagian unit (Perbup Kapuas Hulu Nomor 57 Tahun 2021)
- **Bagian Umum dan Keuangan:** Pegawai, Anggota DPRD, Fraksi, Tenaga Ahli, Program, Kegiatan, Sub Kegiatan, Sasaran, IKU, IKI, RPJMD, Renstra, Renja, Cascading, Pohon Kinerja, Perjanjian Kinerja, Rencana Aksi, IKU (Kinerja), IKI (Kinerja), Monitoring, Evaluasi, Persuratan, Arsip, Perjalanan Dinas, Kepegawaian, Rumah Tangga, Kendaraan, Anggaran, SPJ, Perencanaan, Inventaris, Pemeliharaan, Mutasi, Penghapusan, Rekonsiliasi, Pengaduan
- **Bagian Persidangan dan Perundang-undangan:** Komisi, Alat Kelengkapan DPRD, Regulasi, Agenda, Jadwal, Rapat, Komisi, Bapemperda, Paripurna, Risalah, Notulen, Keputusan, Propemperda, Ranperda, Naskah Akademik, DIM, Harmonisasi, JDIH DPRD, Hearing, Audiensi, Berita, Publikasi, Dokumentasi, Media Monitoring, Protokoler
- **Bagian Fasilitasi Penganggaran dan Pengawasan:** Mitra Kerja, Badan Anggaran, Badan Kehormatan, KUA, PPAS, APBD, APBDP, Laporan Semester, Pertanggungjawaban, Monitoring OPD, Monitoring Program, Monitoring Proyek, LKPJ, Temuan, Rekomendasi, Tindak Lanjut, Reses, Pokir, Aspirasi Digital

## Halaman tanpa tabel
Dashboard Eksekutif, Panduan Input, Pemeriksaan Sistem, Daftar Uji, Evidence Center, dan seluruh Analytics Center membaca data dari tabel modul dan tidak memiliki tabel sendiri.

## Daftar menu dan tabel
### Master Data

#### Pegawai (tabel `pegawai`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** IKI, Perjalanan Dinas, Kepegawaian
- **Baris saat dibuat:** 5

| Kolom | Nama di database | Jenis |
|---|---|---|
| NIP | `nip` | teks |
| Nama | `nama` | teks |
| Jabatan | `jabatan` | teks |
| Unit Kerja | `unit` | teks |
| Golongan | `golongan` | teks |
| Status | `status` | pilihan: Aktif, Cuti, Pensiun |

#### Anggota DPRD (tabel `anggota`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** Badan Kehormatan, Reses, Pokir, Audiensi
- **Baris saat dibuat:** 5

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nama | `nama` | teks |
| Fraksi | `fraksi` | teks |
| Komisi | `komisi` | teks |
| Daerah Pemilihan | `dapil` | teks |
| Jabatan | `jabatan` | teks |
| Status | `status` | pilihan: Aktif, Antar Waktu, Nonaktif |

#### Komisi (tabel `komisi`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** Tenaga Ahli, Mitra Kerja, Rapat, Komisi, Hearing
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Nama Komisi | `nama` | teks |
| Ketua | `ketua` | teks |
| Mitra Kerja Utama | `mitra` | teks |
| Jumlah Anggota | `jumlah` | angka |
| Status | `status` | pilihan: Aktif, Nonaktif |

#### Fraksi (tabel `fraksi`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Nama Fraksi | `nama` | teks |
| Ketua | `ketua` | teks |
| Jumlah Anggota | `jumlah` | angka |
| Status | `status` | pilihan: Aktif, Nonaktif |

#### Alat Kelengkapan DPRD (tabel `alat`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Alat Kelengkapan | `nama` | teks |
| Jenis | `jenis` | pilihan: Badan, Panitia, Kelompok Kerja |
| Ketua | `ketua` | teks |
| Anggota | `jumlah` | angka |
| Status | `status` | pilihan: Aktif, Nonaktif |

#### Tenaga Ahli (tabel `tenaga`)

- **Membutuhkan:** Komisi
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nama | `nama` | teks |
| Keahlian | `keahlian` | teks |
| Komisi Dampingan | `komisi` | relasi ke `komisi` |
| Nomor Kontrak | `kontrak` | teks |
| Status | `status` | pilihan: Aktif, Berakhir |

#### Mitra Kerja (tabel `mitra`)

- **Membutuhkan:** Komisi
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Mitra Kerja | `nama` | teks |
| Jenis | `jenis` | pilihan: OPD, BUMD, Vertikal, Lainnya |
| Komisi | `komisi` | relasi ke `komisi` |
| Kontak | `kontak` | teks |
| Status | `status` | pilihan: Aktif, Nonaktif |

#### Program (tabel `program`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** Kegiatan, Monitoring Program
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode Program | `kode` | teks |
| Nama Program | `nama` | teks |
| Unit Penanggung Jawab | `unit` | teks |
| Pagu (Rp) | `pagu` | angka |
| Realisasi (Rp) | `realisasi` | angka |
| Status | `status` | pilihan: Berjalan, Selesai, Terlambat |

#### Kegiatan (tabel `kegiatan`)

- **Membutuhkan:** Program
- **Dipakai oleh:** Sub Kegiatan, Monitoring Proyek
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Nama Kegiatan | `nama` | teks |
| Program Induk | `program` | relasi ke `program` |
| Pagu (Rp) | `pagu` | angka |
| Realisasi (Rp) | `realisasi` | angka |
| Status | `status` | pilihan: Berjalan, Selesai, Terlambat |

#### Sub Kegiatan (tabel `subkegiatan`)

- **Membutuhkan:** Kegiatan
- **Dipakai oleh:** Anggaran
- **Baris saat dibuat:** 3

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Sub Kegiatan | `nama` | teks |
| Kegiatan Induk | `kegiatan` | relasi ke `kegiatan` |
| Pagu (Rp) | `pagu` | angka |
| Status | `status` | pilihan: Draft, Berjalan, Selesai |

#### Sasaran (tabel `sasaran`)

- **Membutuhkan:** IKU
- **Dipakai oleh:** Cascading, Rencana Aksi, Monitoring
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Sasaran | `nama` | teks |
| Unit | `unit` | teks |
| IKU Terkait | `iku` | relasi ke `iku` |
| Status | `status` | pilihan: Berjalan, Tercapai, Tertunda |

#### IKU (tabel `iku`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** Sasaran, IKU (Kinerja)
- **Baris saat dibuat:** 5

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode IKU | `kode` | teks |
| Indikator | `nama` | teks |
| Unit | `unit` | teks |
| Target | `target` | angka |
| Realisasi | `capaian` | angka |
| Satuan | `satuan` | teks |
| Status | `status` | pilihan: Tercapai, Proses, Tertunda |

#### IKI (tabel `iki`)

- **Membutuhkan:** Pegawai
- **Dipakai oleh:** IKI (Kinerja)
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode IKI | `kode` | teks |
| Indikator Individu | `nama` | teks |
| Pegawai | `pegawai` | relasi ke `pegawai` |
| Target | `target` | angka |
| Realisasi | `capaian` | angka |
| Status | `status` | pilihan: Tercapai, Proses, Tertunda |

#### Regulasi (tabel `regulasi`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** JDIH DPRD
- **Baris saat dibuat:** 7

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor | `kode` | teks |
| Judul | `nama` | teks |
| Jenis | `jenis` | pilihan: Perda, Perbup, PP, Perpres, Permen, Tatib |
| Status | `status` | pilihan: Berlaku, Revisi, Dicabut |

### Renstra & Kinerja

#### RPJMD (tabel `rpjmd`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Dokumen | `nama` | teks |
| Periode | `periode` | teks |
| Status | `status` | pilihan: Berjalan, Selesai, Revisi |

#### Renstra (tabel `renstra`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Dokumen Renstra | `nama` | teks |
| Unit | `unit` | teks |
| Periode | `periode` | teks |
| Status | `status` | pilihan: Draft, Berjalan, Selesai |

#### Renja (tabel `renja`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Dokumen Renja | `nama` | teks |
| Tahun | `tahun` | angka |
| Pagu (Rp) | `pagu` | angka |
| Status | `status` | pilihan: Draft, Berjalan, Selesai |

#### Cascading (tabel `cascading`)

- **Membutuhkan:** Sasaran
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 3

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Keterkaitan | `nama` | teks |
| Level | `level` | pilihan: Bupati / RPJMD, Sekda, Sekretariat, Bagian, Sub Bagian |
| Sasaran Sumber | `sumber` | relasi ke `sasaran` |
| Sasaran Tujuan | `tujuan` | relasi ke `sasaran` |
| Status | `status` | pilihan: Draft, Berjalan, Selesai |

#### Pohon Kinerja (tabel `pohon`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 7

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Node Kinerja | `nama` | teks |
| Level | `level` | pilihan: Sasaran Strategis, Sasaran Kegiatan, Sasaran Program, Indikator |
| Induk | `induk` | relasi ke `pohon` |
| Status | `status` | pilihan: Draft, Berjalan, Selesai |

#### Perjanjian Kinerja (tabel `perjanjian`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor | `kode` | teks |
| Perjanjian Kinerja | `nama` | teks |
| Pejabat | `pejabat` | teks |
| Tahun | `tahun` | angka |
| Status | `status` | pilihan: Draft, Berjalan, Selesai |

#### Rencana Aksi (tabel `rencanaaksi`)

- **Membutuhkan:** Sasaran
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 3

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Rencana Aksi | `nama` | teks |
| Sasaran | `sasaran` | relasi ke `sasaran` |
| Penanggung Jawab | `pj` | teks |
| Tenggat | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### IKU (Kinerja) (tabel `ikuk`)

- **Membutuhkan:** IKU
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| IKU Kinerja | `nama` | teks |
| IKU Master | `iku` | relasi ke `iku` |
| Target | `target` | angka |
| Realisasi | `capaian` | angka |
| Status | `status` | pilihan: Tercapai, Proses, Tertunda |

#### IKI (Kinerja) (tabel `ikik`)

- **Membutuhkan:** IKI
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| IKI Kinerja | `nama` | teks |
| IKI Master | `iki` | relasi ke `iki` |
| Target | `target` | angka |
| Realisasi | `capaian` | angka |
| Status | `status` | pilihan: Tercapai, Proses, Tertunda |

#### Monitoring (tabel `monitoring`)

- **Membutuhkan:** Sasaran
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Tanggal | `tanggal` | tanggal |
| Kegiatan Monitoring | `nama` | teks |
| Sasaran | `sasaran` | relasi ke `sasaran` |
| Temuan | `temuan` | teks |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Evaluasi (tabel `evaluasi`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Tanggal | `tanggal` | tanggal |
| Evaluasi | `nama` | teks |
| Nilai | `nilai` | angka |
| Rekomendasi | `rekomendasi` | teks |
| Status | `status` | pilihan: Draft, Berjalan, Selesai |

### Umum & Keuangan

#### Persuratan (tabel `persuratan`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** Arsip
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor Surat | `kode` | teks |
| Perihal | `nama` | teks |
| Jenis | `jenis` | pilihan: Masuk, Keluar |
| Pengirim / Tujuan | `pengirim` | teks |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Arsip (tabel `arsip`)

- **Membutuhkan:** Persuratan
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 3

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode Arsip | `kode` | teks |
| Judul Berkas | `nama` | teks |
| Surat Terkait | `surat` | relasi ke `persuratan` |
| Unit | `unit` | teks |
| Retensi (tahun) | `retensi` | angka |
| Status | `status` | pilihan: Aktif, Inaktif, Musnah |

#### Perjalanan Dinas (tabel `perjalanan`)

- **Membutuhkan:** Pegawai
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor SPD | `kode` | teks |
| Tujuan / Keperluan | `nama` | teks |
| Pegawai | `pegawai` | relasi ke `pegawai` |
| Tanggal Berangkat | `tanggal` | tanggal |
| Biaya (Rp) | `nilai` | angka |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Kepegawaian (tabel `kepegawaian`)

- **Membutuhkan:** Pegawai
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor Berkas | `kode` | teks |
| Layanan | `nama` | teks |
| Pegawai | `pegawai` | relasi ke `pegawai` |
| Jenis | `jenis` | pilihan: Kenaikan Pangkat, Cuti, KGB, Mutasi, Diklat |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Rumah Tangga (tabel `rumahtangga`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 3

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Uraian | `nama` | teks |
| Jenis | `jenis` | pilihan: ATK, Kebersihan, Listrik & Air, Konsumsi, Pemeliharaan Gedung |
| Unit | `unit` | teks |
| Nilai (Rp) | `nilai` | angka |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Kendaraan (tabel `kendaraan`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor Polisi | `kode` | teks |
| Jenis Kendaraan | `nama` | teks |
| Pengguna | `pengguna` | teks |
| Jatuh Tempo STNK | `tanggal` | tanggal |
| Status | `status` | pilihan: Aktif, Servis, Tidak Layak |

#### Anggaran (tabel `anggaran`)

- **Membutuhkan:** Sub Kegiatan
- **Dipakai oleh:** SPJ, Perencanaan
- **Baris saat dibuat:** 3

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Uraian | `nama` | teks |
| Sub Kegiatan | `subkegiatan` | relasi ke `subkegiatan` |
| Pagu (Rp) | `pagu` | angka |
| Realisasi (Rp) | `realisasi` | angka |
| Status | `status` | pilihan: Berjalan, Selesai, Terlambat |

#### SPJ (tabel `spj`)

- **Membutuhkan:** Anggaran
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 3

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor SPJ | `kode` | teks |
| Uraian Pertanggungjawaban | `nama` | teks |
| Anggaran | `anggaran` | relasi ke `anggaran` |
| Tanggal | `tanggal` | tanggal |
| Nilai (Rp) | `nilai` | angka |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

### Aset & BMD

#### Perencanaan (tabel `aset_rencana`)

- **Membutuhkan:** Anggaran
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Rencana Pengadaan Aset | `nama` | teks |
| Anggaran | `anggaran` | relasi ke `anggaran` |
| Jenis Aset | `jenis` | pilihan: Kendaraan, Peralatan Kantor, Elektronik, Tanah & Bangunan, Lainnya |
| Estimasi Nilai (Rp) | `nilai` | angka |
| Target Pengadaan | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Inventaris (tabel `inventaris`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** Pemeliharaan, Mutasi, Penghapusan
- **Baris saat dibuat:** 4

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode Barang | `kode` | teks |
| Nama Barang | `nama` | teks |
| Jenis | `jenis` | pilihan: Kendaraan, Peralatan Kantor, Elektronik, Tanah & Bangunan, Lainnya |
| Unit Pengguna | `unit` | teks |
| Tahun Perolehan | `tahun` | angka |
| Nilai Perolehan (Rp) | `nilai` | angka |
| Kondisi | `status` | pilihan: Baik, Rusak Ringan, Rusak Berat |

#### Pemeliharaan (tabel `pemeliharaan`)

- **Membutuhkan:** Inventaris
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor | `kode` | teks |
| Uraian Pemeliharaan | `nama` | teks |
| Barang | `barang` | relasi ke `inventaris` |
| Tanggal | `tanggal` | tanggal |
| Biaya (Rp) | `nilai` | angka |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Mutasi (tabel `mutasi`)

- **Membutuhkan:** Inventaris
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor BA | `kode` | teks |
| Barang | `barang` | relasi ke `inventaris` |
| Unit Asal | `unit_asal` | teks |
| Unit Tujuan | `unit_tujuan` | teks |
| Jenis | `jenis` | pilihan: Pindah Tugas, Pindah Pengguna, Hibah, Lainnya |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai |

#### Penghapusan (tabel `penghapusan`)

- **Membutuhkan:** Inventaris
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor SK | `kode` | teks |
| Barang | `barang` | relasi ke `inventaris` |
| Alasan | `alasan` | pilihan: Rusak Berat, Hilang, Dijual, Hibah, Musnah |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai |

#### Rekonsiliasi (tabel `rekonsiliasi`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Periode / Uraian | `nama` | teks |
| Unit | `unit` | teks |
| Tanggal | `tanggal` | tanggal |
| Jumlah Sistem (unit) | `jumlah_sim` | angka |
| Jumlah Fisik (unit) | `jumlah_fisik` | angka |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

### Persidangan DPRD

#### Agenda (tabel `agenda`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** Jadwal, Paripurna
- **Baris saat dibuat:** 3

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode Agenda | `kode` | teks |
| Uraian Agenda | `nama` | teks |
| Jenis | `jenis` | pilihan: Paripurna, Komisi, Badan Anggaran, Bapemperda, Badan Kehormatan, Lainnya |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Jadwal (tabel `jadwal`)

- **Membutuhkan:** Agenda
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Kegiatan | `nama` | teks |
| Agenda | `agenda` | relasi ke `agenda` |
| Tanggal | `tanggal` | tanggal |
| Tempat | `tempat` | teks |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Rapat (tabel `rapat`)

- **Membutuhkan:** Komisi
- **Dipakai oleh:** Risalah, Notulen, Dokumentasi
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor Rapat | `kode` | teks |
| Uraian Rapat | `nama` | teks |
| Jenis | `jenis` | pilihan: Rapat Komisi, Rapat Badan, Rapat Internal, Rapat Konsultasi |
| Komisi | `komisi` | relasi ke `komisi` |
| Pimpinan Rapat | `pimpinan` | teks |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Komisi (tabel `rapat_komisi`)

- **Membutuhkan:** Komisi
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Uraian | `nama` | teks |
| Komisi | `komisi` | relasi ke `komisi` |
| Pimpinan | `pimpinan` | teks |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Badan Anggaran (tabel `banggar`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Uraian | `nama` | teks |
| Pimpinan | `pimpinan` | teks |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Bapemperda (tabel `bapemperda`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Uraian | `nama` | teks |
| Pimpinan | `pimpinan` | teks |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Badan Kehormatan (tabel `bk`)

- **Membutuhkan:** Anggota DPRD
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor Perkara | `kode` | teks |
| Uraian | `nama` | teks |
| Anggota Terkait | `anggota` | relasi ke `anggota` |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Paripurna (tabel `paripurna`)

- **Membutuhkan:** Agenda
- **Dipakai oleh:** Keputusan
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor | `kode` | teks |
| Uraian | `nama` | teks |
| Agenda | `agenda` | relasi ke `agenda` |
| Jenis | `jenis` | pilihan: Pembukaan Masa Sidang, Penutupan Masa Sidang, Pengambilan Keputusan, Pidato Kepala Daerah |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Risalah (tabel `risalah`)

- **Membutuhkan:** Rapat
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor | `kode` | teks |
| Uraian | `nama` | teks |
| Rapat | `rapat` | relasi ke `rapat` |
| Jumlah Halaman | `halaman` | angka |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Notulen (tabel `notulen`)

- **Membutuhkan:** Rapat
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor | `kode` | teks |
| Uraian | `nama` | teks |
| Rapat | `rapat` | relasi ke `rapat` |
| Jumlah Peserta | `peserta` | angka |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Keputusan (tabel `keputusan`)

- **Membutuhkan:** Paripurna
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor Keputusan | `kode` | teks |
| Uraian | `nama` | teks |
| Jenis | `jenis` | pilihan: Keputusan DPRD, Keputusan Pimpinan, Keputusan Badan Kehormatan |
| Rapat Paripurna | `paripurna` | relasi ke `paripurna` |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

### Legislasi

#### Propemperda (tabel `propemperda`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** Ranperda
- **Baris saat dibuat:** 3

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Rancangan Perda | `nama` | teks |
| Pengusul | `pengusul` | pilihan: DPRD, Pemerintah Daerah, Usulan Masyarakat |
| Tahun | `tahun` | angka |
| Tanggal Penetapan | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Ranperda (tabel `ranperda`)

- **Membutuhkan:** Propemperda
- **Dipakai oleh:** Naskah Akademik, DIM, Harmonisasi
- **Baris saat dibuat:** 3

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor | `kode` | teks |
| Judul Ranperda | `nama` | teks |
| Propemperda | `propemperda` | relasi ke `propemperda` |
| Pengusul | `pengusul` | teks |
| Tahapan | `tahapan` | pilihan: Penyusunan, Pembahasan Tingkat I, Pembahasan Tingkat II, Persetujuan Bersama, Ditetapkan |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Naskah Akademik (tabel `naskahakademik`)

- **Membutuhkan:** Ranperda
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Judul Naskah | `nama` | teks |
| Ranperda | `ranperda` | relasi ke `ranperda` |
| Penyusun | `penyusun` | teks |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### DIM (tabel `dim`)

- **Membutuhkan:** Ranperda
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 3

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor DIM | `kode` | teks |
| Materi | `nama` | teks |
| Ranperda | `ranperda` | relasi ke `ranperda` |
| Pasal | `pasal` | teks |
| Jenis | `jenis` | pilihan: Perubahan, Penambahan, Penghapusan, Tetap |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Harmonisasi (tabel `harmonisasi`)

- **Membutuhkan:** Ranperda
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Kegiatan Harmonisasi | `nama` | teks |
| Ranperda | `ranperda` | relasi ke `ranperda` |
| Tanggal | `tanggal` | tanggal |
| Catatan Hasil | `catatan` | teks |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### JDIH DPRD (tabel `jdih`)

- **Membutuhkan:** Regulasi
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 3

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor Dokumen | `kode` | teks |
| Judul Produk Hukum | `nama` | teks |
| Regulasi Terkait | `regulasi` | relasi ke `regulasi` |
| Jenis | `jenis` | pilihan: Perda, Perbup, Keputusan DPRD, Peraturan DPRD, Peraturan Pemerintah |
| Status | `status` | pilihan: Draft, Berjalan, Selesai |

### Penganggaran DPRD

#### KUA (tabel `kua`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** PPAS
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Uraian KUA | `nama` | teks |
| Tahun Anggaran | `tahun` | angka |
| Total Plafon (Rp) | `pagu` | angka |
| Tanggal Kesepakatan | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### PPAS (tabel `ppas`)

- **Membutuhkan:** KUA
- **Dipakai oleh:** APBD
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Uraian PPAS | `nama` | teks |
| KUA Induk | `kua` | relasi ke `kua` |
| Tahun | `tahun` | angka |
| Total Pagu (Rp) | `pagu` | angka |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### APBD (tabel `apbd`)

- **Membutuhkan:** PPAS
- **Dipakai oleh:** APBDP, Laporan Semester, Pertanggungjawaban
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor Perda | `kode` | teks |
| Uraian Anggaran DPRD | `nama` | teks |
| PPAS Induk | `ppas` | relasi ke `ppas` |
| Tahun | `tahun` | angka |
| Total Belanja (Rp) | `pagu` | angka |
| Tanggal Penetapan | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### APBDP (tabel `apbdp`)

- **Membutuhkan:** APBD
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor Perda | `kode` | teks |
| Uraian Perubahan | `nama` | teks |
| APBD Induk | `apbd` | relasi ke `apbd` |
| Tahun | `tahun` | angka |
| Total Belanja (Rp) | `pagu` | angka |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Laporan Semester (tabel `lapsemester`)

- **Membutuhkan:** APBD
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor | `kode` | teks |
| Laporan Semester | `nama` | teks |
| APBD | `apbd` | relasi ke `apbd` |
| Periode | `periode` | pilihan: Semester I, Semester II |
| Realisasi (Rp) | `realisasi` | angka |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Pertanggungjawaban (tabel `pertanggungjawaban`)

- **Membutuhkan:** APBD
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor Perda | `kode` | teks |
| Laporan Pertanggungjawaban | `nama` | teks |
| APBD | `apbd` | relasi ke `apbd` |
| Tahun | `tahun` | angka |
| Realisasi (Rp) | `realisasi` | angka |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

### Pengawasan DPRD

#### Monitoring OPD (tabel `monopd`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Kegiatan Monitoring | `nama` | teks |
| OPD Dimonitor | `opd` | teks |
| Tanggal | `tanggal` | tanggal |
| Jumlah Temuan | `jumlah_temuan` | angka |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Monitoring Program (tabel `monprogram`)

- **Membutuhkan:** Program
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Kegiatan Monitoring | `nama` | teks |
| Program | `program` | relasi ke `program` |
| Tanggal | `tanggal` | tanggal |
| Capaian (%) | `capaian` | angka |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Monitoring Proyek (tabel `monproyek`)

- **Membutuhkan:** Kegiatan
- **Dipakai oleh:** Temuan
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Proyek | `nama` | teks |
| Kegiatan | `kegiatan` | relasi ke `kegiatan` |
| Lokasi | `lokasi` | teks |
| Nilai Kontrak (Rp) | `pagu` | angka |
| Progres (%) | `progres` | angka |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### LKPJ (tabel `lkpj`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor | `kode` | teks |
| Dokumen LKPJ | `nama` | teks |
| Tahun | `tahun` | angka |
| OPD Penyusun | `opd` | teks |
| Tanggal Penyampaian | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Temuan (tabel `temuan`)

- **Membutuhkan:** Monitoring Proyek
- **Dipakai oleh:** Rekomendasi
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor Temuan | `kode` | teks |
| Uraian Temuan | `nama` | teks |
| Proyek Terkait | `proyek` | relasi ke `monproyek` |
| Jenis | `jenis` | pilihan: Administrasi, Kualitas, Volume, Keterlambatan |
| Nilai (Rp) | `nilai` | angka |
| Status | `status` | pilihan: Terbuka, Dalam Tindak Lanjut, Selesai |

#### Rekomendasi (tabel `rekomendasi`)

- **Membutuhkan:** Temuan
- **Dipakai oleh:** Tindak Lanjut
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor | `kode` | teks |
| Uraian Rekomendasi | `nama` | teks |
| Temuan | `temuan` | relasi ke `temuan` |
| Tenggat | `tenggat` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Tindak Lanjut (tabel `tindaklanjut`)

- **Membutuhkan:** Rekomendasi
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 1

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor | `kode` | teks |
| Uraian Tindak Lanjut | `nama` | teks |
| Rekomendasi | `rekomendasi` | relasi ke `rekomendasi` |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

### Aspirasi

#### Reses (tabel `reses`)

- **Membutuhkan:** Anggota DPRD
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Kegiatan Reses | `nama` | teks |
| Anggota DPRD | `anggota` | relasi ke `anggota` |
| Daerah Pemilihan | `dapil` | teks |
| Tanggal | `tanggal` | tanggal |
| Jumlah Peserta | `peserta` | angka |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Pokir (tabel `pokir`)

- **Membutuhkan:** Anggota DPRD
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 3

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Usulan Pokok Pikiran | `nama` | teks |
| Pengusul | `anggota` | relasi ke `anggota` |
| Dapil | `dapil` | teks |
| Nilai Usulan (Rp) | `usulan` | angka |
| Status | `status` | pilihan: Diusulkan, Disinkronkan, Masuk APBD, Ditolak |

#### Hearing (tabel `hearing`)

- **Membutuhkan:** Komisi
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Topik Hearing | `nama` | teks |
| Komisi | `komisi` | relasi ke `komisi` |
| Narasumber | `narasumber` | teks |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Audiensi (tabel `audiensi`)

- **Membutuhkan:** Anggota DPRD
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Pemohon / Kelompok | `nama` | teks |
| Diterima Oleh | `penerima` | relasi ke `anggota` |
| Tanggal | `tanggal` | tanggal |
| Ringkasan Permohonan | `tuntutan` | teks |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Aspirasi Digital (tabel `aspirasidigital`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode Tiket | `kode` | teks |
| Aspirasi | `nama` | teks |
| Kanal | `kanal` | pilihan: Portal Web, Aplikasi, Media Sosial, Surat Elektronik |
| Dapil | `dapil` | teks |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Pengaduan (tabel `pengaduan`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Nomor Pengaduan | `kode` | teks |
| Uraian Pengaduan | `nama` | teks |
| Kanal | `kanal` | pilihan: Langsung, Surat, Portal Web, Media Sosial |
| Unit Tindak Lanjut | `unit` | teks |
| Tenggat | `tenggat` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

### Humas & Protokol

#### Berita (tabel `berita`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 3

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Judul Berita | `nama` | teks |
| Kategori | `kategori` | pilihan: Persidangan, Legislasi, Pengawasan, Aspirasi, Kegiatan Umum |
| Penulis | `penulis` | teks |
| Tanggal Terbit | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Publikasi (tabel `publikasi`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 3

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Judul Publikasi | `nama` | teks |
| Jenis | `jenis` | pilihan: Siaran Pers, Buletin, Laporan Tahunan, Infografis, Video |
| Kanal | `kanal` | pilihan: Website, Media Sosial, Media Cetak, YouTube |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Dokumentasi (tabel `dokumentasi`)

- **Membutuhkan:** Rapat
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode Arsip | `kode` | teks |
| Deskripsi Kegiatan | `nama` | teks |
| Kegiatan Terkait | `kegiatan` | relasi ke `rapat` |
| Jumlah Berkas | `jumlah` | angka |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai |

#### Media Monitoring (tabel `mediamon`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Pemberitaan | `nama` | teks |
| Media | `media` | teks |
| Sentimen | `sentimen` | pilihan: Positif, Netral, Negatif |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |

#### Protokoler (tabel `protokoler`)

- **Membutuhkan:** tidak ada
- **Dipakai oleh:** belum ada
- **Baris saat dibuat:** 2

| Kolom | Nama di database | Jenis |
|---|---|---|
| Kode | `kode` | teks |
| Kegiatan Protokoler | `nama` | teks |
| Tamu / Pejabat | `tamu` | teks |
| Jenis | `jenis` | pilihan: Kunjungan Tamu, Upacara, Acara Resmi, Penerimaan Delegasi |
| Tanggal | `tanggal` | tanggal |
| Status | `status` | pilihan: Draft, Berjalan, Selesai, Terlambat |
