# .bashrc

# Source global definitions
#if [ -f /etc/bashrc ]; then
#  . /etc/bashrc
#fi

# Umask
umask 066

# Environmental Variables
export PAGER=less
export LESS='-X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export RSYNC_RSH=ssh
shopt -u sourcepath
export HISTTIMEFORMAT='@"%Y-%m-%d %T" -- '

# User specific aliases and functions
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

if [[ "$PS1" ]]; then
  HISTSIZE=50000
  HISTFILESIZE=50000
  shopt -s histappend
  shopt -s histverify
  shopt -s histreedit
  shopt -s no_empty_cmd_completion

  function i {
    if [ "$1" ]; then
      history 1000 | grep "$@"
    else
      history 30
    fi
  }

  function I {
    if [ "$1" ]; then
      history | grep "$@"
    else
      history 30
    fi
  }

  #tty | sed -e "s/\// /g" | awk '{print $2}' > $path_file_tty && screen
  path_file_tty=~/.tty
  if [ ! -f $path_file_tty ]; then
    echo "screen" > $path_file_tty
  fi
  str_tty_from_command=`tty | sed -e "s/\// /g" | awk '{print $2}'`
  str_tty_from_file=`head -1 $path_file_tty`
  if [ $str_tty_from_command == $str_tty_from_file ]; then
    str_tty=$str_tty_from_command
  elif [ $str_tty_from_file != "screen" ]; then
    str_tty=$str_tty_from_file
  else
    str_tty="screen"
  fi
  if [ $TERM == "screen" ]; then
    PS1="[\u@\h($str_tty) \W]\\$ "
  else
    #PS1="[\u@\h \W]\\$ "
    PS1="\t[\u@\h \W]\\$ "
  fi

  h2=`expr $HOSTNAME : '\(..\).*'`
  u2=`expr $USER : '\(.\).*'`
  PS0="$u2@$h2:\[\e[${col}m\]\W[\!]\$\[\e[m\]"
  function px {
    local tmp=$PS1
    PS1=$PS0
    PS0=$tmp
  }

  function wi {
    case `type -t "$1"` in
      alias|function) type "$1";;
      file) L `command -v "$1"`;;
      function) type "$1";;
    esac
  }

  function j { jobs -l; }
fi

PATH=$PATH:$HOME/Dropbox/usr/local/bin
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

PATH=$PATH:/usr/local/glusterfs/sbin
MANPATH=$MANPATH:/usr/local/glusterfs/share/man
PATH=$PATH:/usr/lib64/fluent/ruby/bin
