#!/usr/bin/env bash
set -e
COMMON_DIR=$(realpath ./common)
cd ./seastar
if [ ! -f ./build/release/build.ninja ]; then
	sh $COMMON_DIR/before_configure.sh
	./configure.py --disable-hwloc --prefix=/usr \
		--cflags="-DSEASTAR_DEFAULT_ALLOCATOR -fPIC -fvisibility=default" \
		--mode release --without-tests --without-apps --without-demos
fi
# use single core because it require too much memory (atleast 3.5G for per core)
cd ./build/release
ninja -j1 -f ./build.ninja

