#!/bin/bash

function link_dotfile () {
	file=$1
	destination="${HOME}/${file}"

	if [ ! -L "${destination}" ]; then
		if [ -f "${destination}" ]; then
			mv "${destination}" "${destination}-$(date +%Y-%m-%d-%H:%M:%S).old"
		fi

		ln -s "$(pwd)/${file}" "${destination}"
	fi
}

link_dotfile ".bashrc"
link_dotfile ".bash_aliases"
link_dotfile ".gitconfig"
link_dotfile ".gitignore_global"
link_dotfile ".tmux.conf"
link_dotfile ".alacritty.yml"

if [ ! -d "${HOME}/.config/base16-shell" ]; then
	git clone https://github.com/chriskempson/base16-shell.git "${HOME}/.config/base16-shell"
fi

./vim_setup.sh
