#!/usr/bin/env bash
# Description: install

# Copyright (C) 2019 liyunteng
# Last-Updated: <2019/11/16 03:19:02 liyunteng>
set -e
INSTALL_GIT_REPOS=1

if [[ $# -ge 1 && $1 == "-n" ]]; then
    INSTALL_GIT_REPOS=0
fi

cp -fr .bash_profile ~/
cp -fr .bashrc ~/
cp -fr .clang-format ~/
cp -fr .gitconfig ~/
cp -fr .git-credentials ~/
cp -fr .tmux.conf ~/
cp -fr zsh/.zshrc ~/

if [[ $INSTALL_GIT_REPOS == 0 ]]; then
    echo "install success"
    exit 0
fi

github="https://github.com/liyunteng"
gitopt="--depth=1"
my_repos=("c" "cpp" "python" "libs" "ffmpeg" "forks")
if [[ ! -d ~/git ]]; then
    mkdir -p ~/git
fi

if which git > /dev/null; then
    for x in ${my_repos[@]}; do
        p=~/git/$x
        if [ ! -d $p ]; then
            git clone $gitopt $github/$x $p
        fi
    done

    if [[ ! -d ~/.vim_runtime ]]; then
        git clone $gitopt https://github.com/liyunteng/vim ~/.vim_runtime
        ~/.vim_runtime/install_awesome_parameterized.sh ~/.vim_runtime "$USER"
        cd ~/.vim_runtime && python3 update_plugins.py && cd -
    fi

    if [[ ! -d ~/.oh-my-zsh ]]; then
        git clone $gitopt https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
        ~/.oh-my-zsh/tools/install.sh > /dev/null
    fi

    if [[ -d ~/.oh-my-zsh ]]; then
        cp -fr zsh/plugins ~/.oh-my-zsh/
        cp -fr zsh/themes ~/.oh-my-zsh/
    fi

    if [[ ! -d ~/.emacs.d ]]; then
        git clone $gitopt https://github.com/liyunteng/emacs ~/.emacs.d
        cd ~/.emacs.d && git checkout develop & cd -
        emacs --debug-init && emacsclient -e "(kill-emacs)"
    fi

    echo "install success"
    exit 0
else
    echo "please install 'git'!"
    exit -1
fi

