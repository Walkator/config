#!/usr/bin/env bash

# If not ran on macOS, exit
if [ "$(uname -s)" != "Darwin" ]; then
	exit 0
fi

# Installs brew and packages from Brewfile
source brew/brew.sh

# Changes defaults macOS preferences
source modules/defaultConfigs.sh

# Changes defaults macOS privacy
source modules/privacy/enablePrivacy.sh


echo 'Some commands here require restart! Please do that for them to take effect.'