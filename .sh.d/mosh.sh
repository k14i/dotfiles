_check_cmd mosh
if test $? -eq 0; then
  alias moshx="mosh --ssh='TERM=xterm ssh -X -i $SSH_SECRET_KEY'"
  alias mosh="mosh --ssh='TERM=xterm ssh -i $SSH_SECRET_KEY'"
  compdef mosh=ssh
  export LC_ALL=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_CTYPE=en_US.UTF-8
fi

