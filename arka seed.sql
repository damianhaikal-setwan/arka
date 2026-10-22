-- ARKA: data contoh (fiktif). Jalankan sekali, setelah arka_schema.sql.

insert into public.pegawai (id, dibuat, diubah, nip, nama, jabatan, unit, golongan, status) values
  ('9nrd4vt', '2026-01-01', '2026-01-01', '198604122010011003', 'Hendra Wijaya, S.H.', 'Kepala Bagian Umum', 'Bagian Umum dan Keuangan', 'III/c', 'Aktif'),
  ('bgz4rsp', '2026-01-01', '2026-01-01', '197811052003122005', 'Yuliana Sari, S.E.', 'Kasubag Keuangan', 'Bagian Umum dan Keuangan', 'III/b', 'Aktif'),
  ('a0pxc7p', '2026-01-01', '2026-01-01', '199005202015031002', 'Rahmat Hidayat, S.Kom.', 'Analis Sistem Informasi', 'Bagian Persidangan dan Perundang-undangan', 'III/a', 'Aktif'),
  ('y5wkkc5', '2026-01-01', '2026-01-01', '198209142008022001', 'Maria Ulfah, S.Sos.', 'Analis Humas dan Protokol', 'Bagian Persidangan dan Perundang-undangan', 'III/b', 'Cuti'),
  ('9qbsgz6', '2026-01-01', '2026-01-01', '197505301999031004', 'Antonius Ayu, S.T.', 'Pengelola BMD', 'Bagian Umum dan Keuangan', 'III/d', 'Aktif');

insert into public.anggota (id, dibuat, diubah, nama, fraksi, komisi, dapil, jabatan, status) values
  ('vkpomuc', '2026-01-01', '2026-01-01', 'H. Ahmad Yani, S.Pd.', 'Fraksi Persatuan Pembangunan', 'Komisi I', 'Dapil I', 'Ketua DPRD', 'Aktif'),
  ('r2hkil7', '2026-01-01', '2026-01-01', 'Siti Rahmawati, S.E.', 'Fraksi Golkar', 'Komisi II', 'Dapil II', 'Wakil Ketua I', 'Aktif'),
  ('vdctt8i', '2026-01-01', '2026-01-01', 'Dedi Kurniawan', 'Fraksi Gerindra', 'Komisi III', 'Dapil III', 'Anggota', 'Aktif'),
  ('8o82m40', '2026-01-01', '2026-01-01', 'Ferry Ardiansyah', 'Fraksi NasDem', 'Komisi IV', 'Dapil I', 'Anggota', 'Aktif'),
  ('crj0g6g', '2026-01-01', '2026-01-01', 'Lina Marlina', 'Fraksi PDI Perjuangan', 'Komisi I', 'Dapil II', 'Anggota', 'Antar Waktu');

insert into public.komisi (id, dibuat, diubah, kode, nama, ketua, mitra, jumlah, status) values
  ('j9137j2', '2026-01-01', '2026-01-01', 'K-I', 'Komisi I', 'Dedi Kurniawan', 'Bagian Hukum, Bagian Pemerintahan', 11, 'Aktif'),
  ('kcltq1j', '2026-01-01', '2026-01-01', 'K-II', 'Komisi II', 'Siti Rahmawati', 'Bappeda, Dinas Pendapatan', 11, 'Aktif'),
  ('n7asj1c', '2026-01-01', '2026-01-01', 'K-III', 'Komisi III', 'Ferry Ardiansyah', 'Dinas PUPR, Dinas Perhubungan', 11, 'Aktif'),
  ('ug1lpcw', '2026-01-01', '2026-01-01', 'K-IV', 'Komisi IV', 'Lina Marlina', 'Dinas Kesehatan, Dinas Pendidikan', 12, 'Aktif');

insert into public.fraksi (id, dibuat, diubah, kode, nama, ketua, jumlah, status) values
  ('pu7z395', '2026-01-01', '2026-01-01', 'F-01', 'Fraksi Golkar', 'Siti Rahmawati', 6, 'Aktif'),
  ('03z1w94', '2026-01-01', '2026-01-01', 'F-02', 'Fraksi Gerindra', 'Dedi Kurniawan', 5, 'Aktif'),
  ('q2kajaw', '2026-01-01', '2026-01-01', 'F-03', 'Fraksi PDI Perjuangan', 'Lina Marlina', 4, 'Aktif'),
  ('161je6o', '2026-01-01', '2026-01-01', 'F-04', 'Fraksi Persatuan Pembangunan', 'H. Ahmad Yani', 3, 'Aktif');

insert into public.alat (id, dibuat, diubah, kode, nama, jenis, ketua, jumlah, status) values
  ('mi13uwf', '2026-01-01', '2026-01-01', 'ALA-01', 'Alat Kelengkapan DPRD contoh 1', 'Panitia', '', 2000000, 'Nonaktif'),
  ('f5xmykx', '2026-01-02', '2026-01-02', 'ALA-02', 'Alat Kelengkapan DPRD contoh 2', 'Kelompok Kerja', '', 3000000, 'Aktif'),
  ('z013gn4', '2026-01-03', '2026-01-03', 'ALA-03', 'Alat Kelengkapan DPRD contoh 3', 'Badan', '', 4000000, 'Nonaktif'),
  ('mfb0ve5', '2026-01-04', '2026-01-04', 'ALA-04', 'Alat Kelengkapan DPRD contoh 4', 'Panitia', '', 5000000, 'Aktif');

insert into public.tenaga (id, dibuat, diubah, nama, keahlian, komisi, kontrak, status) values
  ('eyb7doi', '2026-01-01', '2026-01-01', 'Tenaga Ahli contoh 1', '', 'j9137j2', '', 'Berakhir'),
  ('14z6k7a', '2026-01-02', '2026-01-02', 'Tenaga Ahli contoh 2', '', 'kcltq1j', '', 'Aktif'),
  ('hymi0hk', '2026-01-03', '2026-01-03', 'Tenaga Ahli contoh 3', '', 'n7asj1c', '', 'Berakhir'),
  ('e7fgsac', '2026-01-04', '2026-01-04', 'Tenaga Ahli contoh 4', '', 'ug1lpcw', '', 'Aktif');

insert into public.mitra (id, dibuat, diubah, kode, nama, jenis, komisi, kontak, status) values
  ('1io2ek9', '2026-01-01', '2026-01-01', 'MIT-01', 'Mitra Kerja contoh 1', 'BUMD', 'j9137j2', '', 'Nonaktif'),
  ('q0i9avc', '2026-01-02', '2026-01-02', 'MIT-02', 'Mitra Kerja contoh 2', 'Vertikal', 'kcltq1j', '', 'Aktif'),
  ('e313pi0', '2026-01-03', '2026-01-03', 'MIT-03', 'Mitra Kerja contoh 3', 'Lainnya', 'n7asj1c', '', 'Nonaktif'),
  ('ots6coe', '2026-01-04', '2026-01-04', 'MIT-04', 'Mitra Kerja contoh 4', 'OPD', 'ug1lpcw', '', 'Aktif');

insert into public.program (id, dibuat, diubah, kode, nama, unit, pagu, realisasi, status) values
  ('qbbprdz', '2026-01-01', '2026-01-01', '1.01.01', 'Program Pelayanan Administrasi Perkantoran', 'Sekretariat DPRD', 2450000000, 2118000000, 'Berjalan'),
  ('nq0k4tt', '2026-01-01', '2026-01-01', '1.01.02', 'Program Peningkatan Sarana dan Prasarana Aparatur', 'Bagian Umum dan Keuangan', 1180000000, 1075000000, 'Berjalan'),
  ('zbudo71', '2026-01-01', '2026-01-01', '1.02.01', 'Program Penyediaan Layanan Dewan', 'Bagian Persidangan dan Perundang-undangan', 3620000000, 2940000000, 'Berjalan'),
  ('c1z7d20', '2026-01-01', '2026-01-01', '1.03.01', 'Program Peningkatan Kapasitas Aparatur', 'Subbagian Tata Usaha dan Kepegawaian', 620000000, 620000000, 'Selesai');

insert into public.kegiatan (id, dibuat, diubah, kode, nama, program, pagu, realisasi, status) values
  ('cg58giz', '2026-01-01', '2026-01-01', '1.01.01.01', 'Penyediaan Jasa Surat Menyurat', 'qbbprdz', 320000000, 298000000, 'Berjalan'),
  ('qj16xrd', '2026-01-01', '2026-01-01', '1.01.01.02', 'Penyediaan Jasa Komunikasi, Sumber Daya Air dan Listrik', 'qbbprdz', 540000000, 501000000, 'Berjalan'),
  ('e4yuo92', '2026-01-01', '2026-01-01', '1.02.01.01', 'Penyelenggaraan Rapat Paripurna', 'zbudo71', 880000000, 760000000, 'Berjalan'),
  ('lpv34gn', '2026-01-01', '2026-01-01', '1.03.01.01', 'Pendidikan dan Pelatihan Teknis Aparatur', 'c1z7d20', 620000000, 620000000, 'Selesai');

insert into public.subkegiatan (id, dibuat, diubah, kode, nama, kegiatan, pagu, status) values
  ('ywg0dwn', '2026-01-01', '2026-01-01', '1.01.01.01.0001', 'Pengadaan Perangko dan Meterai', 'cg58giz', 120000000, 'Berjalan'),
  ('v19ea4l', '2026-01-01', '2026-01-01', '1.02.01.01.0001', 'Penyelenggaraan Rapat Paripurna Reguler', 'e4yuo92', 430000000, 'Selesai'),
  ('0d6x42m', '2026-01-01', '2026-01-01', '1.02.01.01.0002', 'Penyusunan Risalah Rapat', 'e4yuo92', 95000000, 'Berjalan');

insert into public.iku (id, dibuat, diubah, kode, nama, unit, target, capaian, satuan, status) values
  ('p0e6icq', '2026-01-01', '2026-01-01', 'IKU-01', 'Persentase rapat paripurna terlaksana tepat waktu', 'Bagian Persidangan dan Perundang-undangan', 100, 96, '%', 'Proses'),
  ('po1k2le', '2026-01-01', '2026-01-01', 'IKU-02', 'Persentase Perda yang dibahas sesuai Propemperda', 'Bagian Persidangan dan Perundang-undangan', 90, 92, '%', 'Tercapai'),
  ('tluljt2', '2026-01-01', '2026-01-01', 'IKU-03', 'Persentase aduan masyarakat ditindaklanjuti', 'Bagian Persidangan dan Perundang-undangan', 95, 88, '%', 'Proses'),
  ('0oqh8d3', '2026-01-01', '2026-01-01', 'IKU-04', 'Nilai SAKIP Sekretariat', 'Sekretariat DPRD', 80, 78.5, 'Nilai', 'Proses'),
  ('ccvakup', '2026-01-01', '2026-01-01', 'IKU-05', 'Persentase BMD tercatat dan terverifikasi', 'Bagian Umum dan Keuangan', 100, 100, '%', 'Tercapai');

insert into public.sasaran (id, dibuat, diubah, kode, nama, unit, iku, status) values
  ('849ads1', '2026-01-01', '2026-01-01', 'S-01', 'Meningkatnya kualitas fungsi legislasi', 'Bagian Persidangan dan Perundang-undangan', 'po1k2le', 'Tercapai'),
  ('64wvq7t', '2026-01-01', '2026-01-01', 'S-02', 'Meningkatnya kualitas layanan persidangan', 'Bagian Persidangan dan Perundang-undangan', 'p0e6icq', 'Berjalan'),
  ('j9y3a6x', '2026-01-01', '2026-01-01', 'S-03', 'Meningkatnya akuntabilitas kinerja Sekretariat', 'Sekretariat DPRD', '0oqh8d3', 'Berjalan'),
  ('v1inemn', '2026-01-01', '2026-01-01', 'S-04', 'Terkelolanya BMD secara tertib', 'Bagian Umum dan Keuangan', 'ccvakup', 'Tercapai');

insert into public.iki (id, dibuat, diubah, kode, nama, pegawai, target, capaian, status) values
  ('uimt7mi', '2026-01-01', '2026-01-01', 'IKI-01', 'IKI contoh 1', '9nrd4vt', 2000000, 2000000, 'Proses'),
  ('oleb8hk', '2026-01-02', '2026-01-02', 'IKI-02', 'IKI contoh 2', 'bgz4rsp', 3000000, 3000000, 'Tertunda'),
  ('s24htnl', '2026-01-03', '2026-01-03', 'IKI-03', 'IKI contoh 3', 'a0pxc7p', 4000000, 4000000, 'Tercapai'),
  ('9te51o7', '2026-01-04', '2026-01-04', 'IKI-04', 'IKI contoh 4', 'y5wkkc5', 5000000, 5000000, 'Proses');

insert into public.regulasi (id, dibuat, diubah, kode, nama, jenis, status) values
  ('od0w57k', '2026-01-01', '2026-01-01', 'Perbup 57/2021', 'Kedudukan, Susunan Organisasi, Tugas dan Fungsi Sekretariat DPRD', 'Perbup', 'Berlaku'),
  ('hhpne1b', '2026-01-01', '2026-01-01', 'PP 12/2018', 'Tata Tertib DPRD', 'PP', 'Berlaku'),
  ('pn4o8u8', '2026-01-01', '2026-01-01', 'Perpres 29/2014', 'Sistem Akuntabilitas Kinerja Instansi Pemerintah (SAKIP)', 'Perpres', 'Berlaku'),
  ('2xm0y76', '2026-01-01', '2026-01-01', 'PermenPANRB 53/2014', 'Perjanjian Kinerja, Pelaporan Kinerja, dan Pengelolaan Data Kinerja', 'Permen', 'Berlaku'),
  ('z46hrcf', '2026-01-01', '2026-01-01', 'PermenPANRB 88/2021', 'Evaluasi Akuntabilitas Kinerja Instansi Pemerintah', 'Permen', 'Berlaku'),
  ('w3ny2q7', '2026-01-01', '2026-01-01', 'PermenPANRB 89/2021', 'Pengukuran Kinerja', 'Permen', 'Berlaku'),
  ('2zhzxxm', '2026-01-01', '2026-01-01', 'PermenPANRB 6/2022', 'Pedoman Penyusunan Perencanaan Kinerja', 'Permen', 'Berlaku');

insert into public.rpjmd (id, dibuat, diubah, kode, nama, periode, status) values
  ('xw5rccd', '2026-01-01', '2026-01-01', 'RPJ-01', 'RPJMD contoh 1', '', 'Selesai'),
  ('c8fij31', '2026-01-02', '2026-01-02', 'RPJ-02', 'RPJMD contoh 2', '', 'Revisi'),
  ('15b5bju', '2026-01-03', '2026-01-03', 'RPJ-03', 'RPJMD contoh 3', '', 'Berjalan'),
  ('tn0b6pd', '2026-01-04', '2026-01-04', 'RPJ-04', 'RPJMD contoh 4', '', 'Selesai');

insert into public.renstra (id, dibuat, diubah, kode, nama, unit, periode, status) values
  ('2j066gd', '2026-01-01', '2026-01-01', 'RS-01', 'Renstra Sekretariat DPRD 2025–2029', 'Sekretariat DPRD', '2025–2029', 'Berjalan');

insert into public.renja (id, dibuat, diubah, kode, nama, tahun, pagu, status) values
  ('xtcc997', '2026-01-01', '2026-01-01', 'RJ-2026', 'Renja Sekretariat DPRD Tahun 2026', 2026, 6000000000, 'Berjalan');

insert into public.cascading (id, dibuat, diubah, kode, nama, level, sumber, tujuan, status) values
  ('odpv1nm', '2026-01-01', '2026-01-01', 'C-01', 'Dukungan kinerja legislasi', 'Sekretariat', 'j9y3a6x', '849ads1', 'Berjalan'),
  ('t6cvg9o', '2026-01-01', '2026-01-01', 'C-02', 'Dukungan layanan persidangan', 'Sekretariat', 'j9y3a6x', '64wvq7t', 'Berjalan'),
  ('6sopq9h', '2026-01-01', '2026-01-01', 'C-03', 'Pengelolaan BMD', 'Sekretariat', 'j9y3a6x', 'v1inemn', 'Selesai');

insert into public.pohon (id, dibuat, diubah, kode, nama, level, induk, status) values
  ('p6untw3', '2026-01-01', '2026-01-01', 'PK-1', 'Layanan kelembagaan DPRD yang prima dan akuntabel', 'Sasaran Strategis', null, 'Berjalan'),
  ('6ct0se1', '2026-01-01', '2026-01-01', 'PK-1.1', 'Meningkatnya kualitas layanan persidangan', 'Sasaran Kegiatan', 'p6untw3', 'Berjalan'),
  ('ytl2vtr', '2026-01-01', '2026-01-01', 'PK-1.1.1', 'Persentase rapat paripurna tepat waktu', 'Indikator', '6ct0se1', 'Berjalan'),
  ('aqt2iws', '2026-01-01', '2026-01-01', 'PK-1.2', 'Meningkatnya akuntabilitas kinerja Sekretariat', 'Sasaran Kegiatan', 'p6untw3', 'Berjalan'),
  ('630j1wr', '2026-01-01', '2026-01-01', 'PK-1.2.1', 'Nilai SAKIP Sekretariat', 'Indikator', 'aqt2iws', 'Berjalan'),
  ('guzg25g', '2026-01-01', '2026-01-01', 'PK-1.3', 'Terkelolanya BMD secara tertib', 'Sasaran Kegiatan', 'p6untw3', 'Selesai'),
  ('go6y5h4', '2026-01-01', '2026-01-01', 'PK-1.3.1', 'Persentase BMD tercatat dan terverifikasi', 'Indikator', 'guzg25g', 'Selesai');

insert into public.perjanjian (id, dibuat, diubah, kode, nama, pejabat, tahun, status) values
  ('ikqstrt', '2026-01-01', '2026-01-01', 'PK-2026-01', 'Perjanjian Kinerja Sekretaris DPRD Tahun 2026', 'Sekretaris Dewan', 2026, 'Berjalan');

insert into public.rencanaaksi (id, dibuat, diubah, kode, nama, sasaran, pj, tanggal, status) values
  ('3abbbmg', '2026-01-01', '2026-01-01', 'RA-01', 'Penyusunan dokumen legislasi prioritas', '849ads1', 'Bagian Persidangan dan Perundang-undangan', '2026-12-31', 'Berjalan'),
  ('ngyocjw', '2026-01-01', '2026-01-01', 'RA-02', 'Penyelenggaraan layanan persidangan terjadwal', '64wvq7t', 'Bagian Persidangan dan Perundang-undangan', '2026-11-30', 'Berjalan'),
  ('dvp96xu', '2026-01-01', '2026-01-01', 'RA-03', 'Penyusunan laporan kinerja triwulan', 'j9y3a6x', 'Bagian Umum dan Keuangan', '2026-10-31', 'Terlambat');

insert into public.ikuk (id, dibuat, diubah, kode, nama, iku, target, capaian, status) values
  ('1j2dnii', '2026-01-01', '2026-01-01', 'IKU-01', 'IKU (Kinerja) contoh 1', 'p0e6icq', 2000000, 2000000, 'Proses'),
  ('filw4yx', '2026-01-02', '2026-01-02', 'IKU-02', 'IKU (Kinerja) contoh 2', 'po1k2le', 3000000, 3000000, 'Tertunda'),
  ('v48nfkc', '2026-01-03', '2026-01-03', 'IKU-03', 'IKU (Kinerja) contoh 3', 'tluljt2', 4000000, 4000000, 'Tercapai'),
  ('bca2ddv', '2026-01-04', '2026-01-04', 'IKU-04', 'IKU (Kinerja) contoh 4', '0oqh8d3', 5000000, 5000000, 'Proses');

insert into public.ikik (id, dibuat, diubah, kode, nama, iki, target, capaian, status) values
  ('b7vbaqe', '2026-01-01', '2026-01-01', 'IKI-01', 'IKI (Kinerja) contoh 1', 'uimt7mi', 2000000, 2000000, 'Proses'),
  ('7j63a8k', '2026-01-02', '2026-01-02', 'IKI-02', 'IKI (Kinerja) contoh 2', 'oleb8hk', 3000000, 3000000, 'Tertunda'),
  ('xh7i03z', '2026-01-03', '2026-01-03', 'IKI-03', 'IKI (Kinerja) contoh 3', 's24htnl', 4000000, 4000000, 'Tercapai'),
  ('es9actm', '2026-01-04', '2026-01-04', 'IKI-04', 'IKI (Kinerja) contoh 4', '9te51o7', 5000000, 5000000, 'Proses');

insert into public.monitoring (id, dibuat, diubah, tanggal, nama, sasaran, temuan, status) values
  ('uxlx33n', '2026-01-01', '2026-01-01', '2026-01-11', 'Monitoring contoh 1', '849ads1', '', 'Berjalan'),
  ('6vxqudq', '2026-01-02', '2026-01-02', '2026-02-12', 'Monitoring contoh 2', '64wvq7t', '', 'Selesai'),
  ('ouo8uab', '2026-01-03', '2026-01-03', '2026-03-13', 'Monitoring contoh 3', 'j9y3a6x', '', 'Terlambat'),
  ('pslpt49', '2026-01-04', '2026-01-04', '2026-04-14', 'Monitoring contoh 4', 'v1inemn', '', 'Draft');

insert into public.evaluasi (id, dibuat, diubah, tanggal, nama, nilai, rekomendasi, status) values
  ('yjjwh60', '2026-01-01', '2026-01-01', '2026-01-11', 'Evaluasi contoh 1', 2000000, '', 'Berjalan'),
  ('ryz338m', '2026-01-02', '2026-01-02', '2026-02-12', 'Evaluasi contoh 2', 3000000, '', 'Selesai'),
  ('imohp1h', '2026-01-03', '2026-01-03', '2026-03-13', 'Evaluasi contoh 3', 4000000, '', 'Draft'),
  ('ts1sqjq', '2026-01-04', '2026-01-04', '2026-04-14', 'Evaluasi contoh 4', 5000000, '', 'Berjalan');

insert into public.persuratan (id, dibuat, diubah, kode, nama, jenis, pengirim, tanggal, status) values
  ('aktxhm3', '2026-01-01', '2026-01-01', '005/0123/SEKWAN/2026', 'Undangan rapat konsultasi penyusunan KUA-PPAS', 'Masuk', 'Bappeda', '2026-10-05', 'Selesai'),
  ('i8m3jxw', '2026-01-01', '2026-01-01', '005/0124/SEKWAN/2026', 'Permohonan data realisasi anggaran triwulan III', 'Masuk', 'Bagian Keuangan Setda', '2026-10-12', 'Berjalan'),
  ('bduit1s', '2026-01-01', '2026-01-01', '005/0410/SEKWAN/2026', 'Tindak lanjut hasil rapat paripurna', 'Keluar', 'Bupati Kapuas Hulu', '2026-10-15', 'Draft'),
  ('4316a4n', '2026-01-01', '2026-01-01', '005/0411/SEKWAN/2026', 'Undangan audiensi kelompok masyarakat', 'Keluar', 'Kelompok Tani Desa', '2026-10-18', 'Terlambat');

insert into public.arsip (id, dibuat, diubah, kode, nama, surat, unit, retensi, status) values
  ('sog2nss', '2026-01-01', '2026-01-01', 'ARS-2026-001', 'Berkas undangan rapat konsultasi KUA-PPAS', 'aktxhm3', 'Bagian Umum dan Keuangan', 10, 'Aktif'),
  ('amlpzgt', '2026-01-01', '2026-01-01', 'ARS-2026-002', 'Notulen dan daftar hadir rapat Badan Anggaran', 'i8m3jxw', 'Bagian Persidangan dan Perundang-undangan', 5, 'Aktif'),
  ('umunqmm', '2026-01-01', '2026-01-01', 'ARS-2025-014', 'Surat keputusan pimpinan tahun 2025', 'bduit1s', 'Bagian Umum dan Keuangan', 10, 'Inaktif');

insert into public.perjalanan (id, dibuat, diubah, kode, nama, pegawai, tanggal, nilai, status) values
  ('xsml1zs', '2026-01-01', '2026-01-01', 'SPD-001/2026', 'Kunjungan kerja studi banding ke DPRD kabupaten lain', 'a0pxc7p', '2026-09-14', 18500000, 'Selesai'),
  ('huyfhtt', '2026-01-01', '2026-01-01', 'SPD-002/2026', 'Bimbingan teknis penyusunan SAKIP', 'bgz4rsp', '2026-11-03', 12400000, 'Draft');

insert into public.kepegawaian (id, dibuat, diubah, kode, nama, pegawai, jenis, tanggal, status) values
  ('wkrk5a5', '2026-01-01', '2026-01-01', 'KP-01', 'Usulan kenaikan pangkat periode Oktober', 'bgz4rsp', 'Kenaikan Pangkat', '2026-10-10', 'Berjalan'),
  ('itxhkm8', '2026-01-01', '2026-01-01', 'KP-02', 'Pengajuan cuti tahunan', 'y5wkkc5', 'Cuti', '2026-09-01', 'Selesai');

insert into public.rumahtangga (id, dibuat, diubah, kode, nama, jenis, unit, nilai, tanggal, status) values
  ('gxyet66', '2026-01-01', '2026-01-01', 'RT-01', 'Pengadaan ATK semester II', 'ATK', 'Bagian Umum dan Keuangan', 85000000, '2026-07-08', 'Selesai'),
  ('5tq1iwf', '2026-01-01', '2026-01-01', 'RT-02', 'Pemeliharaan AC gedung paripurna', 'Pemeliharaan Gedung', 'Bagian Umum dan Keuangan', 24000000, '2026-10-02', 'Berjalan'),
  ('8mv937z', '2026-01-01', '2026-01-01', 'RT-03', 'Jasa kebersihan gedung', 'Kebersihan', 'Bagian Umum dan Keuangan', 96000000, '2026-01-05', 'Berjalan');

insert into public.kendaraan (id, dibuat, diubah, kode, nama, pengguna, tanggal, status) values
  ('qmlb4ss', '2026-01-01', '2026-01-01', 'KH 1001 A', 'Toyota Innova', 'Pimpinan DPRD', '2026-12-20', 'Aktif'),
  ('ceh774n', '2026-01-01', '2026-01-01', 'KH 1002 B', 'Toyota Hiace Commuter', 'Bagian Umum dan Keuangan', '2026-06-30', 'Servis');

insert into public.anggaran (id, dibuat, diubah, kode, nama, subkegiatan, pagu, realisasi, status) values
  ('u7hqgj8', '2026-01-01', '2026-01-01', 'AG-01', 'Penyediaan perangko dan meterai', 'ywg0dwn', 120000000, 98000000, 'Berjalan'),
  ('427lfni', '2026-01-01', '2026-01-01', 'AG-02', 'Rapat paripurna reguler', 'v19ea4l', 430000000, 430000000, 'Selesai'),
  ('x35rdmm', '2026-01-01', '2026-01-01', 'AG-03', 'Penyusunan risalah rapat', '0d6x42m', 95000000, 61000000, 'Berjalan');

insert into public.spj (id, dibuat, diubah, kode, nama, anggaran, tanggal, nilai, status) values
  ('8rt4zgu', '2026-01-01', '2026-01-01', 'SPJ-01', 'Pertanggungjawaban perangko dan meterai triwulan III', 'u7hqgj8', '2026-10-08', 98000000, 'Berjalan'),
  ('j5aj147', '2026-01-01', '2026-01-01', 'SPJ-02', 'Pertanggungjawaban rapat paripurna', '427lfni', '2026-09-30', 430000000, 'Selesai'),
  ('301qnxk', '2026-01-01', '2026-01-01', 'SPJ-03', 'Pertanggungjawaban risalah rapat', 'x35rdmm', '2026-10-20', 61000000, 'Terlambat');

insert into public.aset_rencana (id, dibuat, diubah, kode, nama, anggaran, jenis, nilai, tanggal, status) values
  ('tjpzxnn', '2026-01-01', '2026-01-01', 'RBA-01', 'Pengadaan kursi sidang anggota DPRD', 'x35rdmm', 'Peralatan Kantor', 95000000, '2026-12-15', 'Berjalan'),
  ('ikkpq7u', '2026-01-01', '2026-01-01', 'RBA-02', 'Penggantian server data persidangan', '427lfni', 'Elektronik', 150000000, '2027-02-28', 'Draft');

insert into public.inventaris (id, dibuat, diubah, kode, nama, jenis, unit, tahun, nilai, status) values
  ('rb7ep1i', '2026-01-01', '2026-01-01', 'BMD-001', 'Kendaraan Toyota Innova', 'Kendaraan', 'Bagian Umum dan Keuangan', 2022, 385000000, 'Baik'),
  ('pzp8jfr', '2026-01-01', '2026-01-01', 'BMD-002', 'Meja rapat paripurna (set)', 'Peralatan Kantor', 'Bagian Persidangan dan Perundang-undangan', 2019, 64000000, 'Rusak Ringan'),
  ('no2a8zx', '2026-01-01', '2026-01-01', 'BMD-003', 'Laptop kerja analis sistem informasi', 'Elektronik', 'Bagian Persidangan dan Perundang-undangan', 2023, 14500000, 'Baik'),
  ('q4jsre3', '2026-01-01', '2026-01-01', 'BMD-004', 'Printer multifungsi lantai 2', 'Elektronik', 'Bagian Umum dan Keuangan', 2017, 6800000, 'Rusak Berat');

insert into public.pemeliharaan (id, dibuat, diubah, kode, nama, barang, tanggal, nilai, status) values
  ('tori70f', '2026-01-01', '2026-01-01', 'PMH-01', 'Perbaikan meja rapat paripurna', 'pzp8jfr', '2026-09-20', 3500000, 'Berjalan'),
  ('k1khx09', '2026-01-01', '2026-01-01', 'PMH-02', 'Servis berkala Toyota Innova', 'rb7ep1i', '2026-08-10', 2100000, 'Selesai');

insert into public.mutasi (id, dibuat, diubah, kode, barang, unit_asal, unit_tujuan, jenis, tanggal, status) values
  ('jh7zypw', '2026-01-01', '2026-01-01', 'BA-MTS-01/2026', 'no2a8zx', 'Bagian Persidangan dan Perundang-undangan', 'Bagian Persidangan dan Perundang-undangan', 'Pindah Pengguna', '2026-10-01', 'Selesai');

insert into public.penghapusan (id, dibuat, diubah, kode, barang, alasan, tanggal, status) values
  ('x4r9vhs', '2026-01-01', '2026-01-01', 'SK-HPS-01/2026', 'q4jsre3', 'Rusak Berat', '2026-10-15', 'Draft');

insert into public.rekonsiliasi (id, dibuat, diubah, kode, nama, unit, tanggal, jumlah_sim, jumlah_fisik, status) values
  ('ayhf2a4', '2026-01-01', '2026-01-01', 'REK-2026-Q3', 'Rekonsiliasi BMD triwulan III 2026', 'Sekretariat DPRD', '2026-10-05', 412, 409, 'Berjalan');

insert into public.agenda (id, dibuat, diubah, kode, nama, jenis, tanggal, status) values
  ('7t1xqkw', '2026-01-01', '2026-01-01', 'AGD-2026-001', 'Pembukaan masa sidang I tahun 2026', 'Paripurna', '2026-02-02', 'Selesai'),
  ('h19gmjm', '2026-01-01', '2026-01-01', 'AGD-2026-045', 'Pembahasan Ranperda APBD Perubahan', 'Badan Anggaran', '2026-10-27', 'Berjalan'),
  ('5voji2l', '2026-01-01', '2026-01-01', 'AGD-2026-046', 'Rapat kerja komisi dengan mitra OPD', 'Komisi', '2026-10-28', 'Draft');

insert into public.jadwal (id, dibuat, diubah, kode, nama, agenda, tanggal, tempat, status) values
  ('r60335s', '2026-01-01', '2026-01-01', 'JDW-2026-101', 'Rapat kerja Komisi I', '5voji2l', '2026-10-28', 'Ruang Rapat Utama', 'Berjalan');

insert into public.rapat (id, dibuat, diubah, kode, nama, jenis, komisi, pimpinan, tanggal, status) values
  ('jt73ku5', '2026-01-01', '2026-01-01', 'RPT-2026-210', 'Rapat kerja dengan Bagian Hukum', 'Rapat Komisi', 'j9137j2', 'Dedi Kurniawan', '2026-10-20', 'Selesai'),
  ('f8qjqbw', '2026-01-01', '2026-01-01', 'RPT-2026-211', 'Rapat konsultasi pembahasan Ranperda pajak', 'Rapat Konsultasi', 'kcltq1j', 'Siti Rahmawati', '2026-10-23', 'Berjalan');

insert into public.rapat_komisi (id, dibuat, diubah, kode, nama, komisi, pimpinan, tanggal, status) values
  ('r9zmmmd', '2026-01-01', '2026-01-01', 'RK-01', 'Pembahasan Ranperda pajak daerah', 'kcltq1j', 'Siti Rahmawati', '2026-10-23', 'Berjalan');

insert into public.banggar (id, dibuat, diubah, kode, nama, pimpinan, tanggal, status) values
  ('ay469kb', '2026-01-01', '2026-01-01', 'BG-01', 'Pembahasan KUA-PPAS 2027', 'H. Ahmad Yani', '2026-10-14', 'Selesai');

insert into public.bapemperda (id, dibuat, diubah, kode, nama, pimpinan, tanggal, status) values
  ('eptl186', '2026-01-01', '2026-01-01', 'BP-01', 'Penyusunan Propemperda 2027', 'Ferry Ardiansyah', '2026-11-05', 'Draft');

insert into public.bk (id, dibuat, diubah, kode, nama, anggota, tanggal, status) values
  ('ry6ec42', '2026-01-01', '2026-01-01', 'BK-2026-01', 'Verifikasi pengaduan kode etik', 'crj0g6g', '2026-10-09', 'Berjalan');

insert into public.paripurna (id, dibuat, diubah, kode, nama, agenda, jenis, tanggal, status) values
  ('ijidcrf', '2026-01-01', '2026-01-01', 'PRP-2026-01', 'Rapat paripurna pembukaan masa sidang', '7t1xqkw', 'Pembukaan Masa Sidang', '2026-02-02', 'Selesai'),
  ('grdvfag', '2026-01-01', '2026-01-01', 'PRP-2026-12', 'Rapat paripurna pengambilan keputusan Ranperda', 'h19gmjm', 'Pengambilan Keputusan', '2026-10-30', 'Draft');

insert into public.risalah (id, dibuat, diubah, kode, nama, rapat, halaman, tanggal, status) values
  ('7dd6udx', '2026-01-01', '2026-01-01', 'RSL-2026-210', 'Risalah rapat kerja Komisi I dengan Bagian Hukum', 'jt73ku5', 14, '2026-10-21', 'Selesai');

insert into public.notulen (id, dibuat, diubah, kode, nama, rapat, peserta, tanggal, status) values
  ('8lzdt58', '2026-01-01', '2026-01-01', 'NTL-2026-210', 'Notulen rapat kerja Komisi I', 'jt73ku5', 12, '2026-10-21', 'Selesai');

insert into public.keputusan (id, dibuat, diubah, kode, nama, jenis, paripurna, tanggal, status) values
  ('xnndok0', '2026-01-01', '2026-01-01', 'KPT-2026-015', 'Keputusan pembentukan panitia khusus Ranperda', 'Keputusan DPRD', 'ijidcrf', '2026-02-02', 'Selesai');

insert into public.propemperda (id, dibuat, diubah, kode, nama, pengusul, tahun, tanggal, status) values
  ('856vy7b', '2026-01-01', '2026-01-01', 'PROP-2026-01', 'Ranperda Pajak Daerah', 'DPRD', 2026, '2026-01-20', 'Selesai'),
  ('y0dt5al', '2026-01-01', '2026-01-01', 'PROP-2026-02', 'Ranperda Penyelenggaraan Pendidikan', 'Pemerintah Daerah', 2026, '2026-01-20', 'Berjalan'),
  ('zi8t359', '2026-01-01', '2026-01-01', 'PROP-2027-01', 'Ranperda Perlindungan Pelaku Usaha Mikro', 'Usulan Masyarakat', 2027, null, 'Draft');

insert into public.ranperda (id, dibuat, diubah, kode, nama, propemperda, pengusul, tahapan, status) values
  ('0psmwuy', '2026-01-01', '2026-01-01', 'RAN-01/2026', 'Ranperda Pajak Daerah', '856vy7b', 'DPRD', 'Pembahasan Tingkat II', 'Berjalan'),
  ('ocfwzia', '2026-01-01', '2026-01-01', 'RAN-02/2026', 'Ranperda Penyelenggaraan Pendidikan', 'y0dt5al', 'Pemerintah Daerah', 'Penyusunan', 'Berjalan'),
  ('y0hmjhp', '2026-01-01', '2026-01-01', 'RAN-03/2026', 'Ranperda Perubahan atas Perda Retribusi', '856vy7b', 'DPRD', 'Ditetapkan', 'Selesai');

insert into public.naskahakademik (id, dibuat, diubah, kode, nama, ranperda, penyusun, tanggal, status) values
  ('bb0oym3', '2026-01-01', '2026-01-01', 'NA-01/2026', 'Naskah Akademik Ranperda Pajak Daerah', '0psmwuy', 'Tim Biro Hukum', '2026-03-10', 'Selesai'),
  ('611mdb9', '2026-01-01', '2026-01-01', 'NA-02/2026', 'Naskah Akademik Ranperda Penyelenggaraan Pendidikan', 'ocfwzia', 'Tim Biro Hukum', '2026-06-18', 'Berjalan');

insert into public.dim (id, dibuat, diubah, kode, nama, ranperda, pasal, jenis, status) values
  ('t2da8xc', '2026-01-01', '2026-01-01', 'DIM-01/RAN-01', 'Ketentuan umum objek pajak', '0psmwuy', 'Pasal 1', 'Perubahan', 'Selesai'),
  ('c6u3zz3', '2026-01-01', '2026-01-01', 'DIM-02/RAN-01', 'Tarif dan tata cara pembayaran', '0psmwuy', 'Pasal 7', 'Penambahan', 'Berjalan'),
  ('x4471gt', '2026-01-01', '2026-01-01', 'DIM-01/RAN-02', 'Tanggung jawab pemerintah daerah', 'ocfwzia', 'Pasal 4', 'Tetap', 'Draft');

insert into public.harmonisasi (id, dibuat, diubah, kode, nama, ranperda, tanggal, catatan, status) values
  ('j5rgdsm', '2026-01-01', '2026-01-01', 'HRM-2026-01', 'Harmonisasi Ranperda Pajak Daerah', '0psmwuy', '2026-09-08', 'Penyesuaian rujukan undang-undang dan peraturan pemerintah', 'Selesai'),
  ('ik543ek', '2026-01-01', '2026-01-01', 'HRM-2026-02', 'Harmonisasi Ranperda Penyelenggaraan Pendidikan', 'ocfwzia', '2026-10-15', 'Menunggu draf DIM lengkap', 'Berjalan');

insert into public.jdih (id, dibuat, diubah, kode, nama, regulasi, jenis, status) values
  ('c14gkzs', '2026-01-01', '2026-01-01', 'JDIH-2021-057', 'Kedudukan, susunan organisasi, tugas dan fungsi Sekretariat DPRD', 'od0w57k', 'Perbup', 'Selesai'),
  ('9l4leaq', '2026-01-01', '2026-01-01', 'JDIH-PP-2018-012', 'Tata Tertib DPRD', 'hhpne1b', 'Peraturan Pemerintah', 'Selesai'),
  ('z8yuvc9', '2026-01-01', '2026-01-01', 'JDIH-PERDA-2026-01', 'Perda Pajak Daerah', null, 'Perda', 'Draft');

insert into public.kua (id, dibuat, diubah, kode, nama, tahun, pagu, tanggal, status) values
  ('1cjgane', '2026-01-01', '2026-01-01', 'KUA-2026', 'KUA Sekretariat DPRD 2026', 2026, 28500000000, '2025-07-10', 'Selesai'),
  ('pftocby', '2026-01-01', '2026-01-01', 'KUA-2027', 'KUA Sekretariat DPRD 2027', 2027, 30200000000, '2026-07-15', 'Berjalan');

insert into public.ppas (id, dibuat, diubah, kode, nama, kua, tahun, pagu, tanggal, status) values
  ('5fk3rwj', '2026-01-01', '2026-01-01', 'PPAS-2026', 'PPAS Sekretariat DPRD 2026', '1cjgane', 2026, 28500000000, '2025-08-20', 'Selesai'),
  ('u1n8j0e', '2026-01-01', '2026-01-01', 'PPAS-2027', 'PPAS Sekretariat DPRD 2027 (sementara)', 'pftocby', 2027, 30200000000, '2026-08-25', 'Berjalan');

insert into public.apbd (id, dibuat, diubah, kode, nama, ppas, tahun, pagu, tanggal, status) values
  ('bjg4ebh', '2026-01-01', '2026-01-01', 'Perda 2/2024', 'Anggaran DPRD dalam APBD 2025', null, 2025, 27000000000, '2024-12-05', 'Selesai'),
  ('qtmbpvr', '2026-01-01', '2026-01-01', 'Perda 3/2025', 'Anggaran DPRD dalam APBD 2026', '5fk3rwj', 2026, 28500000000, '2025-12-01', 'Selesai');

insert into public.apbdp (id, dibuat, diubah, kode, nama, apbd, tahun, pagu, tanggal, status) values
  ('uczqpdn', '2026-01-01', '2026-01-01', 'Perda 2/2026', 'Perubahan anggaran DPRD dalam APBD 2026', 'qtmbpvr', 2026, 29100000000, '2026-09-10', 'Berjalan');

insert into public.lapsemester (id, dibuat, diubah, kode, nama, apbd, periode, realisasi, tanggal, status) values
  ('pwwx13x', '2026-01-01', '2026-01-01', 'LS-2026-I', 'Laporan realisasi anggaran DPRD', 'qtmbpvr', 'Semester I', 13800000000, '2026-07-20', 'Selesai');

insert into public.pertanggungjawaban (id, dibuat, diubah, kode, nama, apbd, tahun, realisasi, tanggal, status) values
  ('esv2pft', '2026-01-01', '2026-01-01', 'Perda 1/2026', 'Pertanggungjawaban anggaran DPRD 2025', 'bjg4ebh', 2025, 26350000000, '2026-06-30', 'Berjalan');

insert into public.monopd (id, dibuat, diubah, kode, nama, opd, tanggal, jumlah_temuan, status) values
  ('fzpeg88', '2026-01-01', '2026-01-01', 'MON-OPD-2026-01', 'Monitoring pelaksanaan program OPD mitra Komisi I', 'Bagian Hukum', '2026-08-12', 2, 'Selesai'),
  ('ptnmfwn', '2026-01-01', '2026-01-01', 'MON-OPD-2026-02', 'Monitoring pelaksanaan program Dinas PUPR', 'Dinas PUPR', '2026-10-05', 4, 'Berjalan');

insert into public.monprogram (id, dibuat, diubah, kode, nama, program, tanggal, capaian, status) values
  ('ifx7q8c', '2026-01-01', '2026-01-01', 'MP-2026-01', 'Monitoring Program Pelayanan Administrasi Perkantoran', 'qbbprdz', '2026-07-22', 88, 'Berjalan'),
  ('8c4cb23', '2026-01-01', '2026-01-01', 'MP-2026-02', 'Monitoring Program Penyediaan Layanan Dewan', 'zbudo71', '2026-09-14', 81, 'Berjalan');

insert into public.monproyek (id, dibuat, diubah, kode, nama, kegiatan, lokasi, pagu, progres, status) values
  ('u9frckh', '2026-01-01', '2026-01-01', 'PRJ-2026-03', 'Rehabilitasi ruang rapat komisi', 'e4yuo92', 'Gedung DPRD lantai 2', 450000000, 72, 'Berjalan'),
  ('41rzvij', '2026-01-01', '2026-01-01', 'PRJ-2026-04', 'Pengadaan sistem informasi persidangan', 'e4yuo92', 'Gedung DPRD', 310000000, 100, 'Selesai');

insert into public.lkpj (id, dibuat, diubah, kode, nama, tahun, opd, tanggal, status) values
  ('73d39mb', '2026-01-01', '2026-01-01', 'LKPJ-2025-01', 'Dokumen LKPJ tahun 2025 (bahan pembahasan DPRD)', 2025, 'Sekretariat DPRD', '2026-05-20', 'Selesai'),
  ('sicm0uj', '2026-01-01', '2026-01-01', 'LKPJ-2025-02', 'Dokumen LKPJ tahun 2025 Dinas Pendidikan', 2025, 'Dinas Pendidikan', '2026-05-28', 'Berjalan');

insert into public.temuan (id, dibuat, diubah, kode, nama, proyek, jenis, nilai, status) values
  ('wrkf7yb', '2026-01-01', '2026-01-01', 'TMN-01/2026', 'Volume pekerjaan kurang dari kontrak', 'u9frckh', 'Volume', 24500000, 'Dalam Tindak Lanjut'),
  ('cxev78y', '2026-01-01', '2026-01-01', 'TMN-02/2026', 'Dokumen serah terima belum lengkap', '41rzvij', 'Administrasi', 0, 'Selesai');

insert into public.rekomendasi (id, dibuat, diubah, kode, nama, temuan, tenggat, status) values
  ('6bilovt', '2026-01-01', '2026-01-01', 'REK-01/2026', 'Menyetorkan kelebihan volume ke kas daerah', 'wrkf7yb', '2026-12-31', 'Berjalan'),
  ('tbpy3vw', '2026-01-01', '2026-01-01', 'REK-02/2026', 'Melengkapi dokumen serah terima', 'cxev78y', '2026-10-15', 'Selesai');

insert into public.tindaklanjut (id, dibuat, diubah, kode, nama, rekomendasi, tanggal, status) values
  ('85lmiod', '2026-01-01', '2026-01-01', 'TL-01/2026', 'Surat pernyataan kesanggupan menyetor kelebihan volume', '6bilovt', '2026-10-10', 'Berjalan');

insert into public.reses (id, dibuat, diubah, kode, nama, anggota, dapil, tanggal, peserta, status) values
  ('skbeqw1', '2026-01-01', '2026-01-01', 'RSS-2026-I-01', 'Reses masa sidang I di Kecamatan Putussibau', 'vdctt8i', 'Dapil III', '2026-03-10', 86, 'Selesai'),
  ('nhrryea', '2026-01-01', '2026-01-01', 'RSS-2026-II-02', 'Reses masa sidang II di Kecamatan Embaloh Hulu', 'r2hkil7', 'Dapil II', '2026-10-02', 64, 'Berjalan');

insert into public.pokir (id, dibuat, diubah, kode, nama, anggota, dapil, usulan, status) values
  ('dniooe4', '2026-01-01', '2026-01-01', 'PKR-2026-001', 'Perbaikan jalan usaha tani Desa Lanjak', '8o82m40', 'Dapil I', 750000000, 'Masuk APBD'),
  ('a3g3rgh', '2026-01-01', '2026-01-01', 'PKR-2026-002', 'Pengadaan alat belajar sekolah dasar', 'crj0g6g', 'Dapil II', 420000000, 'Disinkronkan'),
  ('o6mdx85', '2026-01-01', '2026-01-01', 'PKR-2026-003', 'Pembangunan jembatan gantung', 'vdctt8i', 'Dapil III', 1200000000, 'Diusulkan');

insert into public.hearing (id, dibuat, diubah, kode, nama, komisi, narasumber, tanggal, status) values
  ('2wzggbw', '2026-01-01', '2026-01-01', 'HR-2026-04', 'Hearing rancangan kebijakan pendidikan', 'ug1lpcw', 'Dinas Pendidikan', '2026-10-14', 'Selesai'),
  ('1jmcn7d', '2026-01-01', '2026-01-01', 'HR-2026-05', 'Hearing penanganan banjir musiman', 'n7asj1c', 'Dinas PUPR', '2026-11-04', 'Draft');

insert into public.audiensi (id, dibuat, diubah, kode, nama, penerima, tanggal, tuntutan, status) values
  ('7uuvhrn', '2026-01-01', '2026-01-01', 'AUD-2026-031', 'Kelompok tani Desa Lanjak', 'vkpomuc', '2026-09-18', 'Permohonan dukungan perbaikan irigasi', 'Selesai'),
  ('s9jokhg', '2026-01-01', '2026-01-01', 'AUD-2026-032', 'Paguyuban pedagang pasar Putussibau', 'r2hkil7', '2026-10-21', 'Permohonan penataan lapak', 'Berjalan');

insert into public.aspirasidigital (id, dibuat, diubah, kode, nama, kanal, dapil, tanggal, status) values
  ('9r1929v', '2026-01-01', '2026-01-01', 'ASP-2026-1101', 'Usulan lampu jalan di Desa Nanga Badau', 'Portal Web', 'Dapil I', '2026-10-16', 'Berjalan'),
  ('06cpe9n', '2026-01-01', '2026-01-01', 'ASP-2026-1102', 'Keluhan layanan air bersih', 'Aplikasi', 'Dapil II', '2026-10-19', 'Draft');

insert into public.pengaduan (id, dibuat, diubah, kode, nama, kanal, unit, tenggat, status) values
  ('q9bflh3', '2026-01-01', '2026-01-01', 'PGD-2026-0412', 'Jalan rusak di Kecamatan Bunut Hilir', 'Surat', 'Dinas PUPR', '2026-11-30', 'Berjalan'),
  ('6dp3vfc', '2026-01-01', '2026-01-01', 'PGD-2026-0398', 'Keterlambatan pembayaran honor tenaga kebersihan', 'Langsung', 'Bagian Umum dan Keuangan', '2026-10-10', 'Terlambat');

insert into public.berita (id, dibuat, diubah, kode, nama, kategori, penulis, tanggal, status) values
  ('w1pep0w', '2026-01-01', '2026-01-01', 'BRT-2026-101', 'Rapat paripurna pembukaan masa sidang I 2026 berlangsung', 'Persidangan', 'Tim Humas', '2026-02-02', 'Selesai'),
  ('vd2e7ad', '2026-01-01', '2026-01-01', 'BRT-2026-188', 'Komisi I dorong pembahasan Ranperda Pajak Daerah', 'Legislasi', 'Tim Humas', '2026-10-21', 'Berjalan'),
  ('01o5w1t', '2026-01-01', '2026-01-01', 'BRT-2026-190', 'Reses II sampaikan aspirasi warga Embaloh Hulu', 'Aspirasi', 'Tim Humas', '2026-10-22', 'Draft');

insert into public.publikasi (id, dibuat, diubah, kode, nama, jenis, kanal, tanggal, status) values
  ('cz8vhmy', '2026-01-01', '2026-01-01', 'PUB-2026-03', 'Infografis capaian legislasi triwulan III', 'Infografis', 'Media Sosial', '2026-10-10', 'Selesai'),
  ('ryyp111', '2026-01-01', '2026-01-01', 'PUB-2026-04', 'Laporan kinerja DPRD tahun 2025', 'Laporan Tahunan', 'Website', '2026-06-30', 'Selesai'),
  ('mrj3rzq', '2026-01-01', '2026-01-01', 'PUB-2026-05', 'Buletin edisi Oktober', 'Buletin', 'Website', '2026-11-01', 'Draft');

insert into public.dokumentasi (id, dibuat, diubah, kode, nama, kegiatan, jumlah, tanggal, status) values
  ('g5nlu8f', '2026-01-01', '2026-01-01', 'DOK-2026-0210', 'Foto dan video rapat paripurna pembukaan masa sidang I', 'jt73ku5', 148, '2026-02-02', 'Selesai'),
  ('gblpna4', '2026-01-01', '2026-01-01', 'DOK-2026-0211', 'Dokumentasi rapat konsultasi Ranperda pajak', 'f8qjqbw', 52, '2026-10-23', 'Berjalan');

insert into public.mediamon (id, dibuat, diubah, kode, nama, media, sentimen, tanggal, status) values
  ('rpyw42d', '2026-01-01', '2026-01-01', 'MM-2026-1021', 'Pemberitaan pembahasan Ranperda Pajak Daerah', 'Media Daring Lokal', 'Netral', '2026-10-21', 'Selesai'),
  ('b4je2s5', '2026-01-01', '2026-01-01', 'MM-2026-1022', 'Keluhan warga soal jalan rusak Bunut Hilir', 'Media Sosial', 'Negatif', '2026-10-22', 'Berjalan');

insert into public.protokoler (id, dibuat, diubah, kode, nama, tamu, jenis, tanggal, status) values
  ('l1useii', '2026-01-01', '2026-01-01', 'PRT-2026-07', 'Penerimaan delegasi studi banding DPRD', 'Delegasi DPRD Kabupaten Sintang', 'Penerimaan Delegasi', '2026-11-06', 'Draft'),
  ('m2t38xz', '2026-01-01', '2026-01-01', 'PRT-2026-08', 'Upacara peringatan hari jadi kabupaten', 'Bupati dan Forkopimda', 'Upacara', '2026-10-14', 'Selesai');

