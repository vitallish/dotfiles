#!/usr/bin/env bash
# source https://linuxcapable.com/install-microsoft-fonts-on-fedora-linux/
set -euo pipefail

sudo dnf install curl cabextract xorg-x11-font-utils mkfontscale fontconfig cpio unzip

curl -fLO https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

printf '%s  msttcore-fonts-installer-2.6-1.noarch.rpm\n' '55d7f3a86533225634ff3ea2384b4356d9665a29cc7eeacff16602a1714afbb4' | sha256sum -c -

(
    set -euo pipefail

    rpmfile="$PWD/msttcore-fonts-installer-2.6-1.noarch.rpm"
    workdir=$(mktemp -d)
    trap 'rm -rf "$workdir"' EXIT

    fontdir="$HOME/.local/share/fonts/microsoft-core"
    mkdir -p "$fontdir"

    cd "$workdir"
    rpm2cpio "$rpmfile" | cpio -id --quiet
    ./usr/lib/msttcore-fonts-installer/refresh-msttcore-fonts.sh -F "$fontdir"
    for required_font in arial.ttf calibri.ttf; do
        if [ ! -s "$fontdir/$required_font" ]; then
            printf 'Missing expected font: %s\n' "$required_font"
            exit 1
        fi
    done
    fc-cache -f "$fontdir"
)

rm msttcore-fonts-installer-2.6-1.noarch.rpm
