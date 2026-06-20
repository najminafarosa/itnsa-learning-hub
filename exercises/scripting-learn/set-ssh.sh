#!/bin/bash

FILE_CONFIG="/etc/ssh/sshd_config"
KEYWORD="=== KONFIGURASI OTOMATIS PORT SSH ==="

echo " === START CONFIGURATION === "

if grep -q "$KEYWORD" "$FILE_CONFIG"; then
	echo "Warning: Konfigurasi Port sudah dilakukan"
	echo "Script dihentikan agar tidak terjadi duplikat"
else
	echo " Menulis pengaturan baru.."
	sudo cp "$FILE_CONFIG" "${FILE_CONFIG}.bak"
	sudo sed -i 's/^#\?Port .*/Port 2222/' $FILE_CONFIG
	sudo sh -c "cat << STOP >> $FILE_CONFIG
# === KONFIGURASI OTOMATIS PORT SSH ===
STOP"

	echo "Berhasil Configurasi Port!"
fi

echo " === FINISH CONFIGURATION === "
