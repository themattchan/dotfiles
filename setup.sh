#! /bin/sh

shopt -s extglob

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXTERNAL="$DOTFILES/external"

function install_dotfiles
{
    local declare -a TO_LINK=('vim')
    local declare -a TO_LINK_SUBDIR=('term' 'vc')

    for subdir in "${TO_LINK_SUBDIR[@]}"; do
        if [[ $(uname -s) != "Linux" && $subdir  == 'linux' ]]; then
            continue
        fi

        echo "linking files in $subdir into home"
        for file in $DOTFILES/$subdir/*; do
            ln -sf $file ~/.$(basename $file)
        done
    done

    for file in "${TO_LINK[@]}"; do
        echo "Linking file in $file into home"
        ln -sf $DOTFILES/$file ~/.$file
    done

    if [[ $(uname -s) == "Darwin" ]]; then
        cp -R "$DOTFILES/osx/KeyBindings" "$HOME/Library/"
        source "$DOTFILES/osx/osx"
    fi
}

# function install_hosts
# {
#     sudo (cat hosts <(curl https://someonewhocares.org/hosts/hosts) > /etc/hosts)
# }

function install_external
{
    cd $EXTERNAL
    git clone --recursive https://github.com/sorin-ionescu/prezto.git zprezto

    #setopt EXTENDED_GLOB
    pushd zprezto
     for file in $(ls ./runcoms/!(README*)); do
        ln -sf "$(pwd)/${file:2}" "$HOME/.$(basename $file)"
    done
    popd

    # z
    git clone https://github.com/rupa/z z
}

install_external
install_dotfiles

#    sudo usermod -s $(which zsh) $(whoami)
#sudo chsh -s $(which zsh) $(whoami)
