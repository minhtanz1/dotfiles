#
# ~/.bash_profile
#
#
[[ -f ~/.bashrc ]] && . ~/.bashrc
if [ -f ~/.bash_sysinit ]; then
    . ~/.bash_sysinit
fi
. "$HOME/.cargo/env"
