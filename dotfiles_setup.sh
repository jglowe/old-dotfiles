#!/bin/bash


if [ ! -L ~/.bashrc ]; then
	if [ -f ~/.bashrc ]; then
		mv ~/.bashrc "~/.bashrc-$(date +%Y-%m-%d-%H:%M:%S).old"
	fi

	ln -s "$(pwd)/.bashrc" ~/.bashrc
fi

if [ ! -L ~/.gitconfig ]; then
	if [ -f ~/.gitconfig ]; then
		mv ~/.gitconfig "~/.gitconfig-$(date +%Y-%m-%d-%H:%M:%S).old"
	fi

	ln -s "$(pwd)/.gitconfig" ~/.gitconfig
fi

if [ ! -L ~/.tmux.conf ]; then
	if [ -f ~/.tmux.conf ]; then
		mv ~/.tmux.conf "~/.tmux.conf-$(date +%Y-%m-%d-%H:%M:%S).old"
	fi

	ln -s "$(pwd)/.tmux.conf" ~/.tmux.conf
fi

if [ ! -L ~/.alacritty.yml ]; then
	if [ -f ~/.alacritty.yml ]; then
		mv ~/.alacritty.yml "~/.alacritty-$(date +%Y-%m-%d-%H:%M:%S).old"
	fi

	ln -s "$(pwd)/.alacritty.yml" ~/.alacritty.yml
fi

./vim_setup.sh
