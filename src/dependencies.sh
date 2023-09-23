#!/bin/bash

dep_cargo() {
	[ ! -x "$(command -v cargo)" ] || return

	if ! curl https://sh.rustup.rs -sSf | sh -s -- -y
	then
		err "Failed to install cargo"
		exit 1
	fi
}

dep_masscan() {
	PATH="$PATH:./tools/masscan/bin"
	[ -f tools/masscan/bin/masscan ] && return

	mkdir -p tools
	pushd tools || exit 1
	[[ -d masscan ]] || git clone https://github.com/robertdavidgraham/masscan
	pushd masscan || exit 1
	make
	popd || exit 1 # masscan
	popd || exit 1 # tools
}

dep_ccheck() {
	PATH="$PATH:./tools/ccheck/target/release/"
	[ -f tools/ccheck/target/release/ccheck ] && return

	dep_cargo
	mkdir -p tools
	pushd tools || exit 1
	[[ -d ccheck ]] || git clone https://github.com/cleonyc/ccheck.git
	pushd ccheck || exit 1
	cargo build --release
	popd || exit 1 # ccheck
	popd || exit 1 # tools
}

check_deps() {
	dep_ccheck
	dep_masscan
}

check_deps

