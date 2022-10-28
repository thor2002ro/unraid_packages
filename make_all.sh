#!/bin/sh

START="$PWD"

cd "$START"

find . -name '*.sh' ! -name 'make_all.sh' | head -n 10 | xargs -n1 sh
