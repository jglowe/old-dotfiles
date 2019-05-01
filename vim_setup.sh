#!/bin/bash

# Vim's dotfiles are added in install.sh

# Adds vim's plugin manager
if [ ! -f ~/.vim/autoload/plug.vim ]; then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim +PlugInstall +qall <<< "\n"
