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
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

brew install wget
brew install nvim
brew install jq
brew install mas
brew install ifstat
brew install switchaudio-osx
brew install koekeishiya/formulae/skhd
skhd --start-service
brew install tmux
brew install kitty

#DISABLE SIP first
brew install koekeishiya/formulae/yabai
yabai --start-service

brew tap FelixKratz/formulae
brew install borders
brew install sketchybar

[ ! -d "$HOME/.cfg" ] && git clone --bare git@github.com:vitallish/dotfiles.git $HOME/.cfg
git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout main

source $HOME/.zshrc
config config --local status.showUntrackedFiles no
# If this is on another computer then update the local repos user.name and user.email
# config config --local user.name
# config config --local user.email



brew services start borders

