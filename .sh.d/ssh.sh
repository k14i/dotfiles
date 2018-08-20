_check_cmd ssh
if test $? -eq 0; then
  ssh=`which -a ssh | egrep '^/' | head -1`
  alias ssh="TERM=xterm ${ssh} -i $SSH_SECRET_KEY"
  alias ssh256="TERM=xterm-256color ${ssh} -i $SSH_SECRET_KEY"
  unset ssh
fi

_check_cmd scp
if test $? -eq 0; then
  alias scp="scp -i $SSH_SECRET_KEY"
fi

