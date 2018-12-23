#!/usr/bin/env bash
set -e

cd ${SRCDIR}/build/release
DESTDIR=${ROOTDIR} cmake -P cmake_install.cmake

COOKING_INSTALLED=$(realpath ./_cooking/installed)

cd ${ROOTDIR}
cp -r ${COOKING_INSTALLED}/include/* ${ROOTDIR}/usr/include
cp -r ${COOKING_INSTALLED}/lib/* ${ROOTDIR}/usr/lib/x86_64-linux-gnu
strip ${ROOTDIR}/usr/lib/x86_64-linux-gnu/*.so

mkdir -p ${ROOTDIR}/usr/share/licenses/seastar
cp ${SRCDIR}/LICENSE ${ROOTDIR}/usr/share/licenses/seastar/
cp ${SRCDIR}/NOTICE ${ROOTDIR}/usr/share/licenses/seastar/

sed -i "s#${COOKING_INSTALLED}/include#/usr/include#g" \
  ${ROOTDIR}/usr/lib/x86_64-linux-gnu/pkgconfig/seastar.pc
sed -i "s#${COOKING_INSTALLED}/lib#/usr/lib/x86_64-linux-gnu#g" \
  ${ROOTDIR}/usr/lib/x86_64-linux-gnu/pkgconfig/seastar.pc

