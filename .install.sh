#!/bin/zsh

# Install xCode cli tools
echo "Installing commandline tools..."
xcode-select --install

# Homebrew
## Install
echo "Installing Brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

## Formulae
echo "Installing Brew Formulae..."
### Essentials
brew install wget
brew install jq
brew install mas
brew install ifstat
brew install switchaudio-osx
brew install skhd
brew install sketchybar


brew tap FelixKratz/formulae
brew install borders


[ ! -d "$HOME/.cfg" ] && git clone --bare git@github.com:vitallish/dotfiles.git $HOME/.cfg
git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout main

source $HOME/.zshrc
config config --local status.showUntrackedFiles no


brew services start borders

