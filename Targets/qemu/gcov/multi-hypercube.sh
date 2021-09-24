#!/bin/bash -e

./gcov-hypercube.sh 0 usb-xhci qemu0 & echo $! > run.pid0

for idx in {1..7};
do
	nohup ./gcov-hypercube.sh $idx usb-xhci qemu$idx & echo $! > run.pid$idx
done
