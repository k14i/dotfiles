_check_cmd autossh
if test $? -eq 0; then
  alias autossh="autossh -M0 -f -N "
fi

