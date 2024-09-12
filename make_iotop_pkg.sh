#!/bin/sh

# Set the starting directory
START="$PWD"

# Set package variables
PKG="iotop-c"
PKG_DIR="${PKG}_pkg"
GIT_DIR="$PKG"
OUT_DIR="PKGS"
FLAGS="-O2 -fPIC"

# Suffix for the library directory
LIBDIRSUFFIX="64"

# Clean up any previous build directories
rm -rf "$PKG_DIR"
rm -rf "$GIT_DIR"

# Create necessary directories
mkdir -p "$OUT_DIR"
mkdir -p "$PKG_DIR"

# Clone the iotop repository
git clone https://github.com/Tomas-M/iotop.git --branch master --depth 1 "$GIT_DIR"
cd "$GIT_DIR" || exit 1

# Build the project using the provided CFLAGS and the Makefile
#CFLAGS="$FLAGS" \
make

mkdir -p "$START/$PKG_DIR/usr/bin/"
cp iotop "$START/$PKG_DIR/usr/bin/iotop-c"

# Navigate to the package directory
cd "$START/$PKG_DIR" || exit 1

# Optionally remove man pages if not needed (as per your original script)
# Uncomment this if you do not want to include man pages in the final package
# rm -r "usr/share/man"

# Create the package using fakeroot and makepkg
fakeroot "$START"/makepkg -l n -c y "$START/$OUT_DIR/$PKG"-$(date +'%Y%m%d')-x86_64-thor.tgz

# Go back to the starting directory
cd "$START"

# Clean up the build and package directories
rm -rf "$PKG_DIR"
rm -rf "$GIT_DIR"
