_check_cmd tmux
if test $? -eq 0; then
  [[ -s "$HOME/.tmuxinator/scripts/tmuxinator" ]] && source "$HOME/.tmuxinator/scripts/tmuxinator"
  alias tmux-session-save='tmux-session save'
  alias tmux-session-restore='tmux-session restore'
fi

_check_cmd tmux
if test $? -eq 0; then
  tmux_osx_conf="$HOME/.tmux-osx.conf"
  if test x`uname -s` \=\= x"Darwin" && test -f $tmux_osx_conf; then
    alias tmux="tmux -f $tmux_osx_conf"
  fi
  alias t='tmux'
  alias tmux-new-window='tmux new-window'
  alias tmux-kill-window='tmux kill-window'
  alias tmux-new-session='tmux new'
  alias tmux-attach-session='tmux attach'
  alias tmux-detach-client='tmux detach'
  alias tmux-kill-server='tmux kill-server'
  alias tmux-kill-session='tmux kill-session'
  alias tmux-list-clients='tmux lsc'
  alias tmux-list-commands='tmux lscm'
  alias tmux-list-sessions='tmux ls'
  alias tmux-lock-client='tmux lockc'
  alias tmux-lock-session='tmux locks'
  alias tmux-refresh-client='tmux refresh'
  alias tmux-rename-session='tmux rename'
  alias tmux-show-messages='tmux showmsgs'
  alias tmux-source-file='tmux source'
  alias tmux-start-server='tmux start'
  alias tmux-suspend-client='tmux suspendc'
  alias tmux-switch-client='tmux switchc'
fi

