#!/bin/bash -e

for idx in {0..7};
do
	./gcov.sh $idx $1"-"$idx
done
