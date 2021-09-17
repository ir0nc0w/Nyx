#!/bin/bash -e

./gcov.sh 0 usb-xhci qemu0 &

for idx in {1..7};
do
	nohup ./gcov.sh $idx usb-xhci qemu$idx & echo $! > run.pid$idx
done
