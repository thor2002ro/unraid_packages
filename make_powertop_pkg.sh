#!/bin/sh

START="$PWD"

cd "$START"

PKG="powertop"
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
git clone https://github.com/fenrus75/powertop.git --branch master --depth 1
cd "$GIT_DIR"

git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
cd libtraceevent; make; sudo make install; cd ..;

git clone https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
cd libtracefs; make; sudo make install; cd ..;

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

fakeroot "$START"/makepkg -l n -c y "$START/$OUT_DIR/$PKG"-$(date +'%Y.%m.%d')-x86_64-thor.tgz

cd "$START"

rm -rf "$PKG_DIR"
rm -rf "$GIT_DIR"
