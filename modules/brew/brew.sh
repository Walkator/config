#!/usr/bin/env bash

# Brew install and setup
echo -e "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Enables brew in current env
eval "$(/opt/homebrew/bin/brew shellenv)"

# Disables brew telemetry
echo -e "Disabling Homebrew telemetry..."
brew analytics off

# Brew Apps installed from Brewfile
echo -e "Installing apps..."
brew bundle install --file ./brew/Brewfile

# Remove outdated versions from the cellar.
brew cleanup