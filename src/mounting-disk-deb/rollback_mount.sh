#!/bin/bash

# ====================================================================
# KONFIGURASI - SAMAKAN DENGAN SCRIPT UTAMA
# ====================================================================
MOUNT_POINT="/mnt/data"
# ====================================================================

if [ "$EUID" -ne 0 ]; then
  echo "❌ Error: Harap jalankan script ini dengan sudo! (Contoh: sudo ./rollback_mount.sh)"
  exit 1
fi

echo "🔄 Memulai proses rollback (pembatalan)..."

# 1. Lepas disk yang sedang terpasang
echo "⏏️  Melepas disk dari $MOUNT_POINT..."
umount "$MOUNT_POINT" 2>/dev/null

# 2. Kembalikan file fstab asli jika ada file cadangan .bak
if [ -f /etc/fstab.bak ]; then
  echo "💾 Mengembalikan file /etc/fstab dari cadangan asli..."
  cp /etc/fstab.bak /etc/fstab
  rm /etc/fstab.bak
  echo "🗑️  File cadangan lama telah dihapus."
else
  echo "⚠️  File cadangan /etc/fstab.bak tidak ditemukan!"
  echo "📝 Silakan hapus baris tambahan di /etc/fstab secara manual menggunakan: sudo nano /etc/fstab"
fi

# 3. Hapus folder tujuan jika kosong
if [ -d "$MOUNT_POINT" ]; then
  if [ -z "$(ls -A "$MOUNT_POINT")" ]; then
    echo "📁 Menghapus folder kosong $MOUNT_POINT..."
    rmdir "$MOUNT_POINT"
  else
    echo "⚠️  Folder $MOUNT_POINT tidak dihapus karena masih berisi file lain."
  fi
fi

echo "✅ ROLLBACK SELESAI! Semua perubahan telah dibersihkan."
