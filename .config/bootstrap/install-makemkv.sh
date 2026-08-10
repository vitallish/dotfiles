#!/bin/bash
set -euo pipefail

# Build and install MakeMKV from source.
# Follows the official Linux guide: https://forum.makemkv.com/forum/viewtopic.php?f=3&t=224
#
# FFmpeg is compiled from source into a temp prefix and used only during the
# makemkv-oss build, avoiding conflicts with Fedora's libswscale-free package.

MAKEMKV_VERSION=$(curl -s "https://www.makemkv.com/download/" \
  | grep -oP 'MakeMKV v\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)

if [[ -z "$MAKEMKV_VERSION" ]]; then
  echo "ERROR: could not determine latest MakeMKV version" >&2
  exit 1
fi

FFMPEG_VERSION=$(curl -s "https://ffmpeg.org/download.html" \
  | grep -oP 'FFmpeg \K[0-9]+\.[0-9]+(?=\s)' | head -1)

if [[ -z "$FFMPEG_VERSION" ]]; then
  echo "ERROR: could not determine latest FFmpeg version" >&2
  exit 1
fi

echo "Installing MakeMKV $MAKEMKV_VERSION (with FFmpeg $FFMPEG_VERSION)"

sudo dnf install -y \
  gcc gcc-c++ make pkg-config nasm \
  openssl-devel \
  expat-devel \
  zlib-devel \
  libdrm-devel \
  libudev-devel \
  gtk3-devel \
  qt5-qtbase-devel

BUILD_DIR=$(mktemp -d)
FFMPEG_PREFIX="$BUILD_DIR/ffmpeg"
trap 'rm -rf "$BUILD_DIR"' EXIT
cd "$BUILD_DIR"

# Build FFmpeg into a temp prefix (static, no install to system)
curl -LO "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz"
tar -xzf "ffmpeg-${FFMPEG_VERSION}.tar.gz"
pushd "ffmpeg-${FFMPEG_VERSION}"
./configure --prefix="$FFMPEG_PREFIX" --enable-static --disable-shared --enable-pic
make -j"$(nproc)"
make install
popd

# Download MakeMKV sources
curl -LO "https://www.makemkv.com/download/makemkv-oss-${MAKEMKV_VERSION}.tar.gz"
curl -LO "https://www.makemkv.com/download/makemkv-bin-${MAKEMKV_VERSION}.tar.gz"

# Build makemkv-oss pointing at the temp FFmpeg
tar -xzf "makemkv-oss-${MAKEMKV_VERSION}.tar.gz"
pushd "makemkv-oss-${MAKEMKV_VERSION}"
PKG_CONFIG_PATH="$FFMPEG_PREFIX/lib/pkgconfig" ./configure
make -j"$(nproc)"
sudo make install
popd

# Install makemkv-bin (accept EULA non-interactively)
tar -xzf "makemkv-bin-${MAKEMKV_VERSION}.tar.gz"
pushd "makemkv-bin-${MAKEMKV_VERSION}"
mkdir -p tmp
echo "yes" | make
sudo make install
popd

echo "MakeMKV $MAKEMKV_VERSION installed successfully"
echo "Run 'makemkvcon --help' or launch 'makemkv' to get started"
