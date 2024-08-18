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
brew install rsync


brew install --cask macfuse
brew install borgbackup/tap/borgbackup-fuse

brew install borgmatic
brew install node

#DISABLE SIP first
brew install koekeishiya/formulae/yabai
yabai --start-service

brew tap FelixKratz/formulae
brew install borders
brew services start felixkratz/formulae/borders
brew install sketchybar
brew services start sketchybar

# Alfredsxdffew21 requires registration from bitwarden
npm install -g @bitwarden/cli
alias bw='NODE_OPTIONS="--no-deprecation" bw'
echo -n Bitwarden Master: 
read -s BW_PASSWORD
echo

bw login vdruker@gmail.com --passwordenv BW_PASSWORD 
BW_SESSION=$(bw unlock --passwordenv BW_PASSWORD --raw)


echo Install and setup Alfred:

brew install --cask alfred
open /Applications/Alfred\ 5.app
bw get notes alfred
printf "%s " "Press enter to continue:"
read ans

echo install and setup tailscale:
brew install --cask tailscale
Tailscale rungui -d
bw get password 180f93ef-e7c3-4eb8-bbd8-acea00f775fa
printf "%s " "Press enter to continue:"
read ans
# Make sure to make start on login with system preferences

brew install stats
# Rerstore backup from ~/backups/Stats.plist

brew install beeper
brew install --cask font-sauce-code-pro-nerd-font

brew install --cask firefox
brew install --cask docker
brew install --cask bitwarden
brew install --cask visual-studio-code
brew install --cask slack
brew install onlyoffice
brew install thunderbird
brew install --cask clockify
brew install pipx

pipx install ranger-fm

brew tap r-lib/rig
brew install --cask rig
# install latest version of R
rig add release

brew install --cask rstudio
brew install --cask obsidian
brew install --cask parallels
brew install --cask spotify
brew install --cask plexamp
# Place Obsidian into ~/Notes which may need to be created
brew install zotero

## Install dragterm
brew install cocoapods

git clone https://github.com/Wevah/dragterm.git  
cd dragterm/dragterm
g++ DTDraggingSourceView.m main.m  -framework Cocoa -o drag
chmod +x drag
sudo cp drag /usr/local/bin
cd ../..
rm -rf dragterm


brew install fzf
# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install --all

# used to by nvim.obsidian plugin for quick switching
brew install ripgrep 

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Make sure to first copy the .ssh folder from a working computer/set up key
# Also remove the current .zshrc file as it needs to be overwritten

[ ! -d "$HOME/.cfg" ] && git clone --bare git@github.com:vitallish/dotfiles.git $HOME/.cfg
git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout main

source $HOME/.zshrc
config config --local status.showUntrackedFiles no
# If this is on another computer then update the local repos user.name and user.email
# config config --local user.name
# config config --local user.email

# Create new borgamatic backup
# Update the repo information in 
#
# Other apps to install 
# Adobe Lightroom Classic
#   https://creativecloud.adobe.com/apps/download/lightroom-classic
#   Login with google vitaly@westendstats.com
# Other Items
#   Automatically add home to login
#
#
# Restore from borgmatic:
#   ~/Photos
#
#
#
#
# https://stackoverflow.com/questions/39972335/how-do-i-press-and-hold-a-key-and-have-it-repeat-in-vscode
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false


borgmatic extract --archive latest --path Users/vitalydruker/backups --destination ~/tmp/
mv ~/tmp/Users/vitalydruker/backups ~

borgmatic extract --archive latest --path "Users/vitalydruker/Application Settings" --destination ~/tmp/
mv ~/tmp/Users/vitalydruker/Application\ Settings ~



