#!/usr/bin/env bash
# break after command error
set -e

# build seastar static and dynamic library
# use single core because it require so much memory (require atleast 3.5G for per core)
cd ../seastar
if [ ! -f build-release.ninja ]; then
	./configure.py --mode=release --with libseastar.a --with seastar.pc
	mv build.ninja build-release.ninja
	sed -i "s/cxxflags =/cxxflags = -fPIC/g" build-release.ninja
	sed -i "s/CARES_STATIC=ON/CARES_STATIC=ON -DCARES_STATIC_PIC=ON/g" build-release.ninja
fi
ninja -j1 -f ./build-release.ninja
cd ./build/release
g++ -shared -o seastar.so $(pkg-config --libs seastar.pc)

