#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# If not ran on macOS, exit
if [ "$(uname -s)" != "Darwin" ]; then
	exit 0
fi

# This configuration is intentionally limited to Apple Silicon Macs.
if [ "$(uname -m)" != "arm64" ]; then
	echo "This configuration is only supported on Apple Silicon (arm64)." >&2
	exit 1
fi

# Installs brew and packages from Brewfile
source "$SCRIPT_DIR/modules/brew/brew.sh"

# Changes defaults macOS preferences
source "$SCRIPT_DIR/modules/defaultConfigs.sh"

# Installs application-specific configuration files
"$SCRIPT_DIR/modules/apps/setupConfigs.sh"

# Changes defaults macOS privacy
"$SCRIPT_DIR/modules/privacy/enablePrivacy.sh"


echo 'Some commands here require restart! Please do that for them to take effect.'
