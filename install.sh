#!/usr/bin/env bash
# Description: install

# Copyright (C) 2019 liyunteng
# Last-Updated: <2019/11/16 03:19:02 liyunteng>
set -e

function install_configs() {
    local my_configs=(".bash_profile" ".bashrc" ".clang-format" ".gitconfig" ".git-credentials" ".tmux.conf"
    ".curlrc" ".wgetrc" ".editorconfig" "zsh/.zshrc")
    local target="${HOME}"
    for x in ${my_configs[@]}; do
        cp -fr ${x} ${target}
    done
}

function check_git_cmd() {
    if [[ ! git ]]; then
        echo "Please install 'git' first!"
        exit -1
    fi
}

function install_repos() {
    local my_repos=("c" "cpp" "python" "libs" "ffmpeg" "forks")
    local github="https://github.com/liyunteng"
    local gitopt="--depth=1"
    local gitdir="${HOME}/git"
    local target

    check_git_cmd
    if [[ ! -d ${gitdir} ]]; then
        mkdir -p ${gitdir}
    fi

    for x in ${my_repos[@]}; do
        target=${gitdir}/${x}
        if [[ ! -d ${target} ]]; then
            git clone ${gitopt} ${github}/${x} ${target}
        fi
    done
}

function install_vim() {
    local url="https://github.com/liyunteng/vim"
    local gitopt="--depth=1"
    local target="${HOME}/.vim_runtime"

    check_git_cmd
    if [[ ! -d ${target} ]]; then
        git clone ${gitopt} ${url} ${target}
        ${target}/install_awesome_parameterized.sh ${target} "$USER"
        python3 ${target}/update_plugins.py
    fi
}

function install_zsh() {
    local url="https://github.com/robbyrussell/oh-my-zsh"
    local gitopt="--depth=1"
    local target="${HOME}/.oh-my-zsh"

    check_git_cmd
    if [[ ! -d ${target} ]]; then
        git clone ${gitopt} ${url} ${target}
        ${target}/tools/install.sh > /dev/null
    fi

    if [[ -d ${target} ]]; then
        cp -fr zsh/plugins ${target}
        cp -fr zsh/themes ${target}
    fi
}

function install_emacs() {
    local url="https://github.com/liyunteng/emacs"
    local gitopt="--depth=1"
    local target="${HOME}/.emacs.d"

    check_git_cmd
    if [[ ! -d ${target} ]]; then
        git clone $gitopt ${url} ${target}
        cd ${target} && git checkout develop & cd -
        emacs --debug-init && emacsclient -e "(kill-emacs)"
    fi
}


###############################
INSTALL_GIT_REPOS=1

if [[ $# -ge 1 && $1 == "-n" ]]; then
    INSTALL_GIT_REPOS=0
fi


install_configs
if [[ $INSTALL_GIT_REPOS == 0 ]]; then
    echo "install success"
    exit 0
fi
install_repos
install_zsh
install_vim
install_emacs



