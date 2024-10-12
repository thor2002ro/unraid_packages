#!/bin/sh

START="$PWD"

cd "$START"

PKG="powertop"
PKG_DIR=""$PKG"_pkg"
GIT_DIR="$PKG"
OUT_DIR="PKGS"
FLAGS="-O2 -fPIC -static"

LIBDIRSUFFIX="64"

rm -rf "$PKG_DIR"
rm -rf "$GIT_DIR"

mkdir -p "$OUT_DIR"
mkdir -p "$PKG_DIR"

#GIT
git clone https://github.com/fenrus75/powertop.git --branch master --depth 1
cd "$GIT_DIR"

git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git
cd libtraceevent; meson configure --default-library=static; make; sudo make install; cd lib; rm *.so*; cd ../..;

git clone https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git
cd libtracefs; meson configure --default-library=static; make; cd lib; rm *.so*; cd ../..;


./autogen.sh

LDFLAGS="-static-libgcc -static-libstdc++ -L$PWD/libtraceevent/lib -L$PWD/libtracefs/lib" \
LIBTRACEFS_CFLAGS="-I$PWD/libtraceevent/include/traceevent -I$PWD/libtracefs/include" \
LIBTRACEFS_LIBS="-static -ltraceevent -ltracefs" \
PKG_CONFIG_PATH="$PWD/libtraceevent/lib/pkgconfig:$PWD/libtracefs/lib/pkgconfig" \
./configure --disable-shared


make -j10 

make install DESTDIR="$START/$PKG_DIR" sbindir="/usr/bin"

#strip --strip-unneeded "$START/$PKG_DIR/usr/bin/powertop"

echo -e "\e[95m MAKEPKG "$GIT_DIR""
cd "$START/$PKG_DIR"

#remove man/locales
rm -r "usr/local"

"$START"/makepkg -l n -c y "$START/$OUT_DIR/$PKG"-$(date +'%Y.%m.%d')-x86_64-thor.tgz

cd "$START"

rm -rf "$PKG_DIR"
rm -rf "$GIT_DIR"
