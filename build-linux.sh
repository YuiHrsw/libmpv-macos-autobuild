#!/bin/sh
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

CC="gcc-14" \
meson setup build \
  --werror -Dlibmpv=true -Dtests=false \
  -Dprefix="${MPV_INSTALL_PREFIX}" \
  -Dlua=enabled -Dx11=enabled -Dvapoursynth=disabled

meson compile -C build
meson install -C build

cd ..