_check_cmd mosh
if test $? -eq 0; then
  alias moshx="mosh --ssh='TERM=xterm ssh -X -i $SSH_SECRET_KEY'"
  alias mosh="mosh --ssh='TERM=xterm ssh -i $SSH_SECRET_KEY'"
  compdef mosh=ssh
fi

