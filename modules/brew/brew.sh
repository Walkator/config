#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [ "$(uname -s)" != "Darwin" ] || [ "$(uname -m)" != "arm64" ]; then
    echo "Homebrew setup is only supported on Apple Silicon macOS." >&2
    exit 1
fi

# Brew install and setup
echo -e "Installing Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Enables brew in current env
eval "$(/opt/homebrew/bin/brew shellenv)"

# Disables brew telemetry
echo -e "Disabling Homebrew telemetry..."
brew analytics off

# Brew Apps installed from Brewfile
echo -e "Installing apps..."
brew bundle install --file "$SCRIPT_DIR/Brewfile"

# Remove outdated versions from the cellar.
brew cleanup
