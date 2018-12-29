#!/usr/bin/env bash
set -e

VERSION=$(cat ./debian/changelog | head -n 1 | python3 -c "import re;print(re.search('\((.+)\)', input()).groups()[0])")
BUILDDIR=build/seastar-${VERSION}
TYPE=$1

if [ ! -d seastar ]; then
	git clone --recurse-submodules https://github.com/cpv-project/seastar
fi

mkdir -p ${BUILDDIR}
cd ${BUILDDIR}
cp -rf ../../debian .
cp -rf ../../seastar .

if [ "${TYPE}" = "local" ]; then
	debuild
elif [ "${TYPE}" = "ppa" ]; then
	debuild -S -sa
else
	echo "build.sh {local,ppa}"
	exit 1
fi

