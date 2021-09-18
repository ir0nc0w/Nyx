#!/bin/bash -e
PROJECT_PATH="$(cd "$(dirname "$BASH_SOURCE")/../../.."; pwd -P)"
QEMU_PATH=$PROJECT_PATH/QEMU
OS_PATH=$PROJECT_PATH/nyx_fuzzer/hypervisor_spec/build/hypertrash_os"$1"
PAYLOAD_DIR=$PROJECT_PATH/workdir_qemu"$1"/corpus/dump
GCOV_PATH=$PROJECT_PATH/Targets/qemu/gcov/gcov

TIMEOUT=600
idx=1
prevCnt=0
currCnt=0

# ex) ./gcov.sh 0 usb-xhci qemu0 

cp usbdisk.img usbdisk"$1".img
rm -rf $GCOV_PATH
mkdir -p $GCOV_PATH
rm -rf $GCOV_PATH/$1
SECONDS=0
while true;
do
	#$QEMU_PATH/qemu-system-x86_64 -m 100 -drive if=none,id=stick,file=/home/cwmyung/study/hyfuzz/src/image/block/usbdisk0.img,format=raw -device nec-usb-xhci,id=usb -device usb-storage,bus=usb.0,drive=stick -net none -pidfile vm.pid

	if [[ $SECONDS -ge $TIMEOUT ]]; then
		if [[ ! -d $GCOV_PATH/$1/$prevCnt ]]; then
			echo "[!] SECONDS: $SECONDS"
			SECONDS=0
			mkdir -p $GCOV_PATH/$1/$currCnt
			mv $PAYLOAD_DIR/$1/* $GCOV_PATH/$1/$currCnt || true
			let currCnt=$currCnt+1
		fi
	else
		continue
	fi

	for file in `ls $GCOV_PATH/$1/$prevCnt`;
	do
		echo "[+] SECONDS: $SECONDS"
		if [[ $SECONDS -ge $TIMEOUT ]]; then
			SECONDS=0
			mkdir -p $GCOV_PATH/$1/$currCnt
			mv $PAYLOAD_DIR/$1/* $GCOV_PATH/$1/$currCnt || true
			let currCnt=$currCnt+1
		fi

		cd $OS_PATH

		cp $GCOV_PATH/$1/$prevCnt/$file $OS_PATH/misc/crash.hexa

		make hypertrash_os_crash.bin

		# [TIMEOUT] signal SIGKILL after 20 seconds.
		echo "$QEMU_PATH/qemu"$1"/build/qemu-system-x86_64 -cdrom $OS_PATH/iso/hypertrash_os_bios_crash.iso -m 100 -net none -drive if=none,id=stick,file=$GCOV_PATH/../usbdisk"$1".img,format=raw -device nec-usb-xhci,id=usb -device usb-storage,bus=usb.0,drive=stick -display none"
		timeout -s 9 20s $QEMU_PATH/qemu"$1"/build/qemu-system-x86_64 -cdrom $OS_PATH/iso/hypertrash_os_bios_crash.iso -m 100 -device virtio-gpu-pci -drive if=none,id=stick,file=$GCOV_PATH/../usbdisk"$1".img,format=raw -device nec-usb-xhci,id=usb -device usb-storage,bus=usb.0,drive=stick -display none || true

		rm $GCOV_PATH/$1/$prevCnt/$file

	done

	python3 $GCOV_PATH/../$2.py $3
	let prevCnt=$prevCnt+1
done
