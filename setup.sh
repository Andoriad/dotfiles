#!/bin/bash

# Choose shell
read -p "Select a shell to use [bash/zsh]: " SH
if [ "$SH" != "bash" ] && [ "$SH" != "zsh" ]; then
    echo "Invalid choice. Exiting..."
    exit;
fi

# X11
read -p "Install GUI dot files? [yes/no]: " GUI
if [ "$GUI" != "yes" ] && [ "$GUI" != "no" ]; then
    echo "Invalid choice. Exiting..."
    exit;
fi

# Check for configuration directory
if [ -z $XDG_CONFIG_HOME ]; then
    XDG_CONFIG_HOME=$HOME/.config
fi
mkdir -p $XDG_CONFIG_HOME

# Checks for file or directory and creates a sym link if it 
# doesn't already exist
function ln_s() {
    if [ -e $2 ]; then
        echo "[SKIPPING] \"$2\" (already exists...)"
    else
        echo "[CREATING] \"$2\""
        ln -s $1 $2
    fi
}

echo "Setting up dotfiles..."

# Setup shell
ln_s ${PWD}/${SH}rc ~/.${SH}rc

# Terminator
if [ ! -e ~/.config/terminator ]; then
    mkdir -p ~/.config/terminator
fi
ln_s ${PWD}/terminator ~/.config/terminator/config

# i3 + i3blocks
if [ ! -e ~/.config/i3 ]; then
    mkdir -p ~/.config/i3
fi
ln_s ${PWD}/i3 ~/.config/i3/config
if [ ! -e ~/.config/i3blocks ]; then
    mkdir -p ~/.config/i3blocks
fi
ln_s ${PWD}/i3blocks ~/.config/i3blocks/config

# Gtk 3.0
if [ ! -e ${XDG_CONFIG_HOME}/gtk-3.0/ ]; then
    mkdir ${XDG_CONFIG_HOME}/gtk-3.0/
fi
ln -s ${PWD}/gtkrc-3.0 ${XDG_CONFIG_HOME}/gtk-3.0/settings.ini

# Fonts
if [ ! -e ~/.fonts ]; then
    mkdir ~/.fonts/
fi
ln_s {PWD}/fonts/ ~/.fonts/

# Xresources themes
#ln -s ${PWD}/termcolors ${XDG_CONFIG_HOME}/

# Everything else
for path in "dir_colors" "gitconfig" "gtkrc-2.0"  "gitignore_global" \
            "vim" "vimrc" "xinitrc" "Xresources"; do
    ln_s ${PWD}/${path} ~/.${path}
done

# Vim temp dirs
mkdir -p ~/.vim/tmp/backup
mkdir -p ~/.vim/tmp/yankring

echo "Done!"
echo "Don't forget to install any necessary fonts, icons, etc."
