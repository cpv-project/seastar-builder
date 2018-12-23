#!/usr/bin/env bash
set -e

# allocator:
#	by default memory are allocated from seastar's allocator,
#	to use default glibc allocator add -DSEASTAR_DEFAULT_ALLOCATOR to cflags
# tls model:
#	access tls in shared library are slow,
#	the cflag -ftls-model=initial-exec can avoid the performance impact,
#	but the library will no longer support dlopen

python3 configure.py --disable-hwloc --prefix=/usr \
	--cflags="-ftls-model=initial-exec -fPIC -fvisibility=default" \
	--mode release --without-tests --without-apps --without-demos

# cpu cores:
#	use single core here, because the memory usage is high
#	(3.5G * cores)

cd ./build/release
ninja -j1 -f ./build.ninja

