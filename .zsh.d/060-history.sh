HISTFILE=${HOME}/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

setopt inc_append_history # append_history | inc_append_history
setopt extended_history
setopt bang_hist
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_store
setopt hist_verify
setopt share_history

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

zshaddhistory() {
  local line=${1%%$'\n'}
  local cmd=${line%% *}

  [[ ${#line} -ge 5
    && ${cmd} != (l[salf])
    && ${cmd} != (man)
  ]]
}

