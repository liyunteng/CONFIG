#!/usr/bin/env zsh

# ZSH_THEME="my-clear"
# ZSH_THEME="my"

[[ -f ~/.zshrc ]] && . ~/.zshrc

# add .pyenv/bin to PATH
export PATH=${PATH}:${HOME}/.pyenv/bin

# disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1

# init pyenv
which pyenv > /dev/null 2>&1 && eval "$(pyenv init -)"
