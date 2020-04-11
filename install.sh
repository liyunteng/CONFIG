#!/usr/bin/env bash
# Description: install

# Copyright (C) 2019 liyunteng
# Last-Updated: <2019/11/16 03:19:02 liyunteng>
set -e
cp -fr .bash_profile ~/
cp -fr .bashrc ~/
cp -fr .clang-format ~/
cp -fr .gitconfig ~/
cp -fr .git-credentials ~/
cp -fr .tmux.conf ~/


github="https://github.com/liyunteng"
my_repos=("c" "cpp" "python" "libs" "ffmpeg" "forks")
zsh_repos="https://"
if [ ! -d ~/git ]; then
    mkdir -p ~/git
fi
if which git > /dev/null; then
    for x in ${my_repos[@]}; do
        p=~/git/$x
        if [ ! -d $p ]; then
            git clone $github/$x $p
        fi
    done

    if [ ! -d ~/.vim_runtime ]; then
        git clone https://github.com/liyunteng/vim ~/.vim_runtime
        ~/.vim_runtime/install_awesome_parameterized.sh ~/.vim_runtime lyt
        cd ~/.vim_runtime && python update_plugins.py && cd -
    fi

    if [ ! -d ~/.oh-my-zsh ]; then
        git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
        ~/.oh-my-zsh/tools/install.sh > /dev/null
    fi
    cp -fr zsh/.zshrc ~/
    if [ -d ~/.oh-my-zsh ]; then
        cp -fr zsh/plugins ~/.oh-my-zsh/
        cp -fr zsh/themes ~/.oh-my-zsh/
    fi

    if [ ! -d ~/.emacs.d ]; then
        git clone https://github.com/liyunteng/emacs ~/.emacs.d
        cd ~/.emacs.d && git checkout develop & cd -
        emacs --debug-init && emacsclient -e "(kill-emacs)"
    fi
fi

