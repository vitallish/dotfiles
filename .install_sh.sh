
[ ! -d "$HOME/.cfg" ] && git clone --bare git@github.com:vitallish/dotfiles.git $HOME/.cfg
git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout main
