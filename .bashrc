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

path_prepend() {
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1${PATH:+:$PATH}" ;;
    esac
}

path_append() {
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="${PATH:+$PATH:}$1" ;;
    esac
}

[ -d "$HOME/.local/bin" ] && path_prepend "$HOME/.local/bin"
[ -d "$HOME/bin" ] && path_append "$HOME/bin"

# Examples for optional toolchains:
# [ -d "$HOME/.cargo/bin" ] && path_append "$HOME/.cargo/bin"
# [ -d "$HOME/Android/Sdk/platform-tools" ] && path_append "$HOME/Android/Sdk/platform-tools"
# [ -d "$HOME/Android/Sdk/tools" ] && path_append "$HOME/Android/Sdk/tools"

# Prefer mise for language runtimes and developer tools.
# Install mise separately from https://mise.jdx.dev/; this shell activates it when available.
if command -v mise > /dev/null 2>&1; then
    eval "$(mise activate bash)"
fi
