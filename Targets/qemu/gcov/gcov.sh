#!/bin/bash -e

QEMU_PATH=/home/cwmyung/study/hyfuzz/src/qemu-5.2/build/x86_64-softmmu
OS_PATH=/home/cwmyung/study/nyx/nyx_fuzzer/hypervisor_spec/build/hypertrash_os
PAYLOAD_DIR=/tmp/workdir_qemu/corpus/dump
GCOV_PATH=`pwd`/gcov

idx=1
prevCnt=0
currCnt=0

#sleep 60

rm -rf $GCOV_PATH/$1
SECONDS=0
while true;
do
	#$QEMU_PATH/qemu-system-x86_64 -m 100 -drive if=none,id=stick,file=/home/cwmyung/study/hyfuzz/src/image/block/usbdisk0.img,format=raw -device nec-usb-xhci,id=usb -device usb-storage,bus=usb.0,drive=stick -net none -pidfile vm.pid

	if [[ $SECONDS -ge 60 ]]; then
		if [[ ! -d $GCOV_PATH/$1/$prevCnt ]]; then
			echo "[!] SECONDS: $SECONDS"
			SECONDS=0
			mkdir -p $GCOV_PATH/$1/$currCnt
			mv $PAYLOAD_DIR/$1/* $GCOV_PATH/$1/$currCnt
			let currCnt=$currCnt+1
		fi
	else
		continue
	fi

	for file in `ls $GCOV_PATH/$1/$prevCnt`;
	do
		echo "[+] SECONDS: $SECONDS"
		if [[ $SECONDS -ge 60 ]]; then
			SECONDS=0
			mkdir -p $GCOV_PATH/$1/$currCnt
			mv $PAYLOAD_DIR/$1/* $GCOV_PATH/$1/$currCnt
			let currCnt=$currCnt+1
		fi

		cd $OS_PATH

		cp $GCOV_PATH/$1/$prevCnt/$file $OS_PATH/misc/crash.hexa

		make hypertrash_os_crash.bin

		# [TIMEOUT] signal SIGKILL after 20 seconds.
		timeout -s 9 20s $QEMU_PATH/qemu-system-x86_64 -cdrom ./iso/hypertrash_os_bios_crash.iso -m 100 -net none -device nec-usb-xhci -display none

		rm $GCOV_PATH/$1/$prevCnt/$file

	done

	python3 $GCOV_PATH/../$2.py $3
	let prevCnt=$prevCnt+1
done
