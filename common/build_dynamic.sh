#!/usr/bin/env bash
set -e
echo "seastar.so: libseastar.a" > "shared.make"
echo "	g++ -shared -rdynamic -o seastar.so $(pkg-config --libs seastar.pc)" >> shared.make
make -f shared.make

