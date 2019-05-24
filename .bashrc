# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
# User specific aliases and functions

export HISTSIZE=
export HISTFILESIZE=
export HISTCONTROL=ignorespace
shopt -s histappend

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PS1='[\u@\h \W]$(parse_git_branch)\$ '

# PATH Android develop

# PATH nvm

