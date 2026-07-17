#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="$HOME/.config/darktable"

mkdir -p "$DEST_DIR"
cp "$SCRIPT_DIR/user.css" "$DEST_DIR/user.css"
