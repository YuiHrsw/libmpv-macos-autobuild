#!/usr/bin/env bash

apt-get install build-essential gcc meson ninja \
    libx11-dev libxfixes-dev libxcursor-dev libxss-dev libxxf86vm-dev libxi-dev libxinerama-dev libxv-dev libxrandr-dev

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew update
yes | brew install ffmpeg libplacebo zlib libass lua luajit libjpeg \
    uchardet vulkan-loader vulkan-headers zimg zmq libxcb webp \
    dav1d freetype2 fribidi harfbuzz libunibreak openssl mujs \
    opus rav1e rubberband sdl2 shaderc snappy libsodium libsoxr \
    speex srt x264 x265 giflib libarchive libbluray aribb24 python3
