# Paperless-ngx

Document management system running on Podman with XDG directory structure.

## Access

- **Web**: http://localhost:8000
- **User**: admin
- **Password**: See `~/.config/paperless-ngx/.env`

## Quick Commands

```bash
# Add documents
paperless-add ~/Downloads/invoice.pdf

# Start/Stop
~/.config/paperless-ngx/start.sh
~/.config/paperless-ngx/stop.sh

# Logs & Backup
~/.config/paperless-ngx/logs.sh
~/.config/paperless-ngx/backup.sh
```

## Directory Structure

```
~/Documents/paperless-ngx/       # Your documents
├── consume/                     # Drop files here (use paperless-add)
├── media/                       # Processed documents
└── export/                      # Exports

~/.config/paperless-ngx/         # Configuration & scripts
├── docker-compose.yml
├── .env                         # Secrets (600 permissions)
└── *.sh                         # Management scripts

~/.local/share/paperless-ngx/    # App data (database, cache)
~/.local/state/paperless-ngx/    # Logs
```

## Setup Notes

### Volume Labels (SELinux + Podman Rootless)

- **consume** and **export**: `:U,z` flags (host writes, container reads)
- **media**, **data**, **pgdata**, etc: `:Z` flag (container-only)

### User Mapping

```yaml
environment:
  USERMAP_UID: 1000
  USERMAP_GID: 1000
```

This allows the container to run as your UID/GID for proper file permissions with SELinux.

### Adding Documents

**Always use `paperless-add` script** (not manual copy):

```bash
paperless-add ~/Downloads/file.pdf
```

The script uses `podman unshare` to handle SELinux contexts and ownership:

```bash
podman unshare sh -c "
    cat 'source-file' > 'consume-folder/filename'
    chown 1000:1000 'consume-folder/filename'
    chmod 666 'consume-folder/filename'
"
```

Direct file copying fails due to SELinux/user namespace requirements.

## Management

```bash
cd ~/.config/paperless-ngx

# Status
podman-compose ps

# Restart
podman-compose restart

# Restart single service
podman-compose restart webserver

# Full restart
podman-compose down && podman-compose up -d
```

## Troubleshooting

### Permission Issues

```bash
# Check volume ownership
ls -laZ ~/Documents/paperless-ngx/consume/

# Container won't start
podman logs paperless-ngx_webserver_1
podman logs paperless-ngx_db_1

# Reset (deletes all data!)
cd ~/.config/paperless-ngx
podman-compose down
podman unshare rm -rf ~/.local/share/paperless-ngx/{data,pgdata,redisdata}
mkdir -p ~/.local/share/paperless-ngx/{data,pgdata,redisdata}
podman-compose up -d
```

### Documents Not Processing

```bash
# Check consumer logs
podman logs paperless-ngx_webserver_1 | grep -i consumer

# Wait time
Documents auto-process every 60 seconds
```

## Backup & Restore

```bash
# Backup (saved to ~/paperless-backups/)
~/.config/paperless-ngx/backup.sh

# Restore
cd ~/.config/paperless-ngx
podman-compose down
rsync -av /backup/documents/ ~/Documents/paperless-ngx/
cat /backup/database.sql | podman exec -i paperless-ngx_db_1 psql -U paperless paperless
podman-compose up -d
```

## Upgrade

```bash
cd ~/.config/paperless-ngx
./backup.sh
podman-compose pull
podman-compose up -d --force-recreate
```

## Key Configuration

**docker-compose.yml services:**
- webserver (paperless app)
- db (PostgreSQL)
- broker (Redis)
- gotenberg (PDF conversion)
- tika (document parsing)

**.env important variables:**
```bash
PAPERLESS_ADMIN_USER=admin
PAPERLESS_ADMIN_PASSWORD=your_password
PAPERLESS_SECRET_KEY=auto_generated
TZ=America/New_York
USERMAP_UID=1000
USERMAP_GID=1000
```

## Resources

- Docs: https://docs.paperless-ngx.com/
- GitHub: https://github.com/paperless-ngx/paperless-ngx
