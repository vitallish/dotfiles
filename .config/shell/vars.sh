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

if command -v bat >/dev/null 2>&1
then
  # use bat for man
  export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
fi

export SCRIPTS="$XDG_CONFIG_HOME/scripts/"
export VAKD_VENVS="$XDG_DATA_HOME/venvs"

# pipx location
export PATH="$PATH:$HOME/.local/bin"

# cargo location
export PATH="$HOME/.cargo/bin:$PATH"

# setup homebrew variables. Usually I think this is
# in your .bash_profile file but this makes it available for different shells
if [[ "$VAKD_COMP_OS" == Linux* ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else 
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
