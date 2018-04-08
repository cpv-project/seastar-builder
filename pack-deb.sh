#!/usr/bin/env bash
set -e

DEBOUT="./build-pkg"
DEBROOT="./build-pkg/deb"
rm -rfv $DEBROOT
mkdir -p $DEBROOT
cp -rf debian $DEBROOT/DEBIAN
LIBOUT="$DEBROOT/usr/lib/x86_64-linux-gnu"
mkdir -p $LIBOUT
# cp ../seastar/build/release/*.a $LIBOUT
cp ../seastar/build/release/seastar.so $LIBOUT/libseastar.so
HEADEROUT="$DEBROOT/usr/include/seastar"
mkdir -p $HEADEROUT/c-ares
cp ../seastar/c-ares/*.h $HEADEROUT/c-ares
cp ../seastar/build/release/c-ares/*.h $HEADEROUT/c-ares
mkdir -p $HEADEROUT/core
cp ../seastar/core/*.hh $HEADEROUT/core
mkdir -p $HEADEROUT/fmt
cp ../seastar/fmt/fmt/*.h $HEADEROUT/fmt
mkdir -p $HEADEROUT/http
mkdir -p $HEADEROUT/http/http
cp ../seastar/http/*.hh $HEADEROUT/http
cp ../seastar/build/release/gen/http/*.hh $HEADEROUT/http/http
mkdir -p $HEADEROUT/json
cp ../seastar/json/*.hh $HEADEROUT/json
mkdir -p $HEADEROUT/net
cp ../seastar/net/*.hh $HEADEROUT/net
mkdir -p $HEADEROUT/rpc
cp ../seastar/rpc/*.hh $HEADEROUT/rpc
mkdir -p $HEADEROUT/util
cp ../seastar/util/*.hh $HEADEROUT/util

dpkg -b $DEBROOT $DEBOUT/seastar_18.04-1_amd64.deb

