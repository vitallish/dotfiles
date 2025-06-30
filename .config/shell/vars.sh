# shell/vars.sh

. $XDG_CONFIG_HOME/shell/check_os.sh

export VIMCONFIG="$XDG_CONFIG_HOME/nvim"
export VIMDATA="$XDG_DATA_HOME/nvim"
export VISUAL=nvim
export EDITOR=nvim

export HOMEBREW_BUNDLE_FILE_GLOBAL="$XDG_CONFIG_HOME/homebrew/Brewfile"

if [[ "$VAKD_COMP_OWNER" == "AZ" ]]; then
  export HOMEBREW_BUNDLE_FILE_GLOBAL="$HOMEBREW_BUNDLE_FILE_GLOBAL.az"
fi


export SCRIPTS="$XDG_CONFIG_HOME/scripts/"

# pipx location
export PATH="$PATH:$HOME/.local/bin"

