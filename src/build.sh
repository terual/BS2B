#!/bin/bash

docker build . -t bs2b

rm -rf "libbs2b-3.1.0"
tar -xvf "libbs2b-3.1.0.tar.bz2"
patch -p0 < fix-stderr.patch

cd "libbs2b-3.1.0"
docker run -t --rm -u "${UID}" -v "${PWD}:${PWD}" -w "${PWD}" \
	bs2b \
	sh -c "./configure --help && LIBS=-lm ./configure --enable-static --disable-shared && make"


