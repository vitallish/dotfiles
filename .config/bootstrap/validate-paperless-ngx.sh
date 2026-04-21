#!/bin/bash

# =============================================================================
# Paperless-ngx Validation Script
# =============================================================================
# This script validates an existing paperless-ngx installation
# =============================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
PASSED=0
FAILED=0
WARNINGS=0

# Configuration
CONFIG_DIR="${HOME}/.config/paperless-ngx"
DATA_DIR="${HOME}/.local/share/paperless-ngx"
LOG_DIR="${HOME}/.local/state/paperless-ngx"
DOCUMENTS_DIR="${HOME}/Documents/paperless-ngx"

# Check functions
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED++))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED++))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

check_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Header
echo "============================================================================="
echo "              Paperless-ngx Installation Validation"
echo "============================================================================="
echo ""

# 1. Check directories
echo "Checking directory structure..."

if [ -d "$CONFIG_DIR" ]; then
    check_pass "Configuration directory exists: $CONFIG_DIR"
else
    check_fail "Configuration directory missing: $CONFIG_DIR"
fi

if [ -d "$DOCUMENTS_DIR" ]; then
    check_pass "Documents directory exists: $DOCUMENTS_DIR"
else
    check_fail "Documents directory missing: $DOCUMENTS_DIR"
fi

if [ -d "$DATA_DIR" ]; then
    check_pass "Data directory exists: $DATA_DIR"
else
    check_fail "Data directory missing: $DATA_DIR"
fi

if [ -d "$LOG_DIR" ]; then
    check_pass "Log directory exists: $LOG_DIR"
else
    check_fail "Log directory missing: $LOG_DIR"
fi

echo ""

# 2. Check configuration files
echo "Checking configuration files..."

if [ -f "$CONFIG_DIR/docker-compose.yml" ]; then
    check_pass "docker-compose.yml exists"
else
    check_fail "docker-compose.yml missing"
fi

if [ -f "$CONFIG_DIR/.env" ]; then
    check_pass ".env file exists"

    # Check permissions
    PERMS=$(stat -c %a "$CONFIG_DIR/.env" 2>/dev/null || stat -f %A "$CONFIG_DIR/.env" 2>/dev/null)
    if [ "$PERMS" = "600" ]; then
        check_pass ".env has secure permissions (600)"
    else
        check_warn ".env permissions are $PERMS (should be 600)"
        check_info "Fix with: chmod 600 $CONFIG_DIR/.env"
    fi
else
    check_fail ".env file missing"
fi

echo ""

# 3. Check container runtime
echo "Checking container runtime..."

if command -v podman &> /dev/null; then
    check_pass "Podman is installed"
    CONTAINER_CMD="podman"
elif command -v docker &> /dev/null; then
    check_pass "Docker is installed"
    CONTAINER_CMD="docker"
else
    check_fail "Neither podman nor docker found"
    CONTAINER_CMD=""
fi

if command -v podman-compose &> /dev/null; then
    check_pass "podman-compose is installed"
elif command -v docker-compose &> /dev/null; then
    check_pass "docker-compose is installed"
else
    check_fail "Neither podman-compose nor docker-compose found"
fi

echo ""

# 4. Check containers
if [ -n "$CONTAINER_CMD" ]; then
    echo "Checking containers..."

    CONTAINERS=("paperless-ngx_webserver_1" "paperless-ngx_db_1" "paperless-ngx_broker_1" "paperless-ngx_gotenberg_1" "paperless-ngx_tika_1")

    for container in "${CONTAINERS[@]}"; do
        if $CONTAINER_CMD ps --filter "name=$container" --format "{{.Names}}" | grep -q "$container"; then
            STATUS=$($CONTAINER_CMD ps --filter "name=$container" --format "{{.Status}}")
            if [[ "$STATUS" == *"Up"* ]]; then
                check_pass "$container is running"
            else
                check_warn "$container exists but status: $STATUS"
            fi
        else
            check_fail "$container is not running"
        fi
    done

    echo ""
fi

# 5. Check web interface
echo "Checking web interface..."

if command -v curl &> /dev/null; then
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000 2>/dev/null)

    if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "302" ]; then
        check_pass "Web interface is accessible (HTTP $HTTP_CODE)"
        check_info "Access at: http://localhost:8000"
    elif [ "$HTTP_CODE" = "000" ]; then
        check_fail "Cannot connect to web interface"
        check_info "Check if containers are running"
    else
        check_warn "Web interface returned HTTP $HTTP_CODE"
    fi
else
    check_warn "curl not installed - cannot test web interface"
fi

echo ""

# 6. Check database connection
if [ -n "$CONTAINER_CMD" ]; then
    echo "Checking database..."

    if $CONTAINER_CMD exec paperless-ngx_db_1 pg_isready -U paperless &>/dev/null; then
        check_pass "PostgreSQL database is ready"
    else
        check_fail "PostgreSQL database is not responding"
    fi

    echo ""
fi

# 7. Check Redis
if [ -n "$CONTAINER_CMD" ]; then
    echo "Checking Redis..."

    if $CONTAINER_CMD exec paperless-ngx_broker_1 redis-cli ping 2>/dev/null | grep -q "PONG"; then
        check_pass "Redis broker is responding"
    else
        check_fail "Redis broker is not responding"
    fi

    echo ""
fi

# 8. Check email configuration
echo "Checking email configuration..."

if [ -f "$CONFIG_DIR/.env" ]; then
    if grep -q "^PAPERLESS_EMAIL_HOST=" "$CONFIG_DIR/.env" && \
       grep -q "^PAPERLESS_EMAIL_USER=" "$CONFIG_DIR/.env"; then
        check_pass "Email consumption is configured"

        EMAIL_HOST=$(grep "^PAPERLESS_EMAIL_HOST=" "$CONFIG_DIR/.env" | cut -d'=' -f2)
        EMAIL_USER=$(grep "^PAPERLESS_EMAIL_USER=" "$CONFIG_DIR/.env" | cut -d'=' -f2)

        check_info "Email: $EMAIL_USER"
        check_info "IMAP Host: $EMAIL_HOST"
    else
        check_info "Email consumption not configured (optional)"
    fi
fi

echo ""

# 9. Check management scripts
echo "Checking management scripts..."

SCRIPTS=("start.sh" "stop.sh" "logs.sh" "backup.sh")

for script in "${SCRIPTS[@]}"; do
    if [ -f "$CONFIG_DIR/$script" ]; then
        if [ -x "$CONFIG_DIR/$script" ]; then
            check_pass "$script exists and is executable"
        else
            check_warn "$script exists but is not executable"
            check_info "Fix with: chmod +x $CONFIG_DIR/$script"
        fi
    else
        check_warn "$script is missing"
    fi
done

echo ""

# 10. Check disk space
echo "Checking disk space..."

DOCUMENTS_USAGE=$(du -sh "$DOCUMENTS_DIR" 2>/dev/null | cut -f1)
DATA_USAGE=$(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)

if [ -n "$DOCUMENTS_USAGE" ]; then
    check_info "Documents size: $DOCUMENTS_USAGE"
fi

if [ -n "$DATA_USAGE" ]; then
    check_info "Data size: $DATA_USAGE"
fi

# Check available space
AVAILABLE=$(df -h "$DOCUMENTS_DIR" | awk 'NR==2 {print $4}')
check_info "Available space: $AVAILABLE"

echo ""

# Summary
echo "============================================================================="
echo "                              Summary"
echo "============================================================================="
echo -e "${GREEN}Passed:${NC}   $PASSED"
echo -e "${YELLOW}Warnings:${NC} $WARNINGS"
echo -e "${RED}Failed:${NC}   $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    if [ $WARNINGS -eq 0 ]; then
        echo -e "${GREEN}✓ All checks passed! Paperless-ngx is properly installed.${NC}"
        exit 0
    else
        echo -e "${YELLOW}⚠ Installation is working but has some warnings.${NC}"
        exit 0
    fi
else
    echo -e "${RED}✗ Installation has issues that need attention.${NC}"
    exit 1
fi
