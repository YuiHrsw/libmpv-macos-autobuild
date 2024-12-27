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

# clone exactly the oldest libplacebo we want to support
rm -rf subprojects
mkdir -p subprojects
git clone https://code.videolan.org/videolan/libplacebo.git \
    --recurse-submodules --shallow-submodules \
    --depth=1 --branch v6.338 subprojects/libplacebo \

meson setup build $common_args \
 -Dlua=enabled -Dx11=enabled
meson compile -C build

cd ..