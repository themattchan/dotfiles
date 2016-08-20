#! /bin/sh

function install_dotfiles
{
    DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    declare -a TO_LINK=('irssi' 'vim' 'emacs.d')
    declare -a TO_LINK_SUBDIR=('term' 'vc' 'linux')
    
    for subdir in "${TO_LINK_SUBDIR[@]}"
    do
        echo "linking files in $subdir into home"
        for file in $DOTFILES/$subdir/*
        do
    	ln -s $file ~/.$(basename $file)
        done
    done
    
    for file in "${TO_LINK[@]}"
    do
        echo "Linking file in $file into home"
        ln -s $DOTFILES/$file ~/.$file
    done
}

function install_zprezto
{
    ZP_DIR="${ZDOTDIR:-$HOME}/.zprezto"
    
    git clone --recursive https://github.com/sorin-ionescu/prezto.git $ZP_DIR

    setopt EXTENDED_GLOB
    for rcfile in $ZP_DIR/runcoms/^README.md(.N)
    do
	ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
}

function install_peda
{
    git clone https://github.com/longld/peda.git ~/.peda
    echo "source ~/.peda/peda.py" >> ~/.gdbinit
}

function set_zsh
{
#    sudo usermod -s $(which zsh) $(whoami)
    sudo chsh -s $(which zsh) $(whoami)
}

# install_zprezto
# install_dotfiles
set_zsh
