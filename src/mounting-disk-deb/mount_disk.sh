#!/bin/bash

# ====================================================================
# KONFIGURASI - SILAKAN UBAH 3 VARIABEL DI BAWAH INI SESUAI KEBUTUHAN
# ====================================================================
TARGET_DEVICE="/dev/sda1"      # Ubah ke partisi disk Anda (cek pakai lsblk)
MOUNT_POINT="/mnt/data"        # Folder tujuan untuk mount disk
FS_TYPE="ntfs-3g"              # Ubah ke ext4, ntfs-3g, atau vfat sesuai format disk
# ====================================================================

# Pastikan script dijalankan sebagai root (sudo)
if [ "$EUID" -ne 0 ]; then
  echo "❌ Error: Harap jalankan script ini dengan sudo! (Contoh: sudo ./mount_disk.sh)"
  exit 1
fi

echo "🔄 Memulai proses otomasi mounting disk..."

# 1. Cek apakah device yang dituju ada
if [ ! -b "$TARGET_DEVICE" ]; then
  echo "❌ Error: Device $TARGET_DEVICE tidak ditemukan!"
  exit 1
fi

# 2. Ambil UUID disk secara otomatis
DISK_UUID=$(blkid -o value -s UUID "$TARGET_DEVICE")
if [ -z "$DISK_UUID" ]; then
  echo "❌ Error: Gagal mengambil UUID untuk $TARGET_DEVICE"
  exit 1
fi
echo "🔍 Menemukan UUID: $DISK_UUID"

# 3. Buat folder tujuan jika belum ada
if [ ! -d "$MOUNT_POINT" ]; then
  echo "📁 Membuat folder tujuan di $MOUNT_POINT..."
  mkdir -p "$MOUNT_POINT"
fi

# 4. Backup file /etc/fstab asli sebelum diubah (Penting untuk Rollback)
echo "💾 Membuat cadangan file /etc/fstab ke /etc/fstab.bak..."
cp /etc/fstab /etc/fstab.bak

# 5. Siapkan baris konfigurasi berdasarkan format file sistem
if [ "$FS_TYPE" == "ntfs-3g" ] || [ "$FS_TYPE" == "ntfs" ]; then
  FSTAB_LINE="UUID=$DISK_UUID  $MOUNT_POINT  ntfs-3g  defaults,uid=1000,gid=1000,dmask=022,fmask=133  0  2"
else
  FSTAB_LINE="UUID=$DISK_UUID  $MOUNT_POINT  $FS_TYPE  defaults  0  2"
fi

# 6. Masukkan konfigurasi baru ke fstab jika belum terdaftar
if grep -q "$DISK_UUID" /etc/fstab; then
  echo "⚠️  UUID ini sudah terdaftar di /etc/fstab. Melewati langkah penulisan."
else
  echo "📝 Menambahkan disk ke /etc/fstab..."
  echo -e "\n# Automount untuk $TARGET_DEVICE\n$FSTAB_LINE" >> /etc/fstab
fi

# 7. Uji coba mount konfigurasi baru
echo "🔌 Menguji coba pemasangan (mount -a)..."
mount -a

if [ $? -eq 0 ]; then
  echo "✅ BERHASIL! Disk Anda sekarang terpasang di $MOUNT_POINT dan aktif otomatis saat booting."
else
  echo "❌ TERJADI KESALAHAN saat menguji fstab!"
  echo "🔄 Menjalankan pemulihan darurat otomatis..."
  cp /etc/fstab.bak /etc/fstab
  echo "↩️  Sistem telah dikembalikan ke kondisi semula. Silakan periksa kembali konfigurasi Anda."
  exit 1
fi
