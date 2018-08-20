_check_cmd screen
if test $? -eq 0; then
  # alias screen='screen -t "`date "+%m%d%H%M%S"`" -U -d -R'
  # alias screen='screen -t "" -U -d -R'
  # alias screen='screen -t "" -U'
  alias screen='screen -t ""'
  alias s='screen'
  alias r='screen -r'
  alias d='screen -rd'
  alias x='screen -rx'
  alias sl='s -ls'
fi

#preexec () {
#  [ ${STY} ] && echo -ne "\ek${1%% *}\e\\"
#}
#[ ${STY} ] || screen -rx || screen -D -RR
#### /GNU screen

autoload -U compinit
compinit -u

# export LANG=ja_JP.UTF-8
limit coredumpsize 102400
setopt nobeep

[[ -s $HOME/.screeninator/scripts/screeninator ]] && source $HOME/.screeninator/scripts/screeninator

