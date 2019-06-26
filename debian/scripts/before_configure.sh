#!/usr/bin/env bash
set -e
sed -i "s/seastar STATIC/seastar SHARED/g" CMakeLists.txt || true
sed -i "s/add_library (seastar_testing/add_library (seastar_testing SHARED/g" CMakeLists.txt || true

