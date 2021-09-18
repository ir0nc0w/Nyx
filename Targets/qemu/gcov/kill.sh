#!/bin/bash -e




for pid in `ls run.pid*`;
do
	kill $(cat $pid)
done
