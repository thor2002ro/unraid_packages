#!/bin/sh

START="$PWD"

cd "$START"

pkg_name="ovmf_2022.08-1_all.deb"

PKG="ovmf_x64"
PKG_DIR=""$PKG"_pkg"
GIT_DIR="$PKG"
OUT_DIR="PKGS"
FLAGS="-O2 -fPIC"

LIBDIRSUFFIX="64"

rm -rf "$PKG_DIR"
rm -rf "$GIT_DIR"

mkdir -p "$OUT_DIR"
mkdir -p "$PKG_DIR"

mkdir -p "$PKG"

cd "$PKG"

#WGET
wget "http://ftp.de.debian.org/debian/pool/main/e/edk2/$pkg_name"

ar x *.deb
tar -xf data.* -C "$START/$PKG_DIR"

echo -e "\e[95m MAKEPKG "$GIT_DIR""
cd "$START/$PKG_DIR"

#remove docs and stuff and move stuff around to work for unraid
rm -r usr/share/doc
rm -r usr/share/ovmf
rm usr/share/OVMF/*.snakeoil.fd
rm usr/share/qemu/OVMF.fd
mkdir -p usr/share/qemu/ovmf-x64
mv usr/share/OVMF/* usr/share/qemu/ovmf-x64/
rm -r usr/share/OVMF

fakeroot "$START"/makepkg -l n -c y "$START/$OUT_DIR/$PKG"-$(date +'%Y%m%d')-x86_64-thor.tgz

cd "$START"

rm -rf "$PKG_DIR"
rm -rf "$GIT_DIR"
