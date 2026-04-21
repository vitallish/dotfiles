#!/bin/bash
set -e

# =============================================================================
# Paperless-ngx Installation Script
# =============================================================================
# This script installs and configures paperless-ngx with:
# - XDG Base Directory compliance
# - Podman/Docker Compose setup
# - Proton Mail Bridge email consumption
# - SELinux support for Fedora/RHEL
# =============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# =============================================================================
# Configuration Variables
# =============================================================================

# Directories following XDG Base Directory specification
CONFIG_DIR="${HOME}/.config/paperless-ngx"
DATA_DIR="${HOME}/.local/share/paperless-ngx"
LOG_DIR="${HOME}/.local/state/paperless-ngx"
DOCUMENTS_DIR="${HOME}/Documents/paperless-ngx"

# =============================================================================
# Prerequisite Checks
# =============================================================================

check_prerequisites() {
    log_info "Checking prerequisites..."

    # Check for podman-compose or docker-compose
    if ! command -v podman-compose &> /dev/null && ! command -v docker-compose &> /dev/null; then
        log_error "Neither podman-compose nor docker-compose found!"
        log_error "Please install one of them first:"
        log_error "  Fedora: sudo dnf install podman-compose"
        log_error "  Ubuntu: sudo apt install docker-compose"
        exit 1
    fi

    # Determine which compose command to use
    if command -v podman-compose &> /dev/null; then
        COMPOSE_CMD="podman-compose"
        CONTAINER_CMD="podman"
        log_success "Using podman-compose"
    else
        COMPOSE_CMD="docker-compose"
        CONTAINER_CMD="docker"
        log_success "Using docker-compose"
    fi

    # Check for openssl (for generating secrets)
    if ! command -v openssl &> /dev/null; then
        log_error "openssl not found! Please install it first."
        exit 1
    fi

    log_success "All prerequisites met"
}

# =============================================================================
# Directory Structure Creation
# =============================================================================

create_directories() {
    log_info "Creating XDG-compliant directory structure..."

    # Configuration directory
    mkdir -p "${CONFIG_DIR}"

    # Documents directories
    mkdir -p "${DOCUMENTS_DIR}"/{consume,media,export}

    # Application data directories
    mkdir -p "${DATA_DIR}"/{data,pgdata,redisdata}

    # Log directory
    mkdir -p "${LOG_DIR}"

    log_success "Directory structure created:"
    log_info "  Documents:     ${DOCUMENTS_DIR}"
    log_info "  Configuration: ${CONFIG_DIR}"
    log_info "  App Data:      ${DATA_DIR}"
    log_info "  Logs:          ${LOG_DIR}"
}

# =============================================================================
# User Input Collection
# =============================================================================

collect_user_input() {
    log_info "Collecting configuration information..."
    echo ""

    # Admin username
    read -p "Admin username [admin]: " ADMIN_USER
    ADMIN_USER=${ADMIN_USER:-admin}

    # Admin password
    while true; do
        read -s -p "Admin password (leave blank to auto-generate): " ADMIN_PASSWORD
        echo ""
        if [ -z "$ADMIN_PASSWORD" ]; then
            ADMIN_PASSWORD=$(openssl rand -base64 16)
            log_warning "Auto-generated admin password: ${ADMIN_PASSWORD}"
            log_warning "Please save this password!"
            break
        fi
        read -s -p "Confirm admin password: " ADMIN_PASSWORD_CONFIRM
        echo ""
        if [ "$ADMIN_PASSWORD" = "$ADMIN_PASSWORD_CONFIRM" ]; then
            break
        else
            log_error "Passwords do not match. Please try again."
        fi
    done

    # Timezone
    SYSTEM_TZ=$(timedatectl show --property=Timezone --value 2>/dev/null || echo "America/New_York")
    read -p "Timezone [${SYSTEM_TZ}]: " TIMEZONE
    TIMEZONE=${TIMEZONE:-$SYSTEM_TZ}

    # Email consumption
    read -p "Configure email consumption? (y/N): " CONFIGURE_EMAIL
    CONFIGURE_EMAIL=${CONFIGURE_EMAIL:-N}

    if [[ "$CONFIGURE_EMAIL" =~ ^[Yy]$ ]]; then
        ENABLE_EMAIL=true

        # Email provider selection
        echo ""
        echo "Email provider:"
        echo "  1) Proton Mail Bridge (local)"
        echo "  2) Gmail"
        echo "  3) Outlook/Office 365"
        echo "  4) Custom IMAP"
        read -p "Select [1]: " EMAIL_PROVIDER_CHOICE
        EMAIL_PROVIDER_CHOICE=${EMAIL_PROVIDER_CHOICE:-1}

        case $EMAIL_PROVIDER_CHOICE in
            1)
                EMAIL_HOST="127.0.0.1"
                EMAIL_PORT="1143"
                EMAIL_USE_SSL="false"
                EMAIL_USE_TLS="true"
                ;;
            2)
                EMAIL_HOST="imap.gmail.com"
                EMAIL_PORT="993"
                EMAIL_USE_SSL="true"
                EMAIL_USE_TLS="false"
                log_warning "Gmail requires app-specific password!"
                ;;
            3)
                EMAIL_HOST="outlook.office365.com"
                EMAIL_PORT="993"
                EMAIL_USE_SSL="true"
                EMAIL_USE_TLS="false"
                ;;
            4)
                read -p "IMAP host: " EMAIL_HOST
                read -p "IMAP port [993]: " EMAIL_PORT
                EMAIL_PORT=${EMAIL_PORT:-993}
                read -p "Use SSL? (Y/n): " USE_SSL
                if [[ "$USE_SSL" =~ ^[Nn]$ ]]; then
                    EMAIL_USE_SSL="false"
                    EMAIL_USE_TLS="true"
                else
                    EMAIL_USE_SSL="true"
                    EMAIL_USE_TLS="false"
                fi
                ;;
        esac

        read -p "Email address: " EMAIL_USER
        read -s -p "Email password: " EMAIL_PASSWORD
        echo ""
        read -p "Mailbox/folder to check [INBOX]: " EMAIL_MAILBOX
        EMAIL_MAILBOX=${EMAIL_MAILBOX:-INBOX}

        read -p "Delete emails after processing? (y/N): " DELETE_EMAILS
        if [[ "$DELETE_EMAILS" =~ ^[Yy]$ ]]; then
            EMAIL_DELETE="true"
        else
            EMAIL_DELETE="false"
        fi

        read -p "Mark emails as read after processing? (Y/n): " MARK_READ
        if [[ "$MARK_READ" =~ ^[Nn]$ ]]; then
            EMAIL_MARK_READ="false"
        else
            EMAIL_MARK_READ="true"
        fi
    else
        ENABLE_EMAIL=false
    fi

    # OCR languages
    read -p "OCR languages (comma-separated) [eng]: " OCR_LANGS
    OCR_LANGS=${OCR_LANGS:-eng}

    echo ""
    log_success "Configuration collected"
}

# =============================================================================
# Generate Secrets
# =============================================================================

generate_secrets() {
    log_info "Generating secure secrets..."

    POSTGRES_PASSWORD=$(openssl rand -base64 24)
    PAPERLESS_SECRET_KEY=$(openssl rand -base64 32)

    log_success "Secrets generated"
}

# =============================================================================
# Create docker-compose.yml
# =============================================================================

create_docker_compose() {
    log_info "Creating docker-compose.yml..."

    # Determine SELinux label suffix (Z for Podman on SELinux systems)
    SELINUX_LABEL=""
    if [ "$CONTAINER_CMD" = "podman" ] && command -v getenforce &> /dev/null; then
        if [ "$(getenforce 2>/dev/null)" != "Disabled" ]; then
            SELINUX_LABEL=":Z"
            log_info "SELinux detected - adding volume labels"
        fi
    fi

    cat > "${CONFIG_DIR}/docker-compose.yml" << EOF
version: "3.8"

services:
  broker:
    image: docker.io/library/redis:7
    restart: unless-stopped
    volumes:
      - ${DATA_DIR}/redisdata:/data${SELINUX_LABEL}
    networks:
      - paperless

  db:
    image: docker.io/library/postgres:16
    restart: unless-stopped
    volumes:
      - ${DATA_DIR}/pgdata:/var/lib/postgresql/data${SELINUX_LABEL}
    environment:
      POSTGRES_DB: paperless
      POSTGRES_USER: paperless
      POSTGRES_PASSWORD: \${POSTGRES_PASSWORD}
    networks:
      - paperless

  webserver:
    image: ghcr.io/paperless-ngx/paperless-ngx:latest
    restart: unless-stopped
    depends_on:
      - db
      - broker
    ports:
      - "127.0.0.1:8000:8000"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000"]
      interval: 30s
      timeout: 10s
      retries: 5
    volumes:
      # Documents storage
      - ${DOCUMENTS_DIR}/consume:/usr/src/paperless/consume${SELINUX_LABEL}
      - ${DOCUMENTS_DIR}/media:/usr/src/paperless/media${SELINUX_LABEL}
      - ${DOCUMENTS_DIR}/export:/usr/src/paperless/export${SELINUX_LABEL}
      # Application data
      - ${DATA_DIR}/data:/usr/src/paperless/data${SELINUX_LABEL}
      # Logs
      - ${LOG_DIR}:/usr/src/paperless/logs${SELINUX_LABEL}
    env_file:
      - .env
    environment:
      PAPERLESS_REDIS: redis://broker:6379
      PAPERLESS_DBHOST: db
      PAPERLESS_DBNAME: paperless
      PAPERLESS_DBUSER: paperless
      PAPERLESS_DBPASS: \${POSTGRES_PASSWORD}
      # Security settings
      PAPERLESS_SECRET_KEY: \${PAPERLESS_SECRET_KEY}
      PAPERLESS_ALLOWED_HOSTS: localhost,127.0.0.1
      PAPERLESS_CORS_ALLOWED_HOSTS: http://localhost:8000,http://127.0.0.1:8000
      PAPERLESS_TRUSTED_PROXIES: 127.0.0.1
      # OCR settings
      PAPERLESS_OCR_LANGUAGE: ${OCR_LANGS}
      PAPERLESS_OCR_MODE: skip
      # Tika and Gotenberg for advanced parsing
      PAPERLESS_TIKA_ENABLED: 1
      PAPERLESS_TIKA_GOTENBERG_ENDPOINT: http://gotenberg:3000
      PAPERLESS_TIKA_ENDPOINT: http://tika:9998
      # Time zone
      PAPERLESS_TIME_ZONE: \${TZ}
      # Admin user
      PAPERLESS_ADMIN_USER: \${PAPERLESS_ADMIN_USER}
      PAPERLESS_ADMIN_PASSWORD: \${PAPERLESS_ADMIN_PASSWORD}
      # Email consumption
      PAPERLESS_EMAIL_TASK_CRON: "*/10 * * * *"
      PAPERLESS_CONSUMER_POLLING: 60
      # URL for task scheduling
      PAPERLESS_URL: http://localhost:8000
    networks:
      - paperless

  gotenberg:
    image: docker.io/gotenberg/gotenberg:8
    restart: unless-stopped
    command:
      - "gotenberg"
      - "--chromium-disable-javascript=true"
      - "--chromium-allow-list=file:///tmp/.*"
    networks:
      - paperless

  tika:
    image: docker.io/apache/tika:latest
    restart: unless-stopped
    networks:
      - paperless

networks:
  paperless:
    driver: bridge
EOF

    log_success "docker-compose.yml created"
}

# =============================================================================
# Create .env file
# =============================================================================

create_env_file() {
    log_info "Creating .env file..."

    cat > "${CONFIG_DIR}/.env" << EOF
# ======================
# Database Configuration
# ======================
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}

# ======================
# Paperless-ngx Core Settings
# ======================
# Secret key for Django - keep this secret!
PAPERLESS_SECRET_KEY=${PAPERLESS_SECRET_KEY}

# ======================
# Admin User Configuration
# ======================
PAPERLESS_ADMIN_USER=${ADMIN_USER}
PAPERLESS_ADMIN_PASSWORD=${ADMIN_PASSWORD}

# ======================
# Timezone Configuration
# ======================
TZ=${TIMEZONE}

# ======================
# Email Consumption Settings
# ======================
EOF

    if [ "$ENABLE_EMAIL" = true ]; then
        cat >> "${CONFIG_DIR}/.env" << EOF
PAPERLESS_CONSUMPTION_ENABLED=true

# IMAP Server Settings
PAPERLESS_EMAIL_HOST=${EMAIL_HOST}
PAPERLESS_EMAIL_PORT=${EMAIL_PORT}
PAPERLESS_EMAIL_USER=${EMAIL_USER}
PAPERLESS_EMAIL_PASSWORD=${EMAIL_PASSWORD}
PAPERLESS_EMAIL_FROM=${EMAIL_USER}

# Email Security
PAPERLESS_EMAIL_USE_SSL=${EMAIL_USE_SSL}
PAPERLESS_EMAIL_USE_TLS=${EMAIL_USE_TLS}

# Mailbox Settings
PAPERLESS_EMAIL_MAILBOX=${EMAIL_MAILBOX}
PAPERLESS_EMAIL_DELETE=${EMAIL_DELETE}
PAPERLESS_EMAIL_MARK_READ=${EMAIL_MARK_READ}

# Optional: Subject filter (uncomment to use)
# PAPERLESS_EMAIL_SUBJECT_FILTER=paperless
EOF
    else
        cat >> "${CONFIG_DIR}/.env" << EOF
# Email consumption disabled
# Uncomment and configure the settings below to enable email consumption
# PAPERLESS_CONSUMPTION_ENABLED=true
# PAPERLESS_EMAIL_HOST=127.0.0.1
# PAPERLESS_EMAIL_PORT=1143
# PAPERLESS_EMAIL_USER=your-email@example.com
# PAPERLESS_EMAIL_PASSWORD=your-password
# PAPERLESS_EMAIL_FROM=your-email@example.com
# PAPERLESS_EMAIL_USE_SSL=false
# PAPERLESS_EMAIL_USE_TLS=true
# PAPERLESS_EMAIL_MAILBOX=INBOX
# PAPERLESS_EMAIL_DELETE=false
# PAPERLESS_EMAIL_MARK_READ=true
EOF
    fi

    # Set secure permissions on .env file
    chmod 600 "${CONFIG_DIR}/.env"

    log_success ".env file created with secure permissions"
}

# =============================================================================
# Start Containers
# =============================================================================

start_containers() {
    log_info "Starting paperless-ngx containers..."

    cd "${CONFIG_DIR}"
    ${COMPOSE_CMD} up -d

    log_success "Containers started"
    log_info "Waiting for paperless-ngx to initialize..."

    # Wait for the service to be ready
    sleep 10

    # Check container status
    ${CONTAINER_CMD} ps --filter "name=paperless-ngx" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

# =============================================================================
# Create Management Scripts
# =============================================================================

create_management_scripts() {
    log_info "Creating management scripts..."

    # Start script
    cat > "${CONFIG_DIR}/start.sh" << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"
podman-compose up -d
echo "Paperless-ngx started. Access at http://localhost:8000"
EOF
    chmod +x "${CONFIG_DIR}/start.sh"

    # Stop script
    cat > "${CONFIG_DIR}/stop.sh" << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"
podman-compose down
echo "Paperless-ngx stopped"
EOF
    chmod +x "${CONFIG_DIR}/stop.sh"

    # Logs script
    cat > "${CONFIG_DIR}/logs.sh" << 'EOF'
#!/bin/bash
podman logs -f paperless-ngx_webserver_1
EOF
    chmod +x "${CONFIG_DIR}/logs.sh"

    # Backup script
    cat > "${CONFIG_DIR}/backup.sh" << EOF
#!/bin/bash
# Backup script for paperless-ngx
BACKUP_DIR="\${HOME}/paperless-backups/\$(date +%Y%m%d_%H%M%S)"
mkdir -p "\${BACKUP_DIR}"

echo "Backing up paperless-ngx to \${BACKUP_DIR}..."

# Backup documents
rsync -av "${DOCUMENTS_DIR}/" "\${BACKUP_DIR}/documents/"

# Backup database
podman exec paperless-ngx_db_1 pg_dump -U paperless paperless > "\${BACKUP_DIR}/database.sql"

# Backup configuration
cp -r "${CONFIG_DIR}/.env" "\${BACKUP_DIR}/"

echo "Backup completed: \${BACKUP_DIR}"
EOF
    chmod +x "${CONFIG_DIR}/backup.sh"

    log_success "Management scripts created in ${CONFIG_DIR}"
}

# =============================================================================
# Display Summary
# =============================================================================

display_summary() {
    echo ""
    echo "============================================================================="
    log_success "Paperless-ngx installation completed!"
    echo "============================================================================="
    echo ""
    echo -e "${GREEN}Access Information:${NC}"
    echo "  Web Interface: http://localhost:8000"
    echo "  Username:      ${ADMIN_USER}"
    echo "  Password:      ${ADMIN_PASSWORD}"
    echo ""
    echo -e "${GREEN}Directory Structure:${NC}"
    echo "  Documents:     ${DOCUMENTS_DIR}"
    echo "    - consume/   Drop files here for import"
    echo "    - media/     Processed documents"
    echo "    - export/    Exports go here"
    echo ""
    echo "  Configuration: ${CONFIG_DIR}"
    echo "  App Data:      ${DATA_DIR}"
    echo "  Logs:          ${LOG_DIR}"
    echo ""
    echo -e "${GREEN}Management:${NC}"
    echo "  Start:   ${CONFIG_DIR}/start.sh"
    echo "  Stop:    ${CONFIG_DIR}/stop.sh"
    echo "  Logs:    ${CONFIG_DIR}/logs.sh"
    echo "  Backup:  ${CONFIG_DIR}/backup.sh"
    echo ""
    echo -e "${GREEN}Manual Commands:${NC}"
    echo "  Start:   cd ${CONFIG_DIR} && ${COMPOSE_CMD} up -d"
    echo "  Stop:    cd ${CONFIG_DIR} && ${COMPOSE_CMD} down"
    echo "  Restart: cd ${CONFIG_DIR} && ${COMPOSE_CMD} restart"
    echo "  Logs:    ${CONTAINER_CMD} logs paperless-ngx_webserver_1"
    echo ""
    if [ "$ENABLE_EMAIL" = true ]; then
        echo -e "${GREEN}Email Consumption:${NC}"
        echo "  Configured for: ${EMAIL_USER}"
        echo "  Checking every: 10 minutes"
        echo "  Mailbox:        ${EMAIL_MAILBOX}"
        echo ""
    fi
    echo -e "${YELLOW}Important Notes:${NC}"
    echo "  - Save your admin password: ${ADMIN_PASSWORD}"
    echo "  - .env file contains secrets - keep it secure!"
    echo "  - Access restricted to localhost (127.0.0.1)"
    echo "  - Regular backups recommended"
    echo ""
    echo "============================================================================="
}

# =============================================================================
# Main Installation Flow
# =============================================================================

main() {
    echo "============================================================================="
    echo "                  Paperless-ngx Installation Script"
    echo "============================================================================="
    echo ""

    check_prerequisites
    collect_user_input
    create_directories
    generate_secrets
    create_docker_compose
    create_env_file
    start_containers
    create_management_scripts
    display_summary
}

# Run main function
main
