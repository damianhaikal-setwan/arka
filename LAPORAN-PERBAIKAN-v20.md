# ARKA v20 — Catatan Perbaikan Incremental

Tanggal: 23 Oktober 2026
Baseline: ARKA v19 (`4bef1621758f0afd5b5560b4c17cd769f0acd543f048a3f37524b7feebbb242d`)
Status: perbaikan frontend dan paket PWA disiapkan; backend produksi belum diverifikasi.

## A. Ringkasan Status
- JavaScript inline: lolos `node --check`.
- Manifest: JSON valid.
- PWA shell/service worker: tersedia dalam paket.
- Tidak ada pengujian koneksi ke proyek Supabase produksi dalam pekerjaan ini.

## B. Perbaikan yang diterapkan
1. **[PERBAIKI] KPI**
   - Pembagian dengan target/pagu nol atau nilai kosong menghasilkan `—`, bukan `Infinity`, `NaN`, atau angka 0 yang menyesatkan.
   - Dashboard berhenti memakai angka KPI hardcoded seperti 12/12, SAKIP 78,5, BMD 100%, SPJ 92%, dan kepuasan 88%.
   - Nilai SAKIP dan BMD tidak ditampilkan sebagai fakta tanpa sumber validasi yang terhubung.
   - Label analitik pengaduan/audiensi/hearing menjelaskan bahwa penyelesaian bukan skor kepuasan.
   - Evidence Center tidak lagi membuat nama laporan, sasaran, atau Renstra sintetis; semua IKU ditandai belum terhubung sampai relasi bukti aktual tersedia.
   - Mode lokal diberi peringatan jelas bahwa data bukan database produksi dan tidak persisten.

2. **[PERBAIKI] Audit trail dan status simpan**
   - Form tidak menutup dan tidak menampilkan sukses sebelum operasi cloud selesai.
   - Jika record berhasil di-upsert tetapi penulisan `audit_log` gagal, aplikasi menjelaskan bahwa data sudah tersimpan namun audit gagal dan melarang pengiriman ulang dari tombol simpan.
   - Penghapusan mencoba menulis audit setelah delete terkonfirmasi; kegagalan audit diberi peringatan eksplisit.
   - Riwayat `audit_log` server dimuat saat login bila policy mengizinkan. Jika SELECT ditolak, aplikasi memberi peringatan dan tidak mengklaim audit server tersedia.
   - Nama pengguna lokal tidak lagi dipalsukan sebagai “Admin Sekwan”.

3. **[PERBAIKI] Otorisasi**
   - Guard frontend yang sudah ada dipertahankan; ini hanya lapisan UX, bukan batas keamanan.
   - **Belum dapat dinyatakan aman** tanpa bukti RLS, policy Storage, profil/peran, dan Edge Function di proyek Supabase sebenarnya.
   - Disertakan checklist validasi backend agar pengujian negatif dilakukan di staging. Tidak ada policy produksi yang ditebak atau diubah.

4. **[KEMBANGKAN] PWA**
   - Ditambahkan `manifest.webmanifest`, ikon SVG, dan `sw.js`.
   - Cache hanya untuk shell/skrip statis; endpoint Supabase Auth/REST/Storage/Functions tidak di-cache.
   - Saat offline, penyimpanan cloud ditolak dengan pesan eksplisit. Tidak ada antrean tulis offline/sinkronisasi otomatis.

## C. Risiko tersisa
- Upsert record dan insert audit masih dua operasi berbeda dari browser; keduanya belum atomik. Solusi produksi yang benar adalah database trigger atau RPC transaksi yang diuji pada skema sebenarnya.
- Audit log masih bergantung pada hak INSERT/SELECT yang diberikan policy database.
- Otorisasi Storage dan Edge Function belum diuji.
- Penghapusan yang diikuti kegagalan audit tetap menghasilkan kondisi parsial (record terhapus, audit gagal); UI memberi peringatan, tetapi perlu mekanisme transaksi server untuk menutup celah ini.
- PWA memerlukan HTTPS dan deploy semua berkas dalam direktori yang sama. PWA tidak menjamin operasi CRUD offline.

## D. Pengujian yang dijalankan
- `node --check` pada JavaScript inline: PASS.
- Parsing `manifest.webmanifest`: PASS.
- Referensi manifest dan service worker: PASS.
- Pengecualian endpoint Supabase dari cache: PASS.
- Penghapusan label evidence sintetis: PASS.
- Guard pembagian dengan denominator nol: PASS.

## E. Yang belum diklaim
- Belum dilakukan uji browser/device installability.
- Belum dilakukan CRUD end-to-end di Supabase produksi.
- Belum dibuktikan bahwa RLS/Storage/Edge Function aman.
- Belum dibuat sinkronisasi offline.
