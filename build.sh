#!/usr/bin/env bash
set -e

VERSION=$(sh ./debian/scripts/get_version.sh)
BUILDDIR=build/seastar-${VERSION}
TYPE=$1

if [ ! -d seastar ]; then
	git clone --recurse-submodules https://github.com/cpv-project/seastar
	git clone https://github.com/fmtlib/fmt seastar/fmt
fi

mkdir -p ${BUILDDIR}
cd ${BUILDDIR}
cp -rf ../../debian .
cp -rf ../../seastar .
cat ../../patches/*.patch | patch -p1 -d seastar

if [ "${TYPE}" = "local" ]; then
	debuild
elif [ "${TYPE}" = "ppa" ]; then
	debuild -S -sa
else
	echo "build.sh {local,ppa}"
	exit 1
fi

