target='/usr/local/share/autojump/autojump.zsh'
if test -f "$target"; then
  source $target
  [[ -s `brew --prefix`/etc/autojump.zsh ]] && . `brew --prefix`/etc/autojump.zsh
fi

# The next line updates PATH for the Google Cloud SDK.
target="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Users/keith@nttpc.co.jp/Library/google-cloud-sdk/path.zsh.inc"
if test -f "$target"; then
  source $target
fi

# # The next line enables shell command completion for gcloud.
# source "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Users/keith@nttpc.co.jp/Library/google-cloud-sdk/completion.zsh.inc"

export ALPN_VERSION="8.1.7.v20160121"
target='/usr/libexec/java_home'
if test -f "$target"; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi
