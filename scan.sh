#!/bin/bash

if [ -f paused.conf ]
then
	sudo masscan --resume=paused.conf --excludefile exclude.conf
else
	sudo masscan -p25565 0.0.0.0/0 --rate=2 --excludefile exclude.conf -oL masscan.txt
fi

