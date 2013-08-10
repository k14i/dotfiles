# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH
unset USERNAME

export LANG=ja_JP.UTF-8
export CLICOLOR=yes
#export PS1='[\u@\h \w]\\$ '

test -r /sw/bin/init.sh && . /sw/bin/init.sh

# Android SDK
export PATH=$PATH:/Users/keith/lib/android-sdk-mac_86/platform-tools
