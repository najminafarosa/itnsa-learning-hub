===== CARA MENJALANKAN SCRIPT =====
# 1. Berikan izin eksekusi agar kedua script bisa dijalankan oleh sistem
chmod +x mount_disk.sh rollback_mount.sh

# 2. Jalankan Script Utama untuk mulai memasang disk secara otomatis
sudo ./mount_disk.sh

# 3. JALANKAN PERINTAH DI BAWAH INI HANYA JIKA TERJADI KESALAHAN ATAU INGIN MEMBATALKAN:
# (Script ini akan menghapus auto-mount dan mengembalikan fstab seperti semula)
sudo ./rollback_mount.sh

Penjelasan Singkat Perintah di Atas:
chmod +x: Mengubah status file dari dokumen teks biasa menjadi program (script) yang bisa dieksekusi oleh sistem Linux.
sudo: Memberikan hak akses administrator karena proses pembuatan folder sistem dan pengeditan file /etc/fstab wajib membutuhkan izin keamanan penuh.
