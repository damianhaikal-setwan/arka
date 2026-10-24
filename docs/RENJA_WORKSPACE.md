# Renja Workspace — desain dan kontrak data

## Tujuan

Satu halaman kerja menyatukan identitas dokumen Renja, Program, Kegiatan, Subkegiatan, validasi, rekap, dan pratinjau/cetak T-C.33. Pengguna membuat data rencana sekali; modul monitoring/evaluasi seharusnya mengonsumsi referensi data yang sama, bukan meminta penginputan struktur yang sama lagi.

## Hierarki

`renja` → `program` → `kegiatan` → `subkegiatan`

Rincian menyimpan `renja_ref` dan tahun. Kegiatan menunjuk `program`; Subkegiatan menunjuk `kegiatan`. Backend menolak dokumen induk yang berbeda, tahun yang tidak cocok, serta perubahan tahun Renja setelah detail tertaut.

## Prinsip data

- Identitas rinci tetap terpisah; satu halaman UI tidak berarti satu tabel database.
- Record lama yang belum ditautkan tampil sebagai orphan dan tidak masuk rekap sampai operator memverifikasi referensinya.
- Pagu tidak dijumlahkan sekaligus pada induk dan anak. Rekap dasar menggunakan tingkat terdalam yang tersedia pada setiap cabang.
- T-C.33 adalah keluaran turunan. Sebelum dijadikan dokumen resmi, cocokkan nomenklatur, header, satuan, sumber data, dan instruksi pengisian yang berlaku.
- Trigger validasi skema bukan pengganti RLS. Uji hak baca/tulis pada role yang sebenarnya.

## Pemetaan T-C.33

Workspace memetakan kode; urusan/bidang dan nomenklatur Program/Kegiatan/Subkegiatan; indikator; lokasi; target; pagu; sumber dana; catatan penting; target prakiraan maju; serta pagu prakiraan maju. Ketersediaan dan kelengkapan setiap field perlu divalidasi sebelum dokumen dinyatakan final.

## Status komponen

- Workspace UI, tab internal, CRUD dan pemeriksaan relasi dasar: kandidat telah diuji di browser lokal.
- Migrasi awal dan guardrails Supabase: ditinjau secara statis; tetap perlu dijalankan dan diuji pada project Supabase target. Guardrails memperbaiki status `Draft`, menambahkan FK `renja_ref` `NOT VALID`, dan mencegah penghapusan Renja yang masih dirujuk.
- RLS, persistensi end-to-end, audit database, snapshot publikasi, serta semua derivasi ke modul monitoring/evaluasi: perlu pengujian/integrasi lanjut sebelum klaim siap produksi.

- Cetak T-C.33 diblokir bila ditemukan kesalahan relasi/tahun atau pagu induk berbeda dari total anak langsung. Ini adalah fail-closed sementara sampai jenis pagu subtotal versus alokasi langsung dimodelkan eksplisit.

- Snapshot ini belum memperlihatkan subscription Supabase Realtime atau optimistic locking per record; kedua fitur harus diimplementasikan dan diuji terpisah sebelum mengandalkan konsistensi lintas pengguna.
