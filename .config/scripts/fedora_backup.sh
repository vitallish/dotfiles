# RESTORE INSTRUCTIONS (run from a Fedora live USB):
#
#   1. Mount your root partition:
#        sudo mount /dev/nvme0n1p3 /mnt/sysroot
#
#   2. Mount the backup drive:
#        sudo mount /dev/sda1 /mnt/backup
#
#   3. Restore with rsync:
#        sudo rsync -aAXHvS --delete \
#          --exclude='/dev/*' --exclude='/proc/*' --exclude='/sys/*' \
#          /mnt/backup/fedora-root-backup/ /mnt/sysroot/
#
#   4. Recreate missing pseudo-fs mountpoints if needed:
#        sudo mkdir -p /mnt/sysroot/{dev,proc,sys,tmp,run}
#
#   5. Reinstall the bootloader (if it was affected):
#        sudo arch-chroot /mnt/sysroot
#        grub2-install /dev/nvme0n1
#        grub2-mkconfig -o /boot/grub2/grub.cfg
#        exit

mountpoint -q /mnt/internal_backup || { echo "ERROR: /mnt/internal_backup is not mounted. Aborting."; exit 1; }

sudo rsync -aAXHvS --progress \
  --delete \
  --log-file=/var/log/fedora-root-backup-$(date +%Y%m%d).log \
  --exclude='/dev/*' \
  --exclude='/proc/*' \
  --exclude='/sys/*' \
  --exclude='/tmp/*' \
  --exclude='/run/*' \
  --exclude='/mnt/*' \
  --exclude='/media/*' \
  --exclude='/lost+found' \
  --exclude='/home/*' \
  --exclude='/var/tmp/*' \
  --exclude='/var/cache/*' \
  --exclude='/swapfile' \
  --exclude='/.snapshots' \
  / /mnt/internal_backup/fedora-root-backup/
