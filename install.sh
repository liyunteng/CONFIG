#!/usr/bin/env bash
# Description: install

# Copyright (C) 2019 liyunteng
# Last-Updated: <2019/11/16 03:19:02 liyunteng>
set -e
INSTALL_CONFIG=${INSTALL_CONFIG:-yes}
INSTALL_ZSH=${INSTALL_ZSH:-yes}
INSTALL_VIM=${INSTALL_VIM:-no}
INSTALL_EMACS=${INSTALL_EMACS:-no}
INSTALL_ALL=${INSTALL_ALL:-no}

update () {
    if [[ ! git ]]; then
        echo "Please install 'git' first!"
        exit -1
    fi

    git submodule init
    git submodule update
}

# create_link src delete?
create_link () {
    local src="$(pwd)/$1"
    local target="${HOME}/.$1"
    if [[ $2 && -e ${target} ]]; then
        rm -rf ${target}
        echo "rm   ${target}"
    fi
    ln -sf ${src} ${target}
    echo "link ${src} --> ${target}"
}


# create_copy src target
create_copy () {
    local src="$(pwd)/$1"
    local target=$2

    cp -rf ${src} ${target}
    echo "copy ${src} ==> ${target}"
}

install_ssh () {
    local target=${HOME}/.ssh

    if [[ -L ${target} ]]; then
        rm -rf ${target}
        echo "rm   ${target}"
    fi
    if [[ ! -e ${target} ]]; then
        mkdir -p ${target}
    fi

    create_copy ssh/config ${target}
    create_copy ssh/id_rsa ${target}
    create_copy ssh/id_rsa.pub ${target}
    create_copy ssh/aws_test_env.pem ${target}
}

install_configs () {
    local my_configs=(
        bash_profile bashrc alias.sh zshrc
        gitconfig gitignore
        tmux.conf tmux.conf.local clang-format
        curlrc wgetrc editorconfig
    )
    for x in ${my_configs[@]}; do
        create_link ${x}
    done

    install_ssh
}

install_zsh() {
    local src=oh-my-zsh
    local target=${HOME}/.${src}

    create_link ${src} 1
    create_copy zsh/plugins ${target}
    create_copy zsh/themes ${target}
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
${0} [-a | -h | config | zsh | vim | emacs].

    -a      install all.
    config  install config (default)
    zsh     install zsh config
    vim     install vim config
    emacs   install emacs config
    -h      help
EOF
}

###############################
main() {
    # Parse arguments
    while [ $# -gt 0 ]; do
        case $1 in
            -a) INSTALL_ALL=yes ;;
            emacs) INSTALL_EMACS=yes;;
            vim) INSTALL_VIM=yes;;
            zsh) INSTALL_ZSH=yes;;
            config) INSTALL_CONFIG=yes;;
            -h) usage
                exit 0;;
            *) usage
                exit -1;;
        esac
        shift
    done
    if [[ ${INSTALL_ALL} == "yes" ]]; then
        INSTALL_CONFIG=yes
        INSTALL_ZSH=yes
        INSTALL_VIM=yes
        INSTALL_EMACS=yes
    fi

    update

    if [[ ${INSTALL_CONFIG} == "yes" ]]; then
        install_configs
    fi

    if [[ ${INSTALL_ZSH} == "yes" ]]; then
        install_zsh
    fi

    if [[ ${INSTALL_VIM} == "yes" ]]; then
        install_vim
    fi

    if [[ ${INSTALL_EMACS} == "yes" ]]; then
        install_emacs
    fi

    echo "Install success"
    exit 0
}

main "$@"

