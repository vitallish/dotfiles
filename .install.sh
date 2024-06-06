#!/bin/zsh

sudo apt-get install -y \
	kitty \
	tmux \
	vim 

sudo apt-get install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mkdir -p /opt/nvim
mv nvim.appimage /opt/nvim/nvim


curl -o beeper https://download.beeper.com/linux/appImage/x64
chmod u+x beeper
sudo mkdir -p /opt/beeper
sudo mv beeper /opt/beeper/beeper


sudo apt install openssh-server
## Formulae
echo "Installing Brew Formulae..."
### Essentials
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
##sudo apt-get -y install podman
curl -o ~/Downloads/code.deb -L https://code.visualstudio.com/sha/download\?build\=stable\&os\=linux-deb-x64
sudo apt install ~/Downloads/code.deb
rm ~/Downloads/code.deb
# used to by nvim.obsidian plugin for quick switching
sudo apt install ripgrep 
curl -fsSL https://tailscale.com/install.sh | sh
# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

sudo apt install -y htop

# Install latest R version
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
sudo apt update
sudo apt install r-base

# docker setup
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
# add user to docker

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/vitalydruker/.zshrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

sudo apt-get install build-essential

sudo apt-get install podman


wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip \
&& cd ~/.local/share/fonts \
&& unzip FiraCode.zip \
&& rm FireCode.zip \
&& fc-cache -fv

#
# podman setup
#
# sudo apt install qemu-utils
#sudo mkdir -p /opt/podman/
#sudo mv ~/Downloads/podman-remote-static-linux_amd64 /opt/podman/podman
#podman machine init --cpus 4 -m 16384
# https://github.com/containers/gvisor-tap-vsock/releases

# get git setup
[ ! -d "$HOME/.cfg" ] && git clone --bare git@github.com:vitallish/dotfiles.git $HOME/.cfg
git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout popos

source $HOME/.zshrc
config config --local status.showUntrackedFiles no
# If this is on another computer then update the local repos user.name and user.email
# config config --local user.name
# config config --local user.email

# install weston
#  install waydroid
#
curl https://repo.waydro.id | sudo bash
sudo apt install waydroid -y

# Manual Work
# plex and plexamp from store
#
