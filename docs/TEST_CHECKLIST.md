# Checklist uji penerimaan Renja Workspace

## A. Pra-pengujian
- [ ] Catat branch dan commit repo sebelum menggabungkan perubahan.
- [ ] Simpan salinan HTML yang sedang dipakai dan buat backup Supabase.
- [ ] Jalankan migrasi pada project/branch nonproduksi terlebih dahulu.
- [ ] Jalankan `supabase/verification/verify_renja_workspace.sql` dan simpan hasilnya.

## B. UI dan CRUD
- [ ] Workspace Renja muncul dari navigasi Perencanaan → Renja.
- [ ] Lima tab internal dapat dibuka tanpa menampilkan CRUD lama di atasnya.
- [ ] Pilih dokumen Renja yang benar; tidak ada duplikasi kode dokumen.
- [ ] Tambah Program, simpan, muat ulang; nilai dan `renja_ref` tetap ada.
- [ ] Tambah Kegiatan di bawah Program, simpan, muat ulang; relasi `program` tetap benar.
- [ ] Tambah Subkegiatan di bawah Kegiatan, simpan, muat ulang; relasi `kegiatan` tetap benar.
- [ ] Ubah target/pagu, simpan, muat ulang; perubahan tetap ada.
- [ ] Coba relasi induk dari Renja lain; harus ditolak.
- [ ] Coba tahun anak berbeda dari tahun Renja; harus ditolak.
- [ ] Coba ubah tahun dokumen setelah memiliki detail; harus ditolak.

## C. Integritas dan keluaran
- [ ] Semua orphan terdaftar dan tidak otomatis ditautkan.
- [ ] Pagu hanya dihitung di tingkat terdalam yang tersedia per cabang.
- [ ] Baris induk berisi anak tidak membuat pagu ganda dalam keluaran.
- [ ] T-C.33 memiliki sepuluh elemen keluaran yang dimaksud dan header yang sesuai template resmi.
- [ ] Target/sumber dana/prakiraan maju yang kosong ditandai.
- [ ] Peran operator dan admin diuji terhadap RLS yang berlaku.
- [ ] Uji riwayat audit, publikasi/snapshot, dan perubahan lintas modul sebelum produksi.

## D. Kriteria lulus

Lulus hanya bila CRUD cloud bertahan setelah reload, relasi dan tahun tervalidasi di database (bukan hanya browser), data historis tidak berubah diam-diam, dan keluaran direkonsiliasi terhadap sumber data. Tes UI lokal saja tidak cukup.
