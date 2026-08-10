#!/bin/sh
# install-qutebrowser.sh
#
# Integrates the source-installed qutebrowser into the system so it behaves
# like a package installed via DNF. This is necessary because the version
# in the official Fedora repositories lags too far behind upstream.
#
# qutebrowser lives at ~/repos/external/qutebrowser and is launched via its
# own virtualenv (.venv/bin/python3 -m qutebrowser). This script:
#   1. Creates a wrapper in /usr/local/bin so `qutebrowser` works anywhere
#   2. Installs the .desktop file so it appears in app launchers
#   3. Installs icons into the hicolor theme
#   4. Sets qutebrowser as the default web browser via xdg-settings
#
# Re-run this script after updating the repo if the .desktop file or icons change.

set -e

REPO=/home/vitalydruker/repos/external/qutebrowser

# 1. Wrapper script
sudo tee /usr/local/bin/qutebrowser > /dev/null << 'EOF'
#!/bin/sh
exec /home/vitalydruker/repos/external/qutebrowser/.venv/bin/python3 -m qutebrowser "$@"
EOF
sudo chmod +x /usr/local/bin/qutebrowser

# 2. Desktop file
sudo cp "$REPO/misc/org.qutebrowser.qutebrowser.desktop" /usr/share/applications/

# 3. Icons
for size in 16 24 48 64 96 128 512; do
    sudo install -Dm644 "$REPO/qutebrowser/icons/qutebrowser-${size}x${size}.png" \
        "/usr/share/icons/hicolor/${size}x${size}/apps/qutebrowser.png"
done
sudo gtk-update-icon-cache /usr/share/icons/hicolor/

# 4. Default browser
xdg-settings set default-web-browser org.qutebrowser.qutebrowser.desktop

echo "Done. qutebrowser is now installed system-wide and set as default browser."
