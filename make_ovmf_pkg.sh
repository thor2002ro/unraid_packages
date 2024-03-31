#!/bin/bash


START="$PWD"

cd "$START"

pkg_date="2024.02-2"

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

# Download Debian packages
wget "http://ftp.de.debian.org/debian/pool/main/e/edk2/ovmf_${pkg_date}_all.deb" || { echo "Error downloading ovmf package"; exit 1; }
wget "http://ftp.de.debian.org/debian/pool/main/e/edk2/qemu-efi-aarch64_${pkg_date}_all.deb" || { echo "Error downloading qemu-efi-aarch64 package"; exit 1; }
wget "http://ftp.de.debian.org/debian/pool/main/e/edk2/qemu-efi-arm_${pkg_date}_all.deb" || { echo "Error downloading qemu-efi-arm package"; exit 1; }

# Create an array of deb files
deb_files=(*.deb)

# Loop through each deb file and extract data tar files
for deb_file in "${deb_files[@]}"; do
    # Extract deb file
    ar x "$deb_file"
    
    # Extract data tar file
    data_tar=$(ls data.*)
    package_name="${deb_file%_*}" # Extract package name from deb filename
    mv "$data_tar" "${package_name}_data.tar"
    tar -xf "${package_name}_data.tar" -C "$START/$PKG_DIR"
done

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
