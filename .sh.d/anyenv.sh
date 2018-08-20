ANYENV=$HOME/.anyenv
if test -d $ANYENV; then
  export PATH=$ANYENV/shims:$ANYENV/bin:$PATH
fi
unset ANYENV

_check_cmd anyenv
if test $? -eq 0; then
  eval "$(anyenv init -)"
fi

