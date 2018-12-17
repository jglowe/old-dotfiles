#!/bin/bash

if [ ! -L ~/.vimrc ]; then 
	if [ -f ~/.vimrc ]; then
		mv ~/.vimrc "~/.vimrc-$(date +%Y-%m-%d-%H:%M:%S).old"
	fi

	ln -s "$(pwd)/.vimrc" ~/.vimrc
fi

if [ ! -f ~/.vim/autoload/plug.vim ]; then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim +PlugInstall +qall <<< "\n"
