# .zshrc
# http://zsh.sourceforge.net/Doc/Release/zsh_toc.html
# http://zsh.sourceforge.net/Guide/zshguide.html
# http://zsh.sourceforge.net/FAQ/

if test x$LOGLEVEL == x; then
  LOGLEVEL=error
fi


#######################################
# .zsh.d fragment
#######################################

case $LOGLEVEL in
  debug)
    echo "DEBUG: HOME = ${HOME}"
    ;;
  info)
    echo -n "."
    ;;
esac
if test -d "${HOME}/.zsh.d"; then
  for f in `find ${HOME}/.zsh.d/ -name '*.sh'` ; do
      case $LOGLEVEL in
        debug)
          echo "DEBUG: f = ${f}"
          ;;
        info)
          echo -n "."
          ;;
      esac
      [ -x "$f" ] && . "$f"
  done
  unset f
fi


#######################################
# Prompt Settings
#######################################

zsh_set_prompt_type_1
chpwd


#######################################
# .*sh.d fragment
#######################################

SHELLS=(sh bash)
for x in ${SHELLS[@]}; do
  if test -d "${HOME}/.${x}.d"; then
    for f in `find ${HOME}/.${x}.d/ -name '*.sh'` ; do
        case $LOGLEVEL in
          debug)
            echo "DEBUG: f = ${f}"
            ;;
          info)
            echo -n "."
            ;;
        esac
        [ -x "$f" ] && . "$f"
    done
    unset f
  fi
done
unset x
unset SHELLS

clear

