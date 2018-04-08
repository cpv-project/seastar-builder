#!/usr/bin/env bash
set -e
sed -i "s/cxxflags =/cxxflags = -fPIC/g" build.ninja
sed -i "s/CARES_STATIC=ON/CARES_STATIC=ON -DCARES_STATIC_PIC=ON/g" build.ninja

