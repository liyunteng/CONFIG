#!/usr/bin/env bash
# Description: install

# Copyright (C) 2019 liyunteng
# Last-Updated: <2020/12/16 10:32:44>
set -e
INSTALL_CONFIG=${INSTALL_CONFIG:-yes}
INSTALL_SSH=${INSTALL_SSH:-yes}
INSTALL_ZSH=${INSTALL_ZSH:-yes}
INSTALL_VIM=${INSTALL_VIM:-no}
INSTALL_EMACS=${INSTALL_EMACS:-no}
INSTALL_ALL=${INSTALL_ALL:-no}

check () {
    if [[ ! git ]]; then
        echo "Please install 'git' first!"
        exit -1
    fi

    git submodule init
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

    cp -af ${src} ${target}
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
    chmod 0400 ${target}/id_rsa
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
}

install_zsh() {
    local src=oh-my-zsh

    git submodule update ${src}
    create_link ${src} 1
    create_link zsh-custom 1
}

install_emacs() {
    local src=emacs.d

    git submodule update ${src}
    create_link ${src} 1
    if [[ emacs ]]; then
        emacs -nw --debug-init --eval "(kill-emacs)"
    fi
}

install_vim () {
    local src=vim_runtime
    local target=${HOME}/.${src}
    local pyexec=python

    git submodule update ${src}
    create_link ${src} 1

    ${target}/install_awesome_parameterized.sh ${target} "$USER"
    [[ python3 ]] && pyexec=python3
    ${pyexec} ${target}/update_plugins.py
}

usage() {
    cat <<-EOF
${0} [all | help | config | ssh | zsh | vim | emacs].

    all         install all.
    config      install config (default)
    ssh         install ssh config (default)
    zsh         install zsh config (default)
    vim         install vim config
    emacs       install emacs config
    help        help
EOF
}

###############################
main() {
    # Parse arguments
    if [[ $# -gt 0 ]];then
        INSTALL_CONFIG=no
        INSTALL_SSH=no
        INSTALL_ZSH=no
    fi

    while [ $# -gt 0 ]; do
        case $1 in
            all)        INSTALL_ALL=yes ;;
            config)     INSTALL_CONFIG=yes;;
            ssh)        INSTALL_SSH=yes;;
            zsh)        INSTALL_ZSH=yes;;
            vim)        INSTALL_VIM=yes;;
            emacs)      INSTALL_EMACS=yes;;
            -h|help) usage
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
        INSTALL_SSH=yes
    fi

    check

    if [[ ${INSTALL_CONFIG} == "yes" ]]; then
        install_configs
    fi

    if [[ ${INSTALL_SSH} == "yes" ]]; then
        install_ssh
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
