#!/bin/bash

# Usage:
# ```
# cd <path to the repo>
# bash manage.sh
# ```

ARGS=$@

aliasesAndFunctions=".aliases-and-functions"
backupDir=~/.dotfilesbackup
currentDir=$(pwd)

function help_message {
    # TODO
}

function restore_backup {
    # TODO
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
    files="$(unignored_files)"

    echo "Processing:"
    for file in $files; do
        echo "$file"

        parentDir=$(dirname $file)

        # ensure that parent directories exist
        mkdir -p $backupDir/$parentDir ~/$parentDir

        # backup old config files
        mv ~/$file $backupDir/$parentDir
        #
        # TODO: don't backup already installed symlinks to the
        #       files from the repo
        #

        # create symlinks to the files from the repo
        ln -fs $currentDir/$file ~/$file
    done

    echo

    find .scripts -type f -exec chmod +x {} \;

    path_to_aliases_and_functions="~/$aliasesAndFunctions"

    # source .aliases-and-functions in .bashrc if it hasn't been done
    if grep -q "source $path_to_aliases_and_functions" ~/.bashrc; then
        echo "$path_to_aliases_and_functions already sourced"
    else
        printf "\nsource $path_to_aliases_and_functions\n" >>~/.bashrc
    fi
}


passed "-symlinks" || passed "-links" || passed "-symlink" || passed "-link" || {
    make_symlinks_and_backup
}

pathToPlug=~/.vim/autoload/plug.vim

# install vim-plug if it hasn't been done
if [ ! -f $pathToPlug ]; then
    curl -fLo $pathToPlug --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall +qall
fi
