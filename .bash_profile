#!/usr/bin/evn bash

MY_PATH=

[[ -f ~/.bashrc ]] && . ~/.bashrc

# init pyenv
if which pyenv > /dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

export PATH=${PATH}:${MY_PATH}
