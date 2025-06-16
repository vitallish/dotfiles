#!/bin/zsh

# Install xCode cli tools
echo "Installing commandline tools..."
xcode-select --install

# Homebrew
## Install
echo "Installing Brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

# Make sure to first copy the .ssh folder from a working computer/set up key
[ ! -d "$HOME/.cfg" ] && git clone --bare git@github.com:vitallish/dotfiles.git $HOME/.cfg
git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout main

## Formulae
. $HOME/.config/shell/xdg.sh
. $XDG_CONFIG_HOME/shell/vars.sh

echo "Restoring from Brewfile at $HOMEBREW_BREWFILE"
brew bundle --global

. $HOME/.zprofile
. $XDG_CONFIG_HOME/zsh/.zshrc

### Essentials

# Oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


# Alfredsxdffew21 requires registration from bitwarden
npm install -g @bitwarden/cli
alias bw='NODE_OPTIONS="--no-deprecation" bw'
echo -n Bitwarden Master: 
read -s BW_PASSWORD
echo

bw login vdruker@gmail.com --passwordenv BW_PASSWORD 
BW_SESSION=$(bw unlock --passwordenv BW_PASSWORD --raw)


open /Applications/Alfred\ 5.app
bw get notes alfred
printf "%s " "Press enter to continue:"
read ans

echo  setup tailscale:
Tailscale rungui -d
bw get password 180f93ef-e7c3-4eb8-bbd8-acea00f775fa
printf "%s " "Press enter to continue:"
read ans
# Make sure to make start on login with system preferences


pipx install ranger-fm
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
pipx install radian

# install latest version of R
rig add release

## Install dragterm
git clone https://github.com/Wevah/dragterm.git  
cd dragterm/dragterm
g++ DTDraggingSourceView.m main.m  -framework Cocoa -o drag
chmod +x drag
sudo cp drag /usr/local/bin
cd ../..
rm -rf dragterm


# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install --all

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


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
#defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

#
# #borgmatic extract --archive latest --path Users/vitalydruker/backups --destination ~/tmp/
# mv ~/tmp/Users/vitalydruker/backups ~
#
# borgmatic extract --archive latest --path "Users/vitalydruker/Application Settings" --destination ~/tmp/
# mv ~/tmp/Users/vitalydruker/Application\ Settings ~
#
# # python virtual environments
# python3 -m venv ~/.virtualenvs/timewarrior
# python3 -m venv ~/.virtualenvs/nvim
# python3 -m venv ~/.virtualenvs/qutebrowser/
#

# options
# https://github.com/davidosomething/dotfiles/blob/dev/mac/defaults
# disable .DS_Store on network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE


# Install spotify player
# install rust
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# cargo install spotify_player --locked --features image,notify,fzfspotify_
#
