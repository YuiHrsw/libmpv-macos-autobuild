#!/usr/bin/env bash

set -e

export CFLAGS="$CFLAGS -Wno-error=deprecated -Wno-error=deprecated-declarations -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=3"

if [ -n "$1" ]; then
    echo "Installing to $1"
else
    echo "Usage: $0 <install-prefix>"
    exit 1
fi

cd mpv

MPV_INSTALL_PREFIX="$1"
MPV_VARIANT="${TRAVIS_OS_NAME}"

if [[ -d "./build/${MPV_VARIANT}" ]] ; then
    rm -rf "./build/${MPV_VARIANT}"
fi

CC="${CC}" CXX="${CXX}" \
meson setup build \
  --werror -Dlibmpv=true -Dtests=false \
  -Dprefix="${MPV_INSTALL_PREFIX}" \
  -Dobjc_args="-Wno-error=deprecated -Wno-error=deprecated-declarations" \
  -D{gl,iconv,lcms2,lua,jpeg,plain-gl,zlib}=enabled \
  -D{cocoa,coreaudio,gl-cocoa,videotoolbox-gl,videotoolbox-pl}=enabled \
  -D{swift-build,macos-cocoa-cb,macos-media-player,macos-touchbar,vulkan}=enabled \
  -Dvapoursynth=disabled

meson compile -C build -j4
meson install -C build

cd ..
