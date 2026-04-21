# Bootstrap Configuration Directory

Installation scripts and documentation for system services.

## Paperless-ngx

**Documentation:** `PAPERLESS.md`

**Quick Start:**
```bash
# Add documents
paperless-add ~/Downloads/invoice.pdf

# Access web interface
http://localhost:8000

# Manage containers
~/.config/paperless-ngx/start.sh
~/.config/paperless-ngx/stop.sh
~/.config/paperless-ngx/logs.sh
```

## Directory Structure

```
~/.config/bootstrap/
├── README.md            # This file
├── PAPERLESS.md         # Paperless-ngx documentation
├── install-paperless-ngx.sh
└── validate-paperless-ngx.sh
```
