#!/bin/bash

# Usage:
# ```
# cd <path to the repo>
# bash install.sh
# ```

# read install files locations
files="$(cat files | sed -e 's/#.*$//' -e '/^$/d' files)"

# first entry should be .aliases-and-functions
aliasesAndFunctions="$(echo $files | awk '{print $1}')"

backupDir=~/.dotfilesbackup
currentDir=$(pwd)

for file in $files; do
    parentDir=$(dirname $file)

    # ensure that parent directories exist
    mkdir -p $backupDir/$parentDir ~/$parentDir

    # backup old config files
    mv ~/$file $backupDir/$parentDir

    # create symlinks to the files from the repo
    ln -fs $currentDir/$file ~/$file
done

pathToAliasesAndFunctions="~/$aliasesAndFunctions"

# source .aliases-and-functions in .bashrc if it hasn't been done
if grep -q "source $pathToAliasesAndFunctions" ~/.bashrc; then
    echo "$pathToAliasesAndFunctions already sourced"
else
    printf "\nsource $pathToAliasesAndFunctions\n" >>~/.bashrc
fi

pathToPlug=~/.vim/autoload/plug.vim

# install vim-plug if it hasn't been done
if [ ! -f $pathToPlug ]; then
    curl -fLo $pathToPlug --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall +qall
fi
