#!/usr/bin/env bash
set -e

DEBOUT=$(realpath .)/build-pkg
DEBROOT=$DEBOUT/deb
VERSION=$(date +%Y%m%d)
COOKING_INSTALLED=$(realpath ./seastar/build/release/_cooking/installed)

rm -rfv $DEBROOT
mkdir -p $DEBROOT

cd ./seastar/build/release
DESTDIR=$DEBROOT cmake -P cmake_install.cmake

cd $DEBOUT
cp -r $COOKING_INSTALLED/include/* $DEBROOT/usr/include
cp -r $COOKING_INSTALLED/lib/* $DEBROOT/usr/lib/x86_64-linux-gnu
strip $DEBROOT/usr/lib/x86_64-linux-gnu/*.so

cp -rf ../debian $DEBROOT/DEBIAN
sed -i "s/_VERSION/$VERSION/g" $DEBROOT/DEBIAN/control
sed -i "s#$COOKING_INSTALLED/include#/usr/include#g" \
  $DEBROOT/usr/lib/x86_64-linux-gnu/pkgconfig/seastar.pc
sed -i "s#$COOKING_INSTALLED/lib#/usr/lib/x86_64-linux-gnu#g" \
  $DEBROOT/usr/lib/x86_64-linux-gnu/pkgconfig/seastar.pc
dpkg -b $DEBROOT $DEBOUT/seastar_${VERSION}_amd64.deb

