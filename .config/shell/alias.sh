# shell/alias.sh

alias vim=nvim
alias vi=nvim

alias tt=taskwarrior-tui
alias tx=tmuxinator

alias qb="$SCRIPTS/qbprof.sh"

alias bbd="brew bundle --global dump"
alias bbi="brew bundle --global install"
alias bbc="brew bundle --global check"
alias bbu="brew bundle --global cleanup"


# For use with dotfile config
# https://www.atlassian.com/git/tutorials/dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias lazyconfig='lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'
# Temp workaround to disable punycode deprecation logging to stderr
# https://github.com/bitwarden/clients/issues/6689
alias bw='NODE_OPTIONS="--no-deprecation" bw'
  
if [[ "$VAKD_COMP_OWNER" == "AZ" ]]; then
  . $XDG_CONFIG_HOME/shell/alias-az.sh
fi

