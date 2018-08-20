_check_cmd(){
  if test x$1 \=\= x; then return 1; fi
  _ret=1
  if test `which $1 > /dev/null 2>&1; echo $?` -eq 0; then _ret=0; fi
  return $_ret
}

_activate_venv(){
  if [ -d .venv ]; then
    source .venv/bin/activate
  fi
}

precmd() {
  # tmux
  _check_cmd tmux
  if test $? -eq 0; then
    if test `tmux list-sessions > /dev/null 2>&1; echo $?` -eq 0; then
      case x"$ZSH_PROMPT_TYPE" in
        x"0") zsh_set_tmux_for_prompt_type_0 ;;
        x"1") zsh_set_tmux_for_prompt_type_1 ;;
        *   ) zsh_set_tmux_for_prompt_type_1 ;;
      esac
      if test x$ZSH_TMUX_RENAME_WINDOW_CONFIGURED != x1; then
        LANG=en_US.UTF-8 vcs_info
        [[ -n ${vcs_info_msg_0_} ]] && tmux rename-window $vcs_info_msg_0_
        export ZSH_TMUX_RENAME_WINDOW_CONFIGURED=1
      fi
    fi
  fi
}

# chpwd() {
# }

chpwd() {
  [[ -t 1 ]] || return
  case $TERM in
    sun-cmd)
      print -Pn "\e]l%~\e\\"
      ;;
    *xterm*|rxvt|(dt|k|E)term|screen)
      print -Pn "\e]2;%~\a"
      ;;
  esac
  mkdir -p /tmp/rm/`date +%Y-%m-%d`

  _activate_venv
}

preexec() {
#  if test x"$PATH_THELATESTDIR0" != x"`pwd`"; then
#    export PATH_THELATESTDIR1=$PATH_THELATESTDIR0
#    export PATH_THELATESTDIR0=`pwd`
#    alias cdback="cd $PATH_THELATESTDIR1"
#  fi
}


# Prompt ==============================


zsh_set_tmux_for_prompt_type_0() {
  #tmux set -qg status-right "Session:#S Pane:#P $(pwd) |#[fg=colour255,bg=colour234] #(~/bin/battery Discharging)#(~/bin/battery Charging)#(uptime | cut -d "," -f 3-) #[fg=colour234,bg=colour255,bold]%Y-%m-%d %H:%M %a#[default]"
  tmux set -qg status-left "S#S P#P ["
  tmux set -qg status-right "] #[fg=magenta,bg=colour234]$(whoami)#[default]@$(hostname -s):#[fg=green,bg=colour234]$(pwd) #[fg=colour234,bg=colour255,bold]%Y-%m-%d %H:%M %a#[default]"
}

zsh_set_tmux_for_prompt_type_1() {
  #tmux set -qg status-left "#[fg=white,bg=black,bold]#I/#[fg=black,bg=colour202,bold]#20(whoami)@#h#[deafult]"
  tmux set -qg status-left '#[fg=white,bg=black,bold]S#S I#I P#P #[fg=black,bg=colour202,bold]#h#[default] ['
  tmux set -qg status-right "] #[fg=colour255,bg=colour234] Batt[#(~/bin/battery Discharging)#(~/bin/battery Charging)]#(uptime | cut -d "," -f 3- | sed 's/load averages: /Ld.Avg[/g')] #[fg=colour234,bg=colour255,bold]%m-%d %H:%M %a#[default]"
}

zsh_set_prompt_type_0() {
  export ZSH_PROMPT_TYPE=0
  PROMPT="%{${fg[cyan]}%}%# %{${reset_color}%}"
  PROMPT2="%{${fg[red]}%}[%n@%m] %{${reset_color}%}"
  RPROMPT="%{${reset_color}%}"
  SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
}

zsh_set_prompt_type_1() {
  export ZSH_PROMPT_TYPE=1
  PROMPT="%{${fg[cyan]}%}[20%D %*]%# %{${reset_color}%}"
  PROMPT2="%{${fg[red]}%}[%n@%m] %{${reset_color}%}"
  if [ $TERM \=\= "screen" ]; then
    RPROMPT="%{${fg[magenta]}%}[S]`echo $STY | sed 's/\./ /g' | awk '{print $1}'` %n%{${fg[white]}%}@%m:%{${fg[green]}%}%/ %{${reset_color}%}"
  else
    RPROMPT="%{${fg[magenta]}%}%n%{${fg[white]}%}@%m:%{${fg[green]}%}%/ %{${reset_color}%}"
  fi
  SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
}

zsh_switch_prompt() {
  case x"$ZSH_PROMPT_TYPE" in
    x"0") zsh_set_prompt_type_1 ;;
    x"1") zsh_set_prompt_type_0 ;;
    *) ;;
  esac
}

sw() {
  zsh_switch_prompt
}

# zsh_set_prompt_type_1
# =====================================

