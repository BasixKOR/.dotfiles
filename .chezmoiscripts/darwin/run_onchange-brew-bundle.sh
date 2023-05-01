#!/bin/sh

if command -v brew; then
	brew bundle --global -q
else
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	/bin/bash -c "brew bundle --global"
fi