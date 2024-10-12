#!/bin/sh

START="$PWD"

cd "$START"

PKG="nvtop"
PKG_DIR=""$PKG"_pkg"
GIT_DIR="$PKG"
OUT_DIR="PKGS"
FLAGS="-O2 -fPIC"

LIBDIRSUFFIX="64"

rm -rf "$PKG_DIR"
rm -rf "$GIT_DIR"

mkdir -p "$OUT_DIR"
mkdir -p "$PKG_DIR"

#GIT
git clone https://github.com/Syllo/nvtop.git --branch master --depth 1
cd "$GIT_DIR"

mkdir -p build && cd build
cmake .. -DNVIDIA_SUPPORT=ON -DAMDGPU_SUPPORT=ON -DINTEL_SUPPORT=ON
CFLAGS="$FLAGS" \
make

make install \
  PREFIX=/usr \
  LIBDIR=lib${LIBDIRSUFFIX} \
  MANDIR=man \
  DESTDIR="$START/$PKG_DIR"

echo -e "\e[95m MAKEPKG "$GIT_DIR""
cd "$START/$PKG_DIR"

"$START"/makepkg -l n -c y "$START/$OUT_DIR/$PKG"-$(date +'%Y%m%d')-x86_64-thor.tgz

cd "$START"

rm -rf "$PKG_DIR"
rm -rf "$GIT_DIR"
