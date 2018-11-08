#! /bin/sh

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXTERNAL="$DOTFILES/external"

function install_dotfiles
{
    local declare -a TO_LINK=('vim')
    local declare -a TO_LINK_SUBDIR=('term' 'vc' 'linux')

    for subdir in "${TO_LINK_SUBDIR[@]}"; do
        if [[ $(uname -s) != "Linux" && $subdir  == 'linux' ]]; then
            continue
        fi

        echo "linking files in $subdir into home"
        for file in $DOTFILES/$subdir/*; do
        ln -s $file ~/.$(basename $file)
        done
    done

    for file in "${TO_LINK[@]}"; do
        echo "Linking file in $file into home"
        ln -s $DOTFILES/$file ~/.$file
    done

    if [[ $(uname -s) == "Darwin" ]]; then
        cp -R "$DOTFILES/osx/KeyBindings" "$HOME/Library/"
        source "$DOTFILES/osx/osx"
    fi
}


function install_external
{
    cd $EXTERNAL
    git clone --recursive https://github.com/sorin-ionescu/prezto.git

    #setopt EXTENDED_GLOB
    pushd prezto
    shopt -s extglob
    for file in "./runcoms/!(README*)"; do
        ln -s "$file" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
    popd

    # z
    git clone https://github.com/rupa/z z
}

install_external
install_dotfiles

#    sudo usermod -s $(which zsh) $(whoami)
sudo chsh -s $(which zsh) $(whoami)
