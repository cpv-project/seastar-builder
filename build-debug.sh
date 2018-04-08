#!/usr/bin/env bash
set -e
COMMON_DIR=$(realpath ./common)
cd ../seastar
if [ ! -f build-debug.ninja ]; then
	./configure.py --mode=debug --with libseastar.a --with seastar.pc
	sh $COMMON_DIR/replace_flags.sh
	mv build.ninja build-debug.ninja
fi
# use single core because it require so much memory (require atleast 3.5G for per core)
ninja -j1 -f ./build-debug.ninja
cd ./build/debug
sh $COMMON_DIR/build_dynamic.sh

