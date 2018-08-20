_check_cmd brew
if test $? -eq 0; then

  # NOTE: /usr/local/{,s}bin
  HOMEBREW_PATH=/usr/local
  if test -d $HOMEBREW_PATH; then
    export PATH=$HOMEBREW_PATH/bin:$PATH
    export PATH=$HOMEBREW_PATH/sbin:$PATH
  fi
  unset HOMEBREW_PATH

  # NOTE: $HOME/.brew/{,s}bin

  HOMEBREW_PATH=$HOME/.brew
  if test -d $HOMEBREW_PATH; then
    export PATH=$HOMEBREW_PATH/bin:$PATH
    export PATH=$HOMEBREW_PATH/sbin:$PATH
  fi
  export HOMEBREW_CACHE="$HOMEBREW_PATH/cache"
  if test ! -d "$HOMEBREW_CACHE"; then
    mkdir -p $HOMEBREW_CACHE
  fi
  unset HOMEBREW_PATH

  alias brew-update='brew update'
  alias brew-upgrade='brew upgrade'
  alias brew-install='brew install'
  alias brew-uninstall='brew uninstall'
  alias brew-search='brew search'
  alias brew-list='brew list'
  alias brew-update='brew update'
  alias brew-upgrade='brew upgrade'
  alias brew-info='brew info'
  alias brew-doctor='brew doctor'
fi

