#!/usr/bin/env bash
set -e
sed -i "s/Protobuf 3.3.0 REQUIRED/Protobuf 3.0.0 REQUIRED/g" cmake/SeastarConfig.cmake.in || true
sed -i "s/yaml-cpp 0.5.3 REQUIRED/yaml-cpp 0.5.2 REQUIRED/g" cmake/SeastarConfig.cmake.in || true
sed -i "s/Protobuf 3.3.0 REQUIRED/Protobuf 3.0.0 REQUIRED/g" CMakeLists.txt || true
sed -i "s/yaml-cpp 0.5.3 REQUIRED/yaml-cpp 0.5.2 REQUIRED/g" CMakeLists.txt || true
sed -i "s/seastar STATIC/seastar SHARED/g" CMakeLists.txt || true
sed -i "s/protobuf >= 3.3.0/protobuf >= 3.0.0/g" pkgconfig/seastar.pc.in || true
sed -i "s/yaml-cpp >= 0.5.3/yaml-cpp >= 0.5.2/g" pkgconfig/seastar.pc.in || true

