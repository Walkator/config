#!/usr/bin/env bash

# If not ran on macOS, exit
if [ "$(uname -s)" != "Darwin" ]; then
	exit 0
fi

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install some tools
brew install openssh
brew install git
brew install tree
brew install htop
brew install neofetch
brew install clamav
brew install --cask darktable
brew install --cask hot
brew install --cask flux
brew install --cask aldente
brew install --cask cleanme
brew install --cask coconutbattery
brew install --cask rar

# Remove outdated versions from the cellar.
brew cleanup