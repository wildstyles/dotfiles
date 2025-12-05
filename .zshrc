export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm (takes 200ms)
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export PNPM_HOME="/Users/ruslanvanzula/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# brew install zsh-autosuggestions is needed before
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

ZVM_VI_INSERT_ESCAPE_BINDKEY=nn
function zvm_after_init() {
  zvm_bindkey viins "^R" fzf-history-widget
}

eval "$(starship init zsh)"

export STARSHIP_CONFIG=~/.config/starship/starship.toml

# ---- Eza (better ls) -----

alias ls="eza --color=always --group-directories-first --git --no-filesize --icons=always --no-time --no-user --no-permissions"

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

alias cd="z"

export EDITOR="nvim"
# lazygit config directory
export XDG_CONFIG_HOME="$HOME/.config"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

alias lg="lazygit"
alias t="~/Projects/dotfiles/scripts/translate.sh"
alias n="nvim"

# clear screen + scrollback, but keep your command history
alias cls='clear && printf "\e[3J"'

if [ -f ~/Projects/dotfiles/.env ]; then
  source ~/Projects/dotfiles/.env
fi

# must be at the end of file
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
