# source global shell alias & variables files
[ -f "$XDG_CONFIG_HOME/shell/vars.sh" ] && source "$XDG_CONFIG_HOME/shell/vars.sh"
[ -f "$XDG_CONFIG_HOME/shell/alias.sh" ] && source "$XDG_CONFIG_HOME/shell/alias.sh"


if [[ "$VAKD_COMP_OWNER" == "AZ" ]]; then
  # this is here as a placeholder - only enable if having issues
  # . $SCRIPTS/azproxy --disable
fi


# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# binds
# https://github.com/BreadOnPenguins/dots/blob/9bee0f03b394f1ff765385ffeee0345e29518d0b/.config/zsh/.zshrc
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^k" kill-line
bindkey "^j" backward-word
bindkey "^k" forward-word
bindkey "^H" backward-kill-word
# ctrl J & K for going up and down in prev commands
bindkey "^J" history-search-forward
bindkey "^K" history-search-backward
bindkey '^R' fzf-history-widget



if [[ "$VAKD_COMP_OWNER" == "AZ" ]]; then
  PROMPT_PRE="%F{magenta}[az]%f"
elif [[ "$VAKD_COMP_OWNER" == "V" ]]; then
  PROMPT_PRE="%F{cyan}[mba]%f"
else
  PROMPT_PRE=""
fi

export PROMPT="$PROMPT_PRE$PROMPT"


eval "$(zoxide init zsh)"

