# global aliases ======================
alias -g G='| grep'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
# =====================================

# Others ==============================
alias pb-fix-utf-8="pbpaste | iconv -c -f UTF-8-MAC -t UTF-8 | pbcopy"
alias zshrc="source $HOME/.zshrc"
alias source-zshrc="source $HOME/.zshrc"
alias zshrc.source="source $HOME/.zshrc"
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir -p'

alias du="du -sh"
alias df="df -h"
alias j="jobs -l"
alias watch-1='watch -n 1'
alias where="command -v"
alias man='man -a -P less'
alias bsh='java bsh.Interpreter'

alias :q="exit"
# =====================================

