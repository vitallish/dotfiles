
pkill beeper
sudo curl -o /opt/beeper/beeper https://download.beeper.com/linux/appImage/x64
/opt/beeper/beeper &
disown %1


sudo apt update &&
sudo apt full-upgrade -y &&
sudo apt autoremove -y &&
sudo apt autoclean -y &&
flatpak update -y

