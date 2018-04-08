#!/usr/bin/env bash
# break after command error
set -e

# clean seastar
cd ../seastar
rm -fv build*.ninja
rm -rfv build

