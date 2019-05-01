#!/bin/bash

# Bash's dotfiles are added in install.sh

# Sets up the base16 bash configs
if [ ! -d "${HOME}/.config/base16-shell" ]; then
	git clone https://github.com/chriskempson/base16-shell.git "${HOME}/.config/base16-shell"
fi
