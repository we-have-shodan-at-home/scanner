#!/bin/bash

source src/include.sh

if [ -f masscan.json ]
then
	ccheck scan -p masscan.json servers.json
fi

if [ -f paused.conf ]
then
	sudo masscan --resume=paused.conf --excludefile exclude.conf
else
	sudo masscan -p 25565 0.0.0.0/0 --rate=2 --excludefile exclude.conf --banners -oJ masscan.json
fi

