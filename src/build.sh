#!/bin/bash

# This script builds the bs2bconvert binaries for amd64, arm64/aarch64 and amdhf.
# It assumes that it is run on a amd64 linux environment.

# Building for x86_64-linux
docker build -f Dockerfile . -t bs2b
rm -rf "libbs2b-3.1.0"
tar -xvf "libbs2b-3.1.0.tar.bz2"
patch -p0 < fix-stderr.patch
patch -p0 < missing_math_lib.patch
patch -p0 < remove_AC_FUNC_MALLOC.patch

cd "libbs2b-3.1.0/src"
rm Makefile* bs2bstream.c
cp ../../Makefile .
docker run -t --rm -u "${UID}" -v "${PWD}:${PWD}" -w "${PWD}" bs2b sh -c "make"
cp bs2bconvert ../../../Bin/x86_64-linux
cd ../..

# Cross-building for aarch64-linux
docker build -f Dockerfile.arm64 . -t bs2b-arm64
rm -rf "libbs2b-3.1.0"
tar -xvf "libbs2b-3.1.0.tar.bz2"
patch -p0 < fix-stderr.patch
patch -p0 < missing_math_lib.patch
patch -p0 < remove_AC_FUNC_MALLOC.patch

cd "libbs2b-3.1.0/src"
rm Makefile* bs2bstream.c
cp ../../Makefile .
docker run -t --rm -u "${UID}" -v "${PWD}:${PWD}" -w "${PWD}" bs2b-arm64 sh -c "make CC=aarch64-linux-gnu-gcc"
cp bs2bconvert ../../../Bin/aarch64-linux
cd ../..

# Cross-building for armhf-linux
docker build -f Dockerfile.armhf . -t bs2b-armhf
rm -rf "libbs2b-3.1.0"
tar -xvf "libbs2b-3.1.0.tar.bz2"
patch -p0 < fix-stderr.patch
patch -p0 < missing_math_lib.patch
patch -p0 < remove_AC_FUNC_MALLOC.patch

cd "libbs2b-3.1.0/src"
rm Makefile* bs2bstream.c
cp ../../Makefile .
docker run -t --rm -u "${UID}" -v "${PWD}:${PWD}" -w "${PWD}" bs2b-armhf sh -c "make CC=arm-linux-gnueabihf-gcc"
cp bs2bconvert ../../../Bin/armhf-linux
cd ../..

# Cleaning up
rm -rf "libbs2b-3.1.0"
