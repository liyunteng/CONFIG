#!/usr/bin/bash
# Description: install

# Copyright (C) 2019 liyunteng
# Last-Updated: <2019/11/16 03:19:02 liyunteng>
cd ~/git
cp -nf .bash_profile ~/
cp -nf .bashrc ~/
cp -nf .clang-format ~/
cp -nf .gitconfig ~/
cp -nf .git-credentials ~/
cp -nf .tmux.conf ~/
cp -nf zsh/.zshrc ~/
if [ -d ~/.oh-my-zsh ]; then
   cp -nfr zsh/plugins ~/.oh-my-zsh/
   cp -nfr zsh/thems ~/.oh-my-zsh/
fi

git clone https://github.com/liyunteng/vim ~/.vim_runtime
~/.vim_runtime/install_awesome_parameterized.sh ~/.vim_runtime lyt
cd ~/.vim_runtime && python update_plugins.py
cd -

git clone https://github.com/liyunteng/emacs ~/.emacs.d
emacs --debug-init
