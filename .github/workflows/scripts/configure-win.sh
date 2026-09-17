#!/usr/bin/env bash

set -euo pipefail

TARGET=${TARGET:-xtensa-softmmu}
VERSION=${VERSION:-dev}

echo DBG
./configure --help

./configure \
    --bindir=bin \
    --datadir=share/qemu \
    --enable-gcrypt \
    --enable-sdl \
    --enable-pixman \
    --enable-slirp \
    --enable-stack-protector \
    --extra-cflags=-Wno-error \
    --prefix=${PWD}/install/qemu \
    --static \
    --target-list=${TARGET} \
    --with-pkgversion="${VERSION}" \
    --with-suffix="" \
    --without-default-features \
|| { cat meson-logs/meson-log.txt && false; }


# Fix: pkg-config for libgcrypt outputs incorrect paths for libiconv and libintl:
# - Unix-style paths (/mingw64/lib/...) instead of Windows paths (D:/a/_temp/msys64/mingw64/lib/...)
# - Dynamic import libraries (.dll.a) instead of static libraries (.a)
# We need to fix both issues in build.ninja for the static build to work correctly.
MSYS_BASE=$(cygpath -w / | sed 's/\\/\//g')
PREFIX="${MINGW_PREFIX:-/mingw64}"

for lib in libintl libiconv; do
    if [[ -f "${PREFIX}/lib/${lib}.a" ]]; then
        sed -i "s|${PREFIX}/lib/${lib}.dll.a|${MSYS_BASE}${PREFIX}/lib/${lib}.a|g" build/build.ninja
    elif [[ -f "${PREFIX}/lib/${lib}.dll.a" ]]; then
        sed -i "s|${PREFIX}/lib/${lib}.dll.a|${MSYS_BASE}${PREFIX}/lib/${lib}.dll.a|g" build/build.ninja
    fi
done
