# .zshrc
# http://zsh.sourceforge.net/Doc/Release/zsh_toc.html
# http://zsh.sourceforge.net/Guide/zshguide.html
# http://zsh.sourceforge.net/FAQ/

_check_cmd(){
  if test x$1 \=\= x; then return 1; fi
  _ret=1
  if test `which $1 > /dev/null 2>&1; echo $?` -eq 0; then _ret=0; fi
  return $_ret
}

#######################################
# Variables
#######################################

LOCAL_ID=`whoami`
SSH_SECRET_KEY='~/.ssh/id_rsa'
KERNEL=`uname -s`

#######################################
# Cleaning
#######################################

files_to_delete=("$HOME/.emacs.elc")
for f in "${files_to_delete[@]}"; do
  if test -f $f; then
    \rm $f
  fi
done


#######################################
# Key Bindings
#######################################

bindkey -e #emacs(-e)|vim(-v)
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "^]" insert-last-word


#######################################
# Completion
#######################################

setopt auto_param_keys
setopt correct
#setopt correct_all
setopt list_packed
setopt list_types
setopt numeric_glob_sort

setopt auto_cd
setopt auto_pushd
setopt auto_resume
setopt equals
setopt extended_glob
setopt long_list_jobs
setopt magic_equal_subst
setopt print_eight_bit
setopt prompt_subst
unsetopt promptcr
setopt mark_dirs

autoload smart-insert-last-word
zle -N insert-last-word smart-insert-last-word

# zsh-completions =====================
fpath=(/usr/local/share/zsh-completions $fpath)
# =====================================

#######################################
# History
#######################################

HISTFILE=${HOME}/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

setopt inc_append_history # append_history | inc_append_history
setopt extended_history
setopt bang_hist
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_store
setopt hist_verify
setopt share_history

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

zshaddhistory() {
  local line=${1%%$'\n'}
  local cmd=${line%% *}

  [[ ${#line} -ge 5
    && ${cmd} != (l[salf])
    && ${cmd} != (man)
  ]]
}


#######################################
# Other Settings
#######################################

setopt chase_links
#setopt clobber
#setopt NO_flow_control
#setopt hash_cmds
#setopt NO_hup
setopt ignore_eof
#setopt mail_warning


#######################################
# PATH
#######################################

# /usr/local/{,s}bin =================
_check_cmd brew
if test $? -eq 0; then
  HOMEBREW_PATH=/usr/local
  if test -d $HOMEBREW_PATH; then
    export PATH=$HOMEBREW_PATH/bin:$PATH
    export PATH=$HOMEBREW_PATH/sbin:$PATH
  fi
fi
# =====================================

# $HOME/.brew/{,s}bin =================
_check_cmd brew
if test $? -eq 0; then
  HOMEBREW_PATH=$HOME/.brew
  if test -d $HOMEBREW_PATH; then
    export PATH=$HOMEBREW_PATH/bin:$PATH
    export PATH=$HOMEBREW_PATH/sbin:$PATH
  fi
fi
# =====================================

# Python ==============================
case $KERNEL in
  Darwin)
    _check_cmd brew
    if test $? -eq 0; then
      export PYTHONPATH=$(brew --prefix)/lib/python2.7/site-packages
    fi
    ;;
  Linux)
    dir="/usr/local/lib/python3.3/site-packages"
    if [ -d $dir ]; then
      export PYTHONPATH=$dir
    else
      sudo mkdir -p $dir
      export PYTHONPATH=$dir
    fi
    dir="/usr/local/lib/python2.7/site-packages"
    if [ -d $dir ]; then
      export PYTHONPATH=$dir
    else
      sudo mkdir -p $dir
      export PYTHONPATH=$dir
    fi
    ;;
esac
# =====================================

# MySQL ===============================
_check_cmd mysql
if test $? -eq 0; then
  export MYSQL_HOME=$HOME'/etc'
fi
# =====================================

# Java ================================
_check_cmd java
if test $? -eq 0; then
  export JAVA_HOME='/usr'
fi
# =====================================

# AWS CLI =============================
export AWS_RDS_HOME=$HOME'/bin/aws/cli/rds/current'
export PATH=$AWS_RDS_HOME'/bin':$PATH
export EC2_REGION='ap-northeast-1'
export AWS_CREDENTIAL_FILE=$HOME'/bin/aws/credential'
# =====================================

# Rsense ==============================
RSENSE_HOME=$HOME'/lib/rsense-0.3'
if test -d ${RSENSE_HOME}; then
  export RSENSE_HOME=${RSENSE_HOME}
fi
# =====================================

# Elixir ==============================
_check_cmd exenv
if test $? -eq 0; then
  EXENV_ROOT=$HOME/.exenv
  if test -d ${EXENV_ROOT}; then
    export EXENV_ROOT=${EXENV_ROOT}
    export PATH=${EXENV_ROOT}/bin:$PATH
  fi
  eval "$(exenv init -)"
fi
ELIXIR_BIN=$HOME/local/elixir/bin
if test -d $ELIXIR_BIN; then
  export PATH=$ELIXIR_BIN:$PATH
fi
# =====================================

# Go ==================================
_check_cmd go
if test $? -eq 0; then
  GOROOT=/usr/lib/go
  #export GOROOT=$HOME/local/golang
  if test -d ${GOROOT}; then
    export GOROOT=${GOROOT}
  fi
  GOPATH=$HOME/.golang
  if test -d ${GOPATH}; then
    export GOPATH=${GOPATH}
  fi
  if test -d ${GOROOT} && test -d ${GOPATH}; then
    export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
  fi
  if test ! -d $GOPATH; then
    mkdir -p $GOPATH/bin
  fi
fi
# =====================================

# Crystal =============================
_check_cmd crenv
if test $? -eq 0; then
  CRENV_ROOT=$HOME/.crenv
  if test -d ${CRENV_ROOT}; then
    export PATH=${CRENV_ROOT}/bin:$PATH
  fi
  _check_cmd crenv
  if test $? -eq 0; then
    eval "$(crenv init -)"
  fi
  CRYSTAL_CACHE_DIR=$HOME/.Trash/__crystal
fi
# =====================================

# VMware ==============================
VMWARE_OVF_TOOL=/Applications/VMware\ OVF\ Tool
if test -d ${VMWARE_OVF_TOOL}; then
  export PATH=${VMWARE_OVF_TOOL}:$PATH
fi
# =====================================

# GlusterFS ===========================
GLUSTERFS=/usr/local/glusterfs
if test -d ${GLUSTERFS}; then
  export PATH=${GLUSTERFS}/sbin:$PATH
  export MANPATH=$MANPATH:${GLUSTERFS}/share/man
fi
GLUSTERFS_SBIN=/usr/local/glusterfs/sbin
if test -d ${GLUSTERFS_SBIN}; then
  export PATH=${GLUSTERFS_SBIN}:$PATH
fi
# =====================================

# Fluentd/td-agent ====================
FLUENTD_BIN=/usr/lib64/fluent/ruby/bin
export PATH=$FLUENTD_BIN:$PATH
# =====================================

# anyenv ==============================
ANYENV=$HOME/.anyenv
if test -d $ANYENV; then
  export PATH=$ANYENV/shims:$ANYENV/bin:$PATH
fi
_check_cmd anyenv
if test $? -eq 0; then
  eval "$(anyenv init -)"
fi
# =====================================

# pyenv ===============================
PYENV=$HOME/.pyenv
if test -d $PYENV; then
  export PATH=$PYENV/shims:$PATH
fi
# =====================================

# rbenv ===============================
RBENV=$HOME/.rbenv
if test -d $RBENV; then
  export PATH=$RBENV/bin:$PATH
fi
_check_cmd rbenv
if test $? -eq 0; then
  eval "$(rbenv init -)"
fi
# =====================================

# RVM =================================
_check_cmd rvm
if test $? -eq 0; then
  export PATH=$HOME/.rvm/gems/ruby-2.1.3/bin:$PATH
  export PATH=$HOME/.rvm/gems/rbx-head/bin:$PATH
fi
# =====================================

# LightTable ==========================
LT_HOME="${HOME}/Share/iCloud\ Drive/Users/${LOCAL_ID}/Applications/LightTable"
if test -d $LT_HOME; then
  export LT_HOME
fi
LT_HOME="${HOME}/Share/iCloud/Users/${LOCAL_ID}/Applications/LightTable"
if test -d $LT_HOME; then
  export LT_HOME
fi
# =====================================

PATHS=(
#  /Developer/usr/bin
#  /opt/local/bin:/opt/local/sbin
#  /usr/local/Cellar/elixir/bin
  $HOME/Share/btsync/bin
  $HOME/Share/Dropbox/bin
  /usr/local/sbin
  /usr/local/bin
  /usr/texbin
  /usr/local/erlang/bin
  /Applications/Wireshark.app/Contents/Resources/bin
)
for i in ${PATHS[@]}; do
  if test -d $i; then export PATH=$i:$PATH; fi
done


#######################################
# Aliases
#######################################

# ssh =================================
alias ssh="TERM=xterm ssh -i $SSH_SECRET_KEY"
alias ssh256="TERM=xterm-256color /usr/bin/ssh -i $SSH_SECRET_KEY"
alias scp="scp -i $SSH_SECRET_KEY"
# =====================================

# mosh ================================
alias moshx="mosh --ssh='TERM=xterm ssh -X -i $SSH_SECRET_KEY'"
alias mosh="mosh --ssh='TERM=xterm ssh -i $SSH_SECRET_KEY'"
# =====================================

# autossh =============================
alias autossh="autossh -M0 -f -N "
# =====================================

# global aliases ======================
alias -g G='| grep'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
# =====================================

# ls ==================================
alias la='ls -a'
alias ll='ls -l'
alias lf='ls -F'
alias l='ls -alrt'
# =====================================

# rm ==================================
case $KERNEL in
  Darwin)
    if [ -f /opt/local/bin/trash ] || [ -f /usr/local/bin/trash ]; then
      alias rm="trash"
    elif [ -f /opt/local/bin/rmtrash ] || [ -f /usr/local/bin/rmtrash ]; then
      alias rm="rmtrash"
    elif [ -f /opt/local/bin/gmv ] || [ -f /usr/local/bin/gmv ]; then
      alias rm="gmv -f --backup=numbered --target-directory /tmp/rm/`date +%Y-%m-%d`"
    else
      alias rm="rm -i"
    fi
    ;;
  Linux)
    if [ -f /usr/bin/trash ]; then
      alias rm="trash"
    else
      alias rm="mv -f --backup=numbered --target-directory /tmp/rm/`date +%Y-%m-%d`"
    fi
    ;;
  *)
    rm="rm -i"
    ;;
esac
# =====================================

# top =================================
case $KERNEL in
  Darwin)
    alias top="top -s1 -o cpu -R -F"
    alias topu="top -U $LOCAL_ID"
    ;;
  Linux)
    alias top="top -d 1"
    alias topu="top -U $LOCAL_ID"
    ;;
esac
# =====================================

# emacs ===============================
if test -f $HOMEBREW_PATH/bin/emacs; then
  EMACS=$HOMEBREW_PATH/bin/emacs
elif test -f /usr/bin/emacs; then
  EMACS=/usr/bin/emacs
fi
alias emacs=$EMACS
alias e=$EMACS
export EDITOR=emacs
# =====================================

# vim =================================
alias v='vim'
alias vr='vim -R'
alias vimr='vim -R'
# =====================================

# TMUX - The Terminal Multiplexer =====
_check_cmd tmux
if test $? -eq 0; then
  tmux_osx_conf="$HOME/.tmux-osx.conf"
  if test x`uname -s` \=\= x"Darwin" && test -f $tmux_osx_conf; then
    alias tmux="tmux -f $tmux_osx_conf"
  fi
  alias t='tmux'
  alias tmux-new-window='tmux new-window'
  alias tmux-kill-window='tmux kill-window'
  alias tmux-new-session='tmux new'
  alias tmux-attach-session='tmux attach'
  alias tmux-detach-client='tmux detach'
  alias tmux-kill-server='tmux kill-server'
  alias tmux-kill-session='tmux kill-session'
  alias tmux-list-clients='tmux lsc'
  alias tmux-list-commands='tmux lscm'
  alias tmux-list-sessions='tmux ls'
  alias tmux-lock-client='tmux lockc'
  alias tmux-lock-session='tmux locks'
  alias tmux-refresh-client='tmux refresh'
  alias tmux-rename-session='tmux rename'
  alias tmux-show-messages='tmux showmsgs'
  alias tmux-source-file='tmux source'
  alias tmux-start-server='tmux start'
  alias tmux-suspend-client='tmux suspendc'
  alias tmux-switch-client='tmux switchc'
fi
# =====================================

# GNU Global ==========================
_check_cmd gtags
if test $? -eq 0; then
  export MAKEOBJDIRPREFIX=$HOME/devel/.gtags
  alias mkgtags='mkdir -p $MAKEOBJDIRPREFIX/$(pwd -P) && gtags -i $MAKEOBJDIRPREFIX/$(pwd -P)'
  alias mkgtags-cpp='GTAGSFORCECPP=1 $(maketags)'
fi
# =====================================

# rvm =================================
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
# =====================================

# rails ===============================
_check_cmd bundle
if test $? -eq 0; then
  alias bundle-exec-rails-s='bundle exec rails s'
  alias bundle-exec-rails-c='bundle exec rails c'
  alias bundle-exec-rake='bundle exec rake'
  alias bundle-exec-rspec='bundle exec rspec'
  alias bundle-exec-rspec-fail-fast='bundle exec rspec --fail-fast'
  alias bundle-exec-rspec-order-default='bundle exec rspec --order default'
  alias bundle-exec-rspec-order-default-fail-fast='bundle exec rspec --order default --fail-fast'
  alias bundle-exec-rspec-f-d='bundle exec rspec --format d'
  alias bundle-exec-rspec-f-d-fail-fast='bundle exec rspec --format d --fail-fast'
  alias bundle-exec-rspec-f-d-order-default='bundle exec rspec -f d --order default'
  alias bundle-exec-rspec-f-d-order-default-fail-fast='bundle exec rspec -f d --order default --fail-fast'
  alias bundle-exec-spork='bundle exec spork'
  alias rails-env-development-bundle-exec-rails-s='RAILS_ENV=development bundle exec rails s'
  alias rails-env-development-bundle-exec-rails-c='RAILS_ENV=development bundle exec rails c'
  alias rails-env-development-bundle-exec-rspec='RAILS_ENV=development bundle exec rspec'
  alias rails-env-development-bundle-exec-rspec-order-default='RAILS_ENV=development bundle exec rspec --order default'
  alias rails-env-development-bundle-exec-rspec-f-d='RAILS_ENV=development bundle exec rspec --format d'
  alias rails-env-development-bundle-exec-rspec-f-d-order-default='RAILS_ENV=development bundle exec rspec -f d --order default'
  alias rails-env-development-bundle-exec-spork='RAILS_ENV=development bundle exec spork'
fi
# =====================================

# git =================================
_check_cmd git
if test $? -eq 0; then
  #alias git-push-current-branch='git push origin \`git status | grep \'On branch\' | awk \'\{print \$4\}\'\`'
  alias git-init='git init'
  alias git-clone='git clone'
  alias git-fsck='git fsck'
  alias git-fsck-full='git fsck --full'
  alias git-gc='git gc'
  alias git-status='git status'
  alias git-add='git add'
  alias git-diff='git diff'
  alias git-commit='git commit'
  alias git-commit-m='git commit -m'
  alias git-commit-c-ORIG_HEAD='git commit -c ORIG_HEAD'
  alias git-commit-c-ORIG_HEAD-m='git commit -c ORIG_HEAD -m'
  alias git-commit-amend='git commit --amend'
  alias git-commit-amend-m='git commit --amend -m'
  alias git-log='git log'
  alias git-push='git push'
  alias git-push-origin-master='git push origin master'
  alias git-push-origin-develop='git push origin develop'
  alias git-push-origin-pre_develop='git push origin pre_develop'
  alias git-fetch='git fetch'
  alias git-pull='git pull'
  alias git-pull-rebase='git pull --rebase'
  alias git-rebase='git rebase'
  alias git-branch='git branch'
  alias git-checkout='git checkout'
  alias git-checkout-b='git checkout -b'
  alias git-show-branch='git show-branch'
  alias git-merge='git merge'
  alias git-merge-no-ff='git merge --no-ff'
  alias git-reset='git reset'
  alias git-reset-hard-HEAD='git reset --hard HEAD'
  alias git-reset-soft-HEAD='git reset --soft HEAD'
  alias git-diff-ORIG_HEAD='git diff ORIG_HEAD'
  alias git-revert='git revert'
  alias git-tag='git tag'
  alias git-stash='git stash'
  alias git-stash-pop='git stash pop'
  alias git-stash-list='git stash list'
fi
# =====================================

# brew ================================
_check_cmd brew
if test $? -eq 0; then
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
# =====================================

# cloudmonkey =========================
_check_cmd cloudmonkey
if test $? -eq 0; then
  ## -- virtualmachine(s) ---------------
  alias cloudmonkey-deploy-virtualmachine='cloudmonkey deploy virtualmachine'
  alias cloudmonkey-destroy-virtualmachine='cloudmonkey destroy virtualmachine'
  alias cloudmonkey-reboot-virtualmachine='cloudmonkey reboot virtualmachine'
  alias cloudmonkey-start-virtualmachine='cloudmonkey start virtualmachine'
  alias cloudmonkey-stop-virtualmachine='cloudmonkey stop virtualmachine'
  alias cloudmonkey-changeservicefor-virtualmachine='cloudmonkey changeservicefor virtualmachine'
  alias cloudmonkey-update-virtualmachine='cloudmonkey update virtualmachine'
  alias cloudmonkey-recover-virtualmachine='cloudmonkey recover virtualmachine'
  alias cloudmonkey-list-virtualmachines='cloudmonkey list virtualmachines listall=true'
  ### - - - - aliases - - - - - - - - - -
  alias cloudstack-virtualmachine-deploy='cloudmonkey-deploy-virtualmachine'
  alias cloudstack-virtualmachine-destroy='cloudmonkey-destroy-virtualmachine'
  alias cloudstack-virtualmachine-reboot='cloudmonkey-reboot-virtualmachine'
  alias cloudstack-virtualmachine-start='cloudmonkey-start-virtualmachine'
  alias cloudstack-virtualmachine-stop='cloudmonkey-stop-virtualmachine'
  alias cloudstack-virtualmachine-changeservicefor='cloudmonkey-changeservicefor-virtualmachine'
  alias cloudstack-virtualmachine-update='cloudmonkey-update-virtualmachine'
  alias cloudstack-virtualmachine-recover='cloudmonkey-recover-virtualmachine'
  alias cloudstack-virtualmachine-list='cloudmonkey-list-virtualmachines'
  ## -- template(s) ---------------------
  alias cloudmonkey-create-template='cloudmonkey create template'
  alias cloudmonkey-update-template='cloudmonkey update template'
  alias cloudmonkey-delete-template='cloudmonkey delete template'
  alias cloudmonkey-list-templates-featured='cloudmonkey list templates listall=true templatefilter=featured'
  alias cloudmonkey-list-templates-self='cloudmonkey list templates listall=true templatefilter=self'
  alias cloudmonkey-list-templates-self-executable='cloudmonkey list templates listall=true templatefilter=self-executable'
  alias cloudmonkey-list-templates-executable='cloudmonkey list templates listall=true templatefilter=executable'
  alias cloudmonkey-list-templates-community='cloudmonkey list templates listall=true templatefilter=community'
  alias cloudmonkey-list-templatepermissions='cloudmonkey list templatepermissions listall=true'
  alias cloudmonkey-extract-template='cloudmonkey extract template'
  ### - - - - aliases - - - - - - - - - -
  alias cloudstack-template-create='cloudmonkey-create-template'
  alias cloudstack-template-update='cloudmonkey-update-template'
  alias cloudstack-template-delete='cloudmonkey-delete-template'
  alias cloudstack-template-list-featured='cloudmonkey-list-templates-featured'
  alias cloudstack-template-list-self='cloudmonkey-list-templates-self'
  alias cloudstack-template-list-self-executable='cloudmonkey-list-templates-self-executable'
  alias cloudstack-template-list-executable='cloudmonkey-list-templates-executable'
  alias cloudstack-template-list-community='cloudmonkey-list-templates-community'
  alias cloudstack-templatepermissions-list='cloudmonkey-list-templatepermissions'
  alias cloudstack-template-extract='cloudmonkey-extract-template'
  ## -- iso(s) --------------------------
  alias cloudmonkey-attach-iso='cloudmonkey attach iso'
  alias cloudmonkey-detach-iso='cloudmonkey detach iso'
  alias cloudmonkey-list-isos='cloudmonkey list isos listall=true'
  alias cloudmonkey-update-iso='cloudmonkey update iso'
  alias cloudmonkey-delete-iso='cloudmonkey delete iso'
  alias cloudmonkey-list-isopermissions='cloudmonkey list isopermissions listall=true'
  alias cloudmonkey-extract-iso='cloudmonkey extract iso'
  ### - - - - aliases - - - - - - - - - -
  alias cloudstack-iso-attach='cloudmonkey-attach-iso'
  alias cloudstack-iso-detach='cloudmonkey-detach-iso'
  alias cloudstack-iso-list='cloudmonkey-list-isos'
  alias cloudstack-iso-update='cloudmonkey-update-iso'
  alias cloudstack-iso-delete='cloudmonkey-delete-iso'
  alias cloudstack-isopermissions-list='cloudmonkey-list-isopermissions'
  alias cloudstack-iso-extract='cloudmonkey-extract-iso'
  ## -- volume(s) -----------------------
  alias cloudmonkey-attach-volume='cloudmonkey attach volume'
  alias cloudmonkey-detach-volume='cloudmonkey detach volume'
  alias cloudmonkey-create-volume='cloudmonkey create volume'
  alias cloudmonkey-delete-volume='cloudmonkey delete volume'
  alias cloudmonkey-list-volumes='cloudmonkey list volumes listall=true'
  alias cloudmonkey-extract-volume='cloudmonkey extract volume'
  ### - - - - aliases - - - - - - - - - -
  alias cloudstack-volume-attach='cloudmonkey-attach-volume'
  alias cloudstack-volume-detach='cloudmonkey-detach-volume'
  alias cloudstack-volume-create='cloudmonkey-create-volume'
  alias cloudstack-volume-delete='cloudmonkey-delete-volume'
  alias cloudstack-volume-list='cloudmonkey-list-volumes'
  alias cloudstack-volume-extract='cloudmonkey-extract-volume'
  ## -- snapshot(s) ---------------------
  alias cloudmonkey-create-snapshot='cloudmonkey create snapshot'
  alias cloudmonkey-list-snapshots='cloudmonkey list snapshots listall=true'
  alias cloudmonkey-delete-snapshot='cloudmonkey delete snapshot'
  alias cloudmonkey-create-snapshotpolicy='cloudmonkey create snapshotpolicy'
  alias cloudmonkey-delete-snapshotpolicy='cloudmonkey delete snapshotpolicy'
  alias cloudmonkey-list-snapshotpolicies='cloudmonkey list snapshotpolicies listall=true'
  ### - - - - aliases - - - - - - - - - -
  alias cloudstack-snapshot-create='cloudmonkey-create-snapshot'
  alias cloudstack-snapshot-list='cloudmonkey-list-snapshots'
  alias cloudstack-snapshot-delete='cloudmonkey-delete-snapshot'
  alias cloudstack-snapshotpolicy-create='cloudmonkey-create-snapshotpolicy'
  alias cloudstack-snapshotpolicy-delete='cloudmonkey-delete-snapshotpolicy'
  alias cloudstack-snapshotpolicy-list='cloudmonkey-list-snapshotpolicies'
  ## -- zone(s) -------------------------
  alias cloudmonkey-list-zones='cloudmonkey list zones listall=true'
  ### - - - - aliases - - - - - - - - - -
  alias cloudstack-zone-list='cloudmonkey-list-zones'
  ## -- securitygroup(s) ----------------
  alias cloudmonkey-create-securitygroup='cloudmonkey create securitygroup'
  alias cloudmonkey-delete-securitygroup='cloudmonkey delete securitygroup'
  alias cloudmonkey-authorize-securitygroupingress='cloudmonkey authorize securitygroupingress'
  alias cloudmonkey-revoke-securitygroupingress='cloudmonkey revoke securitygroupingress'
  alias cloudmonkey-authorize-securitygroupegress='cloudmonkey authorize securitygroupegress'
  alias cloudmonkey-revoke-securitygroupegress='cloudmonkey revoke securitygroupegress'
  alias cloudmonkey-list-securitygroups='cloudmonkey list securitygroups listall=true'
  ### - - - - aliases - - - - - - - - - -
  alias cloudstack-securitygroup-create='cloudmonkey-create-securitygroup'
  alias cloudstack-securitygroup-delete='cloudmonkey-delete-securitygroup'
  alias cloudstack-securitygroupingress-authorize='cloudmonkey-authorize-securitygroupingress'
  alias cloudstack-securitygroupingress-revoke='cloudmonkey-revoke-securitygroupingress'
  alias cloudstack-securitygroupegress-authorize='cloudmonkey-authorize-securitygroupegress'
  alias cloudstack-securitygroupegress-revoke='cloudmonkey-revoke-securitygroupegress'
  alias cloudstack-securitygroup-list='cloudmonkey-list-securitygroups'
  ## -- event(s) ------------------------
  alias cloudmonkey-list-events='cloudmonkey list events listall=true'
  alias cloudmonkey-list-eventtypes='cloudmonkey list eventtypes listall=true'
  ### - - - - aliases - - - - - - - - - -
  alias cloudstack-event-list='cloudmonkey-list-events'
  alias cloudstack-eventtype-list='cloudmonkey-list-eventtypes'
  ## -- others --------------------------
  alias cloudmonkey-list-serviceofferings='cloudmonkey list serviceofferings listall=true'
  alias cloudmonkey-list-diskofferings='cloudmonkey list diskofferings listall=true'
  ### - - - - aliases - - - - - - - - - -
  alias cloudstack-serviceoffering-list='cloudmonkey-list-serviceofferings'
  alias cloudstack-diskoffering-list='cloudmonkey-list-diskofferings'
fi
# =====================================

# VirtualBox ==========================
_check_cmd VBoxManage
if test $? -eq 0; then
  alias vboxmanage='/usr/bin/VBoxManage'
  alias vboxmanage-list-vms='vboxmanage list vms'
  alias vboxmanage-list-running-vms='vboxmanage list runningvms'
  alias vboxmanage-list-os-types='vboxmanage list ostypes'
  alias vboxmanage-list-host-dvds='vboxmanage list hostdvds'
  alias vboxmanage-list-host-floppies='vboxmanage list hostfloppies'
  alias vboxmanage-list-bridged-ifs='vboxmanage list bridgedifs'
  alias vboxmanage-list-hostonly-ifs='vboxmanage list hostonlyifs'
  alias vboxmanage-list-dhcp-servers='vboxmanage list dhcpservers'
  alias vboxmanage-list-host-info='vboxmanage list hostinfo'
  alias vboxmanage-list-host-cpu-ids='vboxmanage list hostcpuids'
  alias vboxmanage-list-hdd-backends='vboxmanage list hddbackends'
  alias vboxmanage-list-hdds='vboxmanage list hdds'
  alias vboxmanage-list-dvds='vboxmanage list dvds'
  alias vboxmanage-list-floppies='vboxmanage list floppies'
  alias vboxmanage-list-usb-host='vboxmanage list usbhost'
  alias vboxmanage-list-usb-filters='vboxmanage list usbfilters'
  alias vboxmanage-list-system-properties='vboxmanage list systemproperties'
  alias vboxmanage-show-vm-info='vboxmanage showvminfo'
  alias vboxmanage-register-vm='vboxmanage registervm'
  alias vboxmanage-unregister-vm='vboxmanage unregistervm'
  alias vboxmanage-create-vm='vboxmanage createvm'
  alias vboxmanage-modify-vm='vboxmanage modifyvm'
  alias vboxmanage-import='vboxmanage import'
  alias vboxmanage-export='vboxmanage export'
  alias vboxmanage-start-vm='vboxmanage startvm'
  alias vboxmanage-control-vm='vboxmanage controlvm'
  alias vboxmanage-discard-state='vboxmanage discardstate'
  alias vboxmanage-adopt-state='vboxmanage adoptstate'
  alias vboxmanage-snapshot='vboxmanage snapshot'
  alias vboxmanage-open-medium='vboxmanage openmedium'
  alias vboxmanage-close-medium='vboxmanage closemedium'
  alias vboxmanage-storage-attach='vboxmanage storageattach'
  alias vboxmanage-storage-ctl='vboxmanage storagectl'
  alias vboxmanage-show-hd-info='vboxmanage showhdinfo'
  alias vboxmanage-create-hd='vboxmanage createhd'
  alias vboxmanage-modify-hd='vboxmanage modifyhd'
  alias vboxmanage-clone-hd='vboxmanage clonehd'
  alias vboxmanage-convert-from-raw='vboxmanage convertfromraw'
  alias vboxmanage-add-iscsi-disk='vboxmanage addiscsidisk'
  alias vboxmanage-get-extra-data='vboxmanage getextradata'
  alias vboxmanage-set-extra-data='vboxmanage setextradata'
  alias vboxmanage-set-property='vboxmanage setproperty'
  alias vboxmanage-usb-filter='vboxmanage usbfilter'
  alias vboxmanage-shared-folder='vboxmanage sharedfolder'
  alias vboxmanage-vm-statistics='vboxmanage vmstatistics'
  alias vboxmanage-guest-property='vboxmanage guestproperty'
  alias vboxmanage-metrics='vboxmanage metrics'
  alias vboxmanage-hostonly-if='vboxmanage hostonlyif'
  alias vboxmanage-dhcp-server='vboxmanage dhcpserver'
fi
# =====================================

# OS X Applications ===================
alias Emacs='open -a /Applications/Emacs.app'
alias coderunner='open -a /Applications/CodeRunner.app'
alias xcode='open -a /Applications/Xcode.app'
alias sublime='open -a /Applications/Sublime\ Text\ 2.app'
alias coteditor='open -a /Applications/CotEditor.app'
alias texshop='open -a /Applications/TeX/TeXShop.app'
alias lyx='open -a /Applications/LyX.app'
alias notes='open -a /Applications/Notes.app'
alias textedit='open -a /Applications/TextEdit.app'
alias preview='open -a /Applications/Preview.app'
alias calendar='open -a /Applications/Calendar.app'
alias appstore='open -a /Applications/App\ Store.app'
alias opera='open -a /Applications/Opera.app'
alias chrome='open -a /Applications/Google\ Chrome.app'
alias firefox='open -a /Applications/Firefox.app'
alias terminal='open -a /Applications/Utilities/Terminal.app'
alias evernote='open -a /Applications/Evernote.app'
alias omnigraffle='open -a /Applications/OmniGraffle\ Professional\ 5.app'
# =====================================

# Diskutil ============================
_check_cmd diskutil
if test $? -eq 0; then
  alias diskutil-mountDisk='diskutil mountDisk'
  alias diskutil-unmountDisk='diskutil unmountDisk'
  alias diskutil-list='diskutil list'
  alias diskutil-eject='diskutil eject'
fi
# =====================================

# say =================================
_check_cmd say
if test $? -eq 0; then
  alias say='say -r 200 --progress'
  alias say-agnes='say -v Agnes'
  alias say-jill='say -v Jill'
  alias say-kathy='say -v Kathy'
  alias say-princess='say -v Princess'
  alias say-samantha='say -v Samantha'
  alias say-vicki='say -v Vicki'
  alias say-victoria='say -v Victoria'
  alias say-alex='say -v Alex'
  alias say-bruce='say -v Bruce'
  alias say-fred='say -v Fred'
  alias say-junior='say -v Junior'
  alias say-ralph='say -v Ralph'
  alias say-tom='say -v Tom'
  alias say-albert='say -v Albert'
  alias say-bad_news='say -v Bad\ News'
  alias say-bahh='say -v Bahh'
  alias say-bells='say -v Bells'
  alias say-boing='say -v Boing'
  alias say-bubbles='say -v Bubbles'
  alias say-cellos='say -v Cellos'
  alias say-deranged='say -v Deranged'
  alias say-good_news='say -v Good\ News'
  alias say-hysterical='say -v Hysterical'
  alias say-pipe_organ='say -v Pipe\ Organ'
  alias say-trinoids='say -v Trinoids'
  alias say-whisper='say -v Whisper'
  alias say-zarbox='say -v Zarbox'
  alias say-kyoko='say -v Kyoko'
fi
# =====================================

# sferik/t ============================
# https://github.com/sferik/t
alias tw="$GEM_HOME/bin/t"
alias tw-update="tw update"
alias tw-timeline="tw timeline"
alias tw-stream-timeline="tw stream timeline"
# =====================================

# w3m =================================
_check_cmd w3m
if test $? -eq 0; then
  alias w3m='w3m -cookie -B -graph'
  alias google='w3m https://www.google.com/ncr'
  alias google-ja='w3m https://www.google.co.jp/'
  alias duckduckgo='w3m https://duckduckgo.com/'
  alias amazon='w3m https://www.amazon.com/'
  alias amazon-ja='w3m https://www.amazon.co.jp/'
  alias wikipedia='w3m http://en.wikipedia.org/'
  alias wikipedia-ja='w3m http://ja.wikipedia.org/'
  alias github='w3m https://github.com/'
fi
# =====================================

# Others ==============================
alias pb-fix-utf-8="pbpaste | iconv -c -f UTF-8-MAC -t UTF-8 | pbcopy"
alias zshrc="source $HOME/.zshrc"
alias source-zshrc="source $HOME/.zshrc"
alias zshrc.source="source $HOME/.zshrc"
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir -p'

_check_cmd rsync
if test $? -eq 0; then
  alias rsync="/usr/bin/rsync -a -S --delay-updates --exclude-from=$HOME/.rsync/exclude.txt --stats -E"
  alias rsync-local="rsync -v --progress --rsh='rsh'"
  alias rsync-local-quiet="rsync -q --ignore-errors --rsh='rsh'"
  alias rsync-standard="rsync -vz --progress"
  alias rsync-standard-quiet="rsync -zq --ignore-errors"
  alias rsync-full="rsync \
    -vz \
    --progress \
    -b \
    --backup-dir=$HOME/.backup/rsync \
    --suffix=.`date +%Y%m%d%H%M%S` \
    --ignore-errors \
    --partial \
    --partial-dir=$HOME/tmp/.rsync/partial \
    -T $HOME/tmp/.rsync/temp \
    --log-file=$HOME/var/log/rsync/`date +%Y%m%d%H%M%S`.log"
  alias rsync-full-local="rsync \
    --rsh='rsh' \
    -v \
    --progress \
    -b \
    --backup-dir=$HOME/.backup/rsync \
    --suffix=.`date +%Y%m%d%H%M%S` \
    --ignore-errors \
    --partial \
    --partial-dir=$HOME/tmp/.rsync/partial \
    -T $HOME/tmp/.rsync/temp \
    --log-file=$HOME/var/log/rsync/`date +%Y%m%d%H%M%S`.log"
  alias rsync-full-quiet="rsync \
    -zq \
    -b \
    --backup-dir=$HOME/.backup/rsync \
    --suffix=.`date +%Y%m%d%H%M%S` \
    --ignore-errors \
    --partial \
    --partial-dir=$HOME/tmp/.rsync/partial \
    -T $HOME/tmp/.rsync/temp \
    --log-file=$HOME/var/log/rsync/`date +%Y%m%d%H%M%S`.log"
  alias rsync-full-local-quiet="rsync \
    --rsh='rsh' \
    -q \
    -b \
    --backup-dir=$HOME/.backup/rsync \
    --suffix=.`date +%Y%m%d%H%M%S` \
    --ignore-errors \
    --partial \
    --partial-dir=$HOME/tmp/.rsync/partial \
    -T $HOME/tmp/.rsync/temp \
    --log-file=$HOME/var/log/rsync/`date +%Y%m%d%H%M%S`.log"
fi
alias du="du -sh"
alias df="df -h"
alias j="jobs -l"
alias watch-1='watch -n 1'
alias where="command -v"
alias man='man -a -P less'
alias bsh='java bsh.Interpreter'

_check_cmd mosh
if test $? -eq 0; then
  alias mosh-mbp17="mosh mbp17-${LOCAL_ID}.local"
  alias mosh-mba11="mosh mba11-${LOCAL_ID}.local"
  alias mosh-infinibridge.net='mosh infinibridge.net'
  alias mosh-infinibridge.mobi='mosh infinibridge.mobi'
fi
alias rackhub="\ssh rackhuber@${LOCAL_ID}.rackbox.net -p 50118 -A -i $SSH_SECRET_KEY"
alias :q="exit"
# =====================================


#######################################
# Prompt Settings
#######################################

# Path ================================
zsh_set_tmux_for_prompt_type_0() {
  #tmux set -qg status-right "Session:#S Pane:#P $(pwd) |#[fg=colour255,bg=colour234] #(~/bin/battery Discharging)#(~/bin/battery Charging)#(uptime | cut -d "," -f 3-) #[fg=colour234,bg=colour255,bold]%Y-%m-%d %H:%M %a#[default]"
  tmux set -qg status-left "S#S P#P ["
  tmux set -qg status-right "] #[fg=magenta,bg=colour234]$(whoami)#[default]@$(hostname -s):#[fg=green,bg=colour234]$(pwd) #[fg=colour234,bg=colour255,bold]%Y-%m-%d %H:%M %a#[default]"
}

zsh_set_tmux_for_prompt_type_1() {
  #tmux set -qg status-left "#[fg=white,bg=black,bold]#I/#[fg=black,bg=colour202,bold]#20(whoami)@#h#[deafult]"
  tmux set -qg status-left '#[fg=white,bg=black,bold]S#S I#I P#P #[fg=black,bg=colour202,bold]#h#[default] ['
  tmux set -qg status-right "] #[fg=colour255,bg=colour234] Batt[#(~/bin/battery Discharging)#(~/bin/battery Charging)]#(uptime | cut -d "," -f 3- | sed 's/load averages: /Ld.Avg[/g')] #[fg=colour234,bg=colour255,bold]%m-%d %H:%M %a#[default]"
}

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' formats '%r'

precmd() {
  # tmux
  _check_cmd tmux
  if test $? -eq 0; then
    if test `tmux list-sessions > /dev/null 2>&1; echo $?` -eq 0; then
      case x"$ZSH_PROMPT_TYPE" in
        x"0") zsh_set_tmux_for_prompt_type_0 ;;
        x"1") zsh_set_tmux_for_prompt_type_1 ;;
        *   ) zsh_set_tmux_for_prompt_type_1 ;;
      esac
      if test x$ZSH_TMUX_RENAME_WINDOW_CONFIGURED != x1; then
        LANG=en_US.UTF-8 vcs_info
        [[ -n ${vcs_info_msg_0_} ]] && tmux rename-window $vcs_info_msg_0_
        export ZSH_TMUX_RENAME_WINDOW_CONFIGURED=1
      fi
    fi
  fi
}

chpwd() {
}
#export PATH_THELATESTDIR0=`pwd`
preexec() {
#  if test x"$PATH_THELATESTDIR0" != x"`pwd`"; then
#    export PATH_THELATESTDIR1=$PATH_THELATESTDIR0
#    export PATH_THELATESTDIR0=`pwd`
#    alias cdback="cd $PATH_THELATESTDIR1"
#  fi
}

# =====================================

# Coloring ============================
autoload colors
colors
# =====================================

# Git integration =====================
#autoload -Uz vcs_info
#zstyle ":vcs_info:*" enable git svn
#precmd() {
#  vcs_info
#}
#zstyle ":vcs_info:git:*" check-for-changes true
#zstyle ":vcs_info:git:*" formats "%c%u[%b:%r]"
#zstyle ":vcs_info:git:*" actionformats "%c%u<%a>[%b:%r]"
#zstyle ":vcs_info:git:*" unstagedstr "<U>"
#zstyle ":vcs_info:git:*" stagedstr "<S>"
#my_git_info_push () {
#  if [ "$(git remote 2>/dev/null)" != "" ]; then
#    local head="$(git rev-parse HEAD)"
#    local remote
#    for remote in $(git rev-parse --remotes) ; do
#      if [ "$head" = "$remote" ]; then
#        return 0
#      fi
#    done
#    echo "<P>"
#  fi
#}
#my_git_info_stash () {
#  if [ "$(git stash list 2>/dev/null)" != "" ]; then
#    echo "{s}"
#  fi
#}
#my_vcs_info () {
#  vcs_info
#  echo $(my_git_info_stash)$(my_git_info_push)$vcs_info_msg_0_
#}
# =====================================

# Prompt ==============================
zsh_set_prompt_type_0() {
  export ZSH_PROMPT_TYPE=0
  PROMPT="%{${fg[cyan]}%}%# %{${reset_color}%}"
  PROMPT2="%{${fg[red]}%}[%n@%m] %{${reset_color}%}"
  RPROMPT="%{${reset_color}%}"
  SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
}

zsh_set_prompt_type_1() {
  export ZSH_PROMPT_TYPE=1
  PROMPT="%{${fg[cyan]}%}[20%D %*]%# %{${reset_color}%}"
  PROMPT2="%{${fg[red]}%}[%n@%m] %{${reset_color}%}"
  if [ $TERM \=\= "screen" ]; then
    RPROMPT="%{${fg[magenta]}%}[S]`echo $STY | sed 's/\./ /g' | awk '{print $1}'` %n%{${fg[white]}%}@%m:%{${fg[green]}%}%/ %{${reset_color}%}"
  else
    RPROMPT="%{${fg[magenta]}%}%n%{${fg[white]}%}@%m:%{${fg[green]}%}%/ %{${reset_color}%}"
  fi
  SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
}

zsh_switch_prompt() {
  case x"$ZSH_PROMPT_TYPE" in
    x"0") zsh_set_prompt_type_1 ;;
    x"1") zsh_set_prompt_type_0 ;;
    *) ;;
  esac
}

sw() {
  zsh_switch_prompt
}

zsh_set_prompt_type_1
# =====================================

# zstyle ==============================
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle :insert-last-word match '*([^[:space:]][[:alpha:]/\\][^[:space:]])*'
# =====================================

# Changing working directory ==========
chpwd() {
  [[ -t 1 ]] || return
  case $TERM in
    sun-cmd)
      print -Pn "\e]l%~\e\\"
      ;;
    *xterm*|rxvt|(dt|k|E)term|screen)
      print -Pn "\e]2;%~\a"
      ;;
  esac
  mkdir -p /tmp/rm/`date +%Y-%m-%d`
}
chpwd
# =====================================

# Others ==============================
#export DISPLAY=:10.0
#export LESS='--tabs=4 --no-limit --LONG-PROMPT --ignore-case'
# =====================================


#######################################
# Software Specified Settings
#######################################

# GNU screen ==========================
_check_cmd screen
if test $? -eq 0; then
  #alias screen='screen -t "`date "+%m%d%H%M%S"`" -U -d -R'
  #alias screen='screen -t "" -U -d -R'
  #alias screen='screen -t "" -U'
  alias screen='screen -t ""'
  alias s='screen'
  alias r='screen -r'
  alias d='screen -rd'
  alias x='screen -rx'
  alias sl='s -ls'
fi
#preexec () {
#  [ ${STY} ] && echo -ne "\ek${1%% *}\e\\"
#}
#[ ${STY} ] || screen -rx || screen -D -RR
#### /GNU screen

autoload -U compinit
compinit -u

export LANG=ja_JP.UTF-8
limit coredumpsize 102400
setopt nobeep

[[ -s $HOME/.screeninator/scripts/screeninator ]] && source $HOME/.screeninator/scripts/screeninator
# =====================================

# rvm =================================
_check_cmd rvm
if test $? -eq 0; then
  if [ -f /etc/profile.d/rvm.sh ]; then
    source /etc/profile.d/rvm.sh
  fi
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
fi
# =====================================

# tmux ================================
_check_cmd tmux
if test $? -eq 0; then
  [[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
  alias tmux-session-save='tmux-session save'
  alias tmux-session-restore='tmux-session restore'
fi
# =====================================

# mosh ================================
compdef mosh=ssh
# =====================================

# Sphinx ==============================
export LC_ALL='ja_JP.UTF-8'
# =====================================

# Docker ==============================
docker-attach(){
  PID=$(docker inspect --format {{.State.Pid}} $1)
  nsenter --target $PID --mount --uts --ipc --net --pid
}
# =====================================


# Google Cloud Platform ===============
target='/usr/local/share/autojump/autojump.zsh'
if test -f "$target"; then
  source $target
  [[ -s `brew --prefix`/etc/autojump.zsh ]] && . `brew --prefix`/etc/autojump.zsh
fi

# The next line updates PATH for the Google Cloud SDK.
target='/Users/keith/Library/Mobile Documents/com~apple~CloudDocs/Users/keith@nttpc.co.jp/Library/google-cloud-sdk/path.zsh.inc'
if test -f "$target"; then
  source $target
fi

# # The next line enables shell command completion for gcloud.
# source '/Users/keith/Library/Mobile Documents/com~apple~CloudDocs/Users/keith@nttpc.co.jp/Library/google-cloud-sdk/completion.zsh.inc'

export ALPN_VERSION="8.1.7.v20160121"
target='/usr/libexec/java_home'
if test -f "$target"; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi
# =====================================

