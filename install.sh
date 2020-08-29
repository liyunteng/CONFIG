#!/usr/bin/env bash
# Description: install

# Copyright (C) 2019 liyunteng
# Last-Updated: <2019/11/16 03:19:02 liyunteng>
set -e
INSTALL_GIT_REPOS=${INSTALL_GIT_REPOS:-no}

install_configs() {
    local my_configs=(
    "bash_profile" "bashrc" "alias.sh" "zshrc"
    "gitconfig" "gitignore"
    "tmux.conf" "tmux.conf.local" "clang-format"
    "curlrc" "wgetrc" "editorconfig"
    )
    local my_repos=("emacs.d" "vim_runtime" "oh-my-zsh" "ssh")

    local target="${HOME}"
    for x in ${my_configs[@]}; do
        # cp -af ${x} ${target}
        ln -sfr -T "$(readlink -f ${x})" ${HOME}/.${x}
        echo "install ${HOME}/.${x} -->  $(readlink -f ${x})"
    done
    for x in ${my_repos[@]};do
    	if [[ -d ${HOME}/.${x} ]]; then
	        rm -rf ${HOME}/.${x}
	    fi
        ln -sfr -T "$(readlink -f ${x})" ${HOME}/.${x}
        echo "install ${HOME}/.${x} -->  $(readlink -f ${x})"
    done

    cp -af zsh/plugins ${HOME}/.oh-my-zsh/plugins
    cp -af zsh/themes ${HOME}/.oh-my-zsh/themes

    # ${HOME}/.vim_runtime/install_awesome_parameterized.sh ${HOME}/.vim_runtime "$USER"
    # python2 ${HOME}/.vim_runtime/update_plugins.py
    # if [[ emacs ]]; then
        # emacs --debug-init && emacsclient -e "(kill-emacs)"
    # fi
}

check_git_cmd() {
    if [[ ! git ]]; then
        echo "Please install 'git' first!"
        exit -1
    fi
}

git_clone() {
    local url=$1
    local gitopt=$2
    local target=$3

    check_git_cmd
    git clone ${gitopt} ${url} ${target}

    return $?
}

install_repos() {
    local my_repos=("c" "cpp" "python" "libs" "ffmpeg" "forks")
    local github="https://github.com/liyunteng"
    local gitopt="--depth=1"
    local gitdir="${HOME}/git"
    local target

    if [[ ! -d ${gitdir} ]]; then
        mkdir -p ${gitdir}
    fi

    for x in ${my_repos[@]}; do
        target=${gitdir}/${x}
        if [[ ! -d ${target} ]]; then
            git_clone ${github}/$x ${gitopt} ${target}
        fi
    done
}

install_vim() {
    local url="https://github.com/liyunteng/vim"
    local gitopt="--recursive"
    local target="${HOME}/.vim_runtime"

    if [[ ! -d ${target} ]]; then
        git_clone ${gitopt} ${url} ${target}
        ${target}/install_awesome_parameterized.sh ${target} "$USER"
        if [[ python3 ]]; then
            python3 ${target}/update_plugins.py
        fi
    fi
}

install_zsh() {
    # local url="https://github.com/robbyrussell/oh-my-zsh"
    # local gitopt="--depth=1"
    local target="${HOME}/.oh-my-zsh"

    # git_clone ${gitopt} ${url} ${target}
    # ${target}/tools/install.sh > /dev/null
    if [[ ! -d  ${target} ]]; then
        zsh/install-zsh.sh
    fi

    cp -af zsh/plugins ${target}
    cp -af zsh/themes ${target}
}

install_emacs() {
    local url="https://github.com/liyunteng/emacs"
    local gitopt="--recursive -b develop"
    local target="${HOME}/.emacs.d"

    if [[ ! -d ${target} ]]; then
        git_clone ${gitopt} ${url} ${target}
        if [[ emacs ]]; then
            emacs --debug-init && emacsclient -e "(kill-emacs)"
        fi
    fi
}

usage() {
    cat <<-EOF
${0} [-a | -n | -h].

    -a      install all.
    -n      only install config (default).
    -h      help
EOF
}

###############################
main() {
    # Parse arguments
    while [ $# -gt 0 ]; do
        case $1 in
            -a) INSTALL_GIT_REPOS=yes ;;
            -n) INSTALL_GIT_REPOS=no ;;
            -h) usage
                exit 0;;
            *) usage
                exit -1;;
        esac
        shift
    done


    install_configs
    install_zsh
    if [[ ${INSTALL_GIT_REPOS} == "yes" ]]; then
        install_repos
        install_vim
        install_emacs
    fi

    echo "Install success"
    exit 0
}

main "$@"

