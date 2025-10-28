#
# ~/.bashrc
#
if [ -f ~/.bash_sysinit ]; then
    . ~/.bash_sysinit
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

LS_COLORS='di=34:ln=35:ex=31'
export LS_COLORS
export PATH=/usr/bin/zathura:$PATH
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -l --color=auto'
alias la='ls -A'
alias l='ls -la --color=auto'
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

export HISTCONTROL=ignoreboth:erasedups
HISTSIZE=100
HISTFILESIZE=200
export DISPLAY=$(ip route list default | awk '{print $3}'):0
export LIBGL_ALWAYS_INDIRECT=1
export LANG=en_US.UTF-8
export LC_ALL=C.UTF-8
. "$HOME/.cargo/env"
