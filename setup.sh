#! /bin/sh

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function install_dotfiles
{
    local declare -a TO_LINK=('irssi' 'vim' 'emacs.d')
    local declare -a TO_LINK_SUBDIR=('term' 'vc' 'linux')

    for subdir in "${TO_LINK_SUBDIR[@]}"
    do
        if [[ $(uname -s) != "Linux" && $subdir  == 'linux' ]]; then
            continue
        fi

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

function install_hosts
{
    sudo (cat hosts <(curl https://someonewhocares.org/hosts/hosts) > /etc/hosts)
}

function install_zprezto
{
    local ZP_DIR="${ZDOTDIR:-$HOME}/.zprezto"

    git clone --recursive https://github.com/sorin-ionescu/prezto.git $ZP_DIR

    #setopt EXTENDED_GLOB
    shopt -s extglob
    for rcfile in "$ZP_DIR/runcoms/!(README*)"
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

function install_osx
{
    if [[ $(uname -s) == "Darwin" ]]; then
        source "$DOTFILES/osx/osx"
        cp -R "$DOTFILES/osx/KeyBindings" "$HOME/Library/"
    fi
}

# install_zprezto
# install_dotfiles
set_zsh
