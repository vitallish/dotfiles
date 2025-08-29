# Notes from installation
# I was unable to make windows installation media from fedora, had to use parallels on mac to make it lol
# I had a lot fo trouble getting the partitions right for fedora. I think the main problem was that I shouldn't have a swap partition - maybe it's not needed anymore
# 
#

sudo dnf install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf clean all && sudo dnf makecache


sudo dnf install neovim wlogout btop lm_sensors git stress-ng zsh util-linux podman flatpak bat libreoffice git-delt qutebrowser  libavcodec-freeworld fzf pipx openssl
sudo dnf install kitty
sudo dnf install fuse fuse-libs

# install homebrew (unclear if helpful to be honest)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# homebrew development tools
sudo dnf group install development-tools

curl -fsSL https://ollama.com/install.sh | sh

# after installing windows
# this automatically identified the windows boot record and added it to GRUB2
#sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# enable third part software
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
# not sure what the next line is....
# https://docs.fedoraproject.org/en-US/gaming/proton/
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

# vscode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update
sudo dnf install code # or code-insiders

mkdir -p $HOME/projects


flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# generate new ssh key and add to agent
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
# ssh-add ~/.ssh/id_ed25519

flatpak install flathub org.mozilla.Thunderbird 
flatpak install flathub com.bitwarden.desktop
flatpak install flathub md.obsidian.Obsidian
flatpak install flathub com.plexamp.Plexamp
flatpak install flathub org.darktable.Darktable

# probable will have to move .zshrc as ohmyzh overwrites it. Maybe there is a way to update this
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


`which sudo` yum install -y https://github.com/r-lib/rig/releases/download/latest/r-rig-latest-1.$(arch).rpm
rig add release
# install other dependencies (xml)
sudo dnf install libxml2-devel

# install tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

sudo systemctl enable --now tailscaled
systemctl start sshd.service
systemctl enable sshd.service
sudo dnf install gh


sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit



sudo dnf install syncthing
sudo systemctl enable syncthing@vitalydruker.service
sudo systemctl start syncthing@vitalydruker.service

# install am ins

# make sure to run the appimage update script in the scripts folder
#
# borg/borgmatic

sudo dnf install borg borgmatic


sudo dnf install task timew
# https://major.io/p/amd-gpu-missing-btop/
# needed so that btop can show GPU stats
sudo dnf install rocm-smi
flatpak install com.spotify.Client


sudo dnf copr enable lilay/topgrade
sudo dnf install topgrade
# add calculation to rofi
sudo dnf install qalculate meson libtool cairo-devel rofi-devel

#yazi install
sudo dnf copr enable lihaohong/yazi
sudo dnf install yazi gtk3-devel
# install https://github.com/mwh/dragon#

