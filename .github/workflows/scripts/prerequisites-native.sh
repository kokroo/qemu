#!/usr/bin/env bash

set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

apt-get update -y -q
apt-get install -y -q --no-install-recommends \
    build-essential \
    git \
    libgcrypt-dev \
    libglib2.0-dev \
    libpixman-1-dev \
    libsdl2-dev \
    libslirp-dev \
    meson \
    ninja-build \
    python3 \
    python3-pip \
    wget \
    zlib1g-dev \
&& :

# Install or upgrade meson/tomli if needed
python3 -m pip install --break-system-packages meson==1.7.0 tomli==2.2.1 || true
