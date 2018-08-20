_check_cmd rvm
if test $? -eq 0; then
  if [ -f /etc/profile.d/rvm.sh ]; then
    source /etc/profile.d/rvm.sh
  fi
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
fi

_check_cmd rvm
if test $? -eq 0; then
  alias rvm-get-head='rvm get head'
  alias rvm-get-stable='rvm get stable'
  alias rvm-list='rvm list'
  alias rvm-list-r='rvm list -r'
  alias rvm-use-193='rvm use 1.9.3'
  alias rvm-use-193-default='rvm use 1.9.3 --default'
  alias rvm-use-200='rvm use 2.0.0'
  alias rvm-use-200-default='rvm use 2.0.0 --default'
fi

