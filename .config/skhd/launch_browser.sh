source $HOME/.config/shell/xdg.sh
source $HOME/.config/shell/vars.sh

if [[ "$VAKD_COMP_OWNER" == "AZ" ]]; then
  /Applications/qutebrowser.app/Contents/MacOS/qutebrowser
else
  /opt/homebrew/bin/qutebrowser
fi

