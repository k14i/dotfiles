_check_cmd brew
if test $? -eq 0; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
fi

