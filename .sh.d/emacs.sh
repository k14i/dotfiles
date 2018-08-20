_check_cmd emacs
if test $? -eq 0; then
  emacs=`which -a emacs | egrep '^/' | head -1`

  alias emacs=$emacs
  alias e=$emacs
  export EDITOR=emacs

  unset emacs
fi

