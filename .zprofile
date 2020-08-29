#
# ~/.zprofile
#

MY_PATH=

[[ -f ~/.zshrc ]] && . ~/.zshrc

# disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1

# init pyenv
if which pyenv > /dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

export PATH=${PATH}:${MY_PATH}
