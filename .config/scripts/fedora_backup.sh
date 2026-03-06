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
