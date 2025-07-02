# shell/alias.sh

alias vim=nvim
alias vi=nvim

alias tt=taskwarrior-tui
alias tx=tmuxinator

alias qb="$SCRIPTS/qbprof.sh"

alias bb="brew bundle --global --no-vscode"
alias bbd="bb dump"
alias bbi="bb install"
alias bbc="bb check"
alias bbu="bb cleanup"


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

if [[ $VAKD_COMP_OS == Linux* ]]; then
  . $XDG_CONFIG_HOME/shell/alias-linux.sh
fi

