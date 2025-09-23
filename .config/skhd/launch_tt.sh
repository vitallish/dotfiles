source $HOME/.config/shell/xdg.sh
source $HOME/.config/shell/vars.sh

if [[ "$VAKD_COMP_OWNER" == "AZ" ]]; then
  taskwarrior-tui --report az
else
  taskwarrior-tui --report wes
fi

