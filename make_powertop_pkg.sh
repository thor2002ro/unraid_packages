#!/bin/sh

START="$PWD"

cd "$START"

PKG="powertop"
PKG_DIR=""$PKG"_pkg"
GIT_DIR="$PKG"
FLAGS="-O2 -fPIC"

LIBDIRSUFFIX="64"

rm -rf "$PKG_DIR"
rm -rf "$GIT_DIR"

mkdir -p "$PKG_DIR"

#GIT
git clone https://github.com/fenrus75/powertop.git --branch master --depth 1
cd "$GIT_DIR"

./autogen.sh
./configure

CFLAGS="$FLAGS" \
make -j10

make install DESTDIR="$START/$PKG_DIR" sbindir="/usr/bin"

strip --strip-unneeded "$START/$PKG_DIR/usr/bin/powertop"

echo -e "\e[95m MAKEPKG "$GIT_DIR""
cd "$START/$PKG_DIR"

#remove man/locales
rm -r "usr/local"

fakeroot "$START"/makepkg -l n -c y "$START/$PKG"-$(date +'%Y.%m.%d')-x86_64-thor.tgz

cd "$START"

rm -rf "$PKG_DIR"
rm -rf "$GIT_DIR"
