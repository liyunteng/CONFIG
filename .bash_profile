#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# If you come from bash you might have to change your $PATH.
export PATH=${PATH}:${HOME}/.pyenv/bin

# init pyenv
which pyenv > /dev/null 2>&1 && eval "$(pyenv init -)"
