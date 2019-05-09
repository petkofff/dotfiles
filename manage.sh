#!/bin/bash

# Usage:
# ```
# cd <path to the repo>
# bash manage.sh
# ```

ARGS=$@

aliased_and_functions=".aliases-and-functions"
backup_dir=~/.dotfilesbackup
currentDir=$(pwd)
current_dir=$(pwd)

function help_message {
    # TODO
    :
}

function restore_backup {
    # TODO
    :
}

function passed {
    for arg in $ARGS; do
       if [ "$1" = "$arg" ]; then
            return 0
       fi
    done

    return 1
}

packages=""

if passed "base"; then
    packages="$(cat packages/arch/base.txt)"
fi

if passed "all"; then
    packages="$(cat packages/arch/all.txt)"
fi

if [ ! "$packages" = "" ]; then
    sudo pacman -S --noconfirm --needed $packages
fi

passed "-spacemacs" || passed "-space" || {
    if [ ! -f ~/.emacs.d/spacemacs.mk ]; then
        git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
    fi
}

function unignored_files {
    set -f

    find . -type f  $(printf "! -wholename ./%s " \
        $(cat ignorefiles | sed -e 's/#.*$//' -e '/^$/d')) \
        -printf '%P\n'

    set +f
}

function make_symlinks_and_backup {
    # files to install
    local files="$(unignored_files)"

    echo "Processing:"
    for file in $files; do
        echo "$file"

        local parent_dir=$(dirname $file)

        # ensure that parent directories exist
        mkdir -p $backup_dir/$parent_dir ~/$parent_dir

        # backup old config files
        mv ~/$file $backup_dir/$parent_dir
        #
        # TODO: don't backup already installed symlinks to the
        #       files from the repo
        #

        # create symlinks to the files from the repo
        ln -fs $current_dir/$file ~/$file
    done

    echo

    find .scripts -type f -exec chmod +x {} \;

    path_to_aliases_and_functions="~/$aliased_and_functions"

    # source .aliases-and-functions in .bashrc if it hasn't been done
    if grep -q "source $path_to_aliases_and_functions" ~/.bashrc; then
        echo "$path_to_aliases_and_functions already sourced"
    else
        printf "\nsource $path_to_aliases_and_functions\n" >> ~/.bashrc
    fi
}


passed "-symlinks" || passed "-links" || passed "-symlink" || passed "-link" || {
    make_symlinks_and_backup
}

path_to_plug=~/.vim/autoload/plug.vim

# install vim-plug if it hasn't been done
if [ ! -f $path_to_plug ]; then
    curl -fLo $path_to_plug --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall +qall
fi

function install_anaconda {
    local archive="https://repo.anaconda.com/archive/"

    function latest_install_file {
        curl $archive | grep -o 'Anaconda3[0-9.-]*-Linux-x86_64.sh' | head -1
    }

    local install_file="$(latest_install_file)"
    echo
    echo "Attempt to download: $install_file"
    curl $archive$install_file -o "$install_file"
    bash "$install_file"
    rm "$install_file"
}

if passed "anaconda" || passed "conda"; then
    if [ -d ~/anaconda3 ]; then
        echo "Anaconda already installed"
    else
        install_anaconda
    fi
fi

