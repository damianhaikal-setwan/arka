# Release notes — Renja Workspace candidate

## Perubahan

- Workspace khusus Renja diintegrasikan dengan navigasi domain Perencanaan.
- Tab Identitas Renja, Program, Kegiatan, Subkegiatan, dan Rekap & T-C.33 tersedia pada satu ruang kerja.
- Formulir rincian menyediakan referensi dokumen Renja dan induk sesuai level hierarki.
- Validasi dasar memeriksa hubungan Renja–Program–Kegiatan–Subkegiatan serta kecocokan tahun.
- Rekap pagu dasar memilih level terdalam per cabang agar pagu induk dan anak tidak dihitung dua kali.
- Pratinjau dan cetak T-C.33 berisi kolom rencana dan prakiraan maju.
- SQL migrasi menambah kolom, indeks, dan trigger validasi tanpa menghapus atau auto-link data lama.

## Batasan yang diketahui

- Belum dibandingkan terhadap branch/commit GitHub tujuan karena koneksi/isi repository belum tersedia dalam sesi ini. Karena itu file kandidat belum dipastikan sebagai pengganti langsung entrypoint repo.
- Migrasi belum diuji pada database salinan project Supabase pengguna pada saat paket ini dibuat.
- Migrasi tidak membuat katalog nomenklatur nasional mandiri; validitas kode/periode saat ini bertumpu pada field pada record dan perlu diselaraskan dengan master yang resmi.
- RLS/policy tidak diubah.
- Snapshot versi publikasi dan audit trail server yang konsisten perlu diverifikasi/dituntaskan sebelum produksi.
- T-C.33 masih perlu direkonsiliasi dengan formulir/template resmi yang berlaku pada perangkat daerah.


## Baseline review patch (belum diterapkan ke Supabase produksi)

- Repository entry point ditegaskan sebagai `index.html`; README dan test tidak lagi mengasumsikan `app/`.
- Migrasi guardrails memperbaiki check status `Program`/`Kegiatan` agar menerima `Draft`, menambah FK `renja_ref` dengan validasi historis ditangguhkan, serta mencegah penghapusan dokumen Renja yang masih dirujuk.
- Pemeriksaan orphan juga mencakup `renja_ref` yang tidak kosong tetapi menunjuk dokumen yang hilang.
- Cetak T-C.33 ditolak sementara ketika ada kesalahan relasi/tahun atau mismatch pagu subtotal. Aturan pagu langsung vs subtotal belum dimodelkan, sehingga fail-closed dipilih untuk mengurangi risiko laporan menyesatkan.
- Belum ada pengujian eksekusi SQL pada PostgreSQL/Supabase, RLS live, Realtime, maupun konflik edit multi-pengguna.
