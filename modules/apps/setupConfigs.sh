#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/../.." && pwd)"

echo 'Installing application configuration...'

# Darktable reads its GTK stylesheet from this directory on macOS.
"$REPO_DIR/darktable/setupStyle.sh"

# LinearMouse stores its imported configuration in Application Support.
LINEARMOUSE_DIR="$HOME/Library/Application Support/LinearMouse"
mkdir -p "$LINEARMOUSE_DIR"
cp "$REPO_DIR/linearMouse/linearmouse.json" "$LINEARMOUSE_DIR/linearmouse.json"
