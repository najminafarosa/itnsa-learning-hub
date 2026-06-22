#!/bin/bash

echo "=== SCRIPT DIJALANKAN ==="
FILE="$HOME/.ssh/id_ed25519"
read -p "Masukan Username remote: " USER
read -p "Masukan IP Target/Host: " IP_HOST
if [ ! -f "$FILE" ]; then
	echo "Memulai pembuatan ssh-key.."
	ssh-keygen -t ed25519 -N "" -f "$FILE"
	echo "Key berhasil dibuat!"
	echo "Disimpan di ~/.ssh/"
else
	echo "Sudah terdapat key ssh yang pernah dibuat"
	echo "Menghentikan proses.."
fi

echo "Memulai penyalinan ke HOST/Target.."
echo "Menyalin SSH Key ke $USER@$IP_HOST.."
ssh-copy-id "$USER@$IP_HOST"

if [ $? -eq 0 ]; then
	echo "==========================="
	echo "Sukses! SSH Key berhasil disalin."
	echo "Login dengan: $USER@$IP_HOST"
else
	echo "Gagal menyalin SSH Key, periksa IP dan Password"
fi

echo "=== SCRIPT DIHENTIKAN ==="


