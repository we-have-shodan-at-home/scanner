#!/bin/bash

source src/include.sh

if [ -f masscan.json ]
then
	if [ -d minecraft-servers/tmp ]
	then
		rm -rf minecraft-servers/tmp
	fi
	mkdir -p minecraft-servers/tmp
	ts="$(date '+%F_%H-%M')"
	mkdir -p minecraft-servers/scans
	if [ -s masscan.json ]
	then
		mv masscan.json "minecraft-servers/scans/masscan_$ts.json"
	fi
	i=0
	for scan in ./minecraft-servers/scans/*.json
	do
		ccheck scan -p "$scan" "minecraft-servers/tmp/servers_$i.json"
		i="$((i+1))"
	done
	if ! find ./minecraft-servers/tmp/ -mindepth 1 -maxdepth 1 -name '*.json' -exec jq '.[]' {} \; | jq --slurp . > minecraft-servers/servers.json
	then
		err "json merge failed"
	fi
fi

if [ -f paused.conf ]
then
	sudo masscan --resume=paused.conf --excludefile exclude.conf
else
	sudo masscan -p 25565 0.0.0.0/0 --rate=2 --excludefile exclude.conf --banners -oJ masscan.json
fi

