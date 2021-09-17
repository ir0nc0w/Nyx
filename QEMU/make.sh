#!/bin/bash -e

CUR_PATH=`pwd`

for idx in {0..7};
do
	cd $CUR_PATH/qemu$idx
	cd build

	../configure --target-list=x86_64-softmmu --disable-werror --enable-gcov

	make -j72 &
done
