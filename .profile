#
# ~/.profile
#

if [ -f ~/.bash_sysinit ]; then
    . ~/.bash_sysinit
fi
. "$HOME/.cargo/env"
