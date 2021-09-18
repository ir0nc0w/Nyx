#!/bin/bash -e

for idx in {0..7};
do
	cp -r ./pre_snapshot ./pre_snapshot"$idx"
done
