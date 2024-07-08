#!/bin/sh
# Insipred by: https://github.com/subicura/settings/blob/main/macos/system_setting.zsh

defaults write com.apple.dock autohide -bool true # Automatically hide and show the Dock
defaults write com.apple.dock mru-spaces -bool false # Disable Automatically rearrange Spaces based on most recent use
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false # Disable correct spelling automatically
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false # Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false # Disable automatic quote substitution
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false # Disable automatic dash substitution