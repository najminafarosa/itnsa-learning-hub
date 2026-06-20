echo " === Memulai proses Rollback === "
echo "Mengembalikan ke konfigurasi semula.."
sudo cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config

echo "Default konfigurai berhasil dikembalikan"
echo " === Proses Rollback selesai === "

