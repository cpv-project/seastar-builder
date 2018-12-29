#!/usr/bin/env bash
set -e

cd ${SRCDIR}/build/release
DESTDIR=${ROOTDIR} cmake -P cmake_install.cmake
COOKING_INSTALLED=$(realpath ./_cooking/installed)

cd ${SRCDIR}/build/debug
DESTDIR=${ROOTDIR_DEBUG} cmake -P cmake_install.cmake
COOKING_INSTALLED_DEBUG=$(realpath ./_cooking/installed)

cd ${ROOTDIR}
cp -rf ${COOKING_INSTALLED}/include/* ${ROOTDIR}/usr/include
cp -rf ${COOKING_INSTALLED_DEBUG}/lib/* ${ROOTDIR}/usr/lib/x86_64-linux-gnu
cp -rf ${COOKING_INSTALLED}/lib/* ${ROOTDIR}/usr/lib/x86_64-linux-gnu
cp -f ${ROOTDIR_DEBUG}/usr/lib/x86_64-linux-gnu/libseastar.so \
	${ROOTDIR}/usr/lib/x86_64-linux-gnu/libseastar_debug.so
cp -f ${ROOTDIR_DEBUG}/usr/lib/x86_64-linux-gnu/libseastar_testing.so \
	${ROOTDIR}/usr/lib/x86_64-linux-gnu/libseastar_testing_debug.so
cp -f ${ROOTDIR_DEBUG}/usr/lib/x86_64-linux-gnu/pkgconfig/seastar.pc \
	${ROOTDIR}/usr/lib/x86_64-linux-gnu/pkgconfig/seastar-debug.pc
cp -f ${ROOTDIR_DEBUG}/usr/lib/x86_64-linux-gnu/pkgconfig/seastar-testing.pc \
	${ROOTDIR}/usr/lib/x86_64-linux-gnu/pkgconfig/seastar-testing-debug.pc
strip ${ROOTDIR}/usr/lib/x86_64-linux-gnu/*.so

mkdir -p ${ROOTDIR}/usr/share/licenses/seastar
cp ${SRCDIR}/LICENSE ${ROOTDIR}/usr/share/licenses/seastar/
cp ${SRCDIR}/NOTICE ${ROOTDIR}/usr/share/licenses/seastar/

sed -i "s#${COOKING_INSTALLED}/include#/usr/include#g" \
  ${ROOTDIR}/usr/lib/x86_64-linux-gnu/pkgconfig/seastar.pc
sed -i "s#${COOKING_INSTALLED}/lib#/usr/lib/x86_64-linux-gnu#g" \
  ${ROOTDIR}/usr/lib/x86_64-linux-gnu/pkgconfig/seastar.pc
sed -i "s#${COOKING_INSTALLED_DEBUG}/include#/usr/include#g" \
  ${ROOTDIR}/usr/lib/x86_64-linux-gnu/pkgconfig/seastar-debug.pc
sed -i "s#${COOKING_INSTALLED_DEBUG}/lib#/usr/lib/x86_64-linux-gnu#g" \
  ${ROOTDIR}/usr/lib/x86_64-linux-gnu/pkgconfig/seastar-debug.pc
sed -i "s#libseastar.so#libseastar_debug.so#g" \
  ${ROOTDIR}/usr/lib/x86_64-linux-gnu/pkgconfig/seastar-debug.pc
sed -i "s#libseastar_testing.so#libseastar_testing_debug.so#g" \
  ${ROOTDIR}/usr/lib/x86_64-linux-gnu/pkgconfig/seastar-testing-debug.pc

patchelf --set-soname libseastar_debug.so ${ROOTDIR}/usr/lib/x86_64-linux-gnu/libseastar_debug.so
patchelf --set-soname libseastar_testing_debug.so ${ROOTDIR}/usr/lib/x86_64-linux-gnu/libseastar_testing_debug.so
patchelf --replace-needed libseastar.so libseastar_debug.so ${ROOTDIR}/usr/lib/x86_64-linux-gnu/libseastar_testing_debug.so
