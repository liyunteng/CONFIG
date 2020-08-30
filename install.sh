#!/usr/bin/env bash
# Description: install

# Copyright (C) 2019 liyunteng
# Last-Updated: <2019/11/16 03:19:02 liyunteng>
set -e
INSTALL_GIT_REPOS=${INSTALL_GIT_REPOS:-no}

update () {
    if [[ ! git ]]; then
        echo "Please install 'git' first!"
        exit -1
    fi

    git submodule init
    git submodule update
}

create_link () {
    local src="$(pwd)/$1"
    local target="${HOME}/.$1"
    if [[ $2 && -e ${target} ]]; then
        rm -rf ${target}
        echo "rm ${target}"
    fi
    ln -sf ${src} ${target}
    echo "install ${target} --> ${src}"
}

install_configs() {
    local my_configs=(
    bash_profile bashrc alias.sh zshrc
    gitconfig gitignore
    tmux.conf tmux.conf.local clang-format
    curlrc wgetrc editorconfig
    )
    local my_repos=(emacs.d vim_runtime oh-my-zsh ssh)
    local target=
    local src=
    for x in ${my_configs[@]}; do
        create_link ${x}
    done

    create_link ssh 1
}

install_zsh() {
    local src=oh-my-zsh
    local target=${HOME}/.{src}

    create_link ${src} 1
    cp -af zsh/plugins ${target}
    cp -af zsh/themes ${target}
}

install_emacs() {
    local src=emacs.d

    create_link ${src} 1
    if [[ emacs ]]; then
        emacs -nw --debug-init --eval "(kill-emacs)"
    fi
}

install_vim () {
    local src=vim_runtime
    local target=${HOME}/.${src}
    local pyexec=python

    create_link ${src} 1

    ${target}/install_awesome_parameterized.sh ${target} "$USER"
    [[ python3 ]] && pyexec=python3
    ${pyexec} ${target}/update_plugins.py
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

    update

    install_configs
    install_zsh
    if [[ ${INSTALL_GIT_REPOS} == "yes" ]]; then
        install_vim
        install_emacs
    fi

    echo "Install success"
    exit 0
}

main "$@"

