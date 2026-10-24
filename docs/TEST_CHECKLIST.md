# Checklist uji penerimaan Renja Workspace

## A. Pra-pengujian
- [ ] Jalankan `node tests/validate-html.mjs` dari root; harus memakai `index.html` tanpa path `app/` yang tidak ada.
- [ ] Catat branch dan commit repo sebelum menggabungkan perubahan.
- [ ] Simpan salinan HTML yang sedang dipakai dan buat backup Supabase.
- [ ] Jalankan migrasi pada project/branch nonproduksi terlebih dahulu.
- [ ] Jalankan `supabase/verification/verify_renja_workspace.sql` dan simpan hasilnya.

## B. UI dan CRUD
- [ ] Workspace Renja muncul dari navigasi Perencanaan → Renja.
- [ ] Lima tab internal dapat dibuka tanpa menampilkan CRUD lama di atasnya.
- [ ] Pilih dokumen Renja yang benar; tidak ada duplikasi kode dokumen.
- [ ] Tambah Program berstatus `Draft`, simpan, muat ulang; constraint database menerima status dan `renja_ref` tetap ada.
- [ ] Tambah Kegiatan berstatus `Draft` di bawah Program, simpan, muat ulang; constraint database menerima status dan relasi `program` tetap benar.
- [ ] Tambah Subkegiatan di bawah Kegiatan, simpan, muat ulang; relasi `kegiatan` tetap benar.
- [ ] Ubah target/pagu, simpan, muat ulang; perubahan tetap ada.
- [ ] Coba relasi induk dari Renja lain; harus ditolak.
- [ ] Coba tahun anak berbeda dari tahun Renja; harus ditolak.
- [ ] Coba ubah tahun dokumen setelah memiliki detail; harus ditolak.
- [ ] Coba hapus dokumen Renja yang masih mempunyai detail; FK harus menolak penghapusan.
- [ ] Coba cetak ketika ada error relasi/tahun atau selisih pagu induk-anak; pencetakan harus diblokir.

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
