#!/bin/bash

if [ ! -L "$HOME/.vimrc" ]; then
	if [ -f "$HOME/.vimrc" ]; then
		mv "$HOME/.vimrc" "$HOME/.vimrc-$(date +%Y-%m-%d-%H:%M:%S).old"
	fi

	ln -s "$(pwd)/.vimrc" "$HOME/.vimrc"
fi

if [ ! -f ~/.vim/autoload/plug.vim ]; then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim +PlugInstall +qall <<< "\n"
