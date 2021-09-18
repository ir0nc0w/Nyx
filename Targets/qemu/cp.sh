#!/bin/bash -e

for idx in {0..7};
do
	cp config.ron config$idx.ron
done
