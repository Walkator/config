#!/usr/bin/env bash

# If not ran on macOS, exit
if [ "$(uname -s)" != "Darwin" ]; then
	exit 0
fi

# Installs brew and packages from Brewfile
source brew/brew.sh