#!/bin/bash

mkdir -p tmp/split
mkdir -p minecraft-servers/servers

split_servers() {
	jq -cn --stream 'fromstream(1|truncate_stream(inputs))' minecraft-servers/servers.json > tmp/single.json || exit 1

	pushd tmp/split || exit 1
	split -d -l 100 ../single.json || exit 1
	popd || exit 1 # tmp/split

	local i=0
	for split in ./tmp/split/x*
	do
		i="$((i+1))"
		if ! jq -s . "$split" > "minecraft-servers/servers/$i.json"
		then
			echo "Error: jq slurp failed on $split"
			exit 1
		fi
	done
	rm minecraft-servers/servers.json
	rm -rf tmp
}

split_servers

