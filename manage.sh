#!/bin/bash

# Usage:
# ```
# cd <path to the repo>
# bash install.sh
# ```

aliasesAndFunctions=".aliases-and-functions"
backupDir=~/.dotfilesbackup
currentDir=$(pwd)


function unignored-files {
    set -f

    find . -type f  $(printf "! -wholename ./%s " \
        $(cat ignorefiles | sed -e 's/#.*$//' -e '/^$/d')) \
        -printf '%P\n'

    set +f

    # TODO: implement without turning off expansion
}

# files to install
files="$(unignored-files)"

echo "Processing:"
for file in $files; do
    echo "$file"

    parentDir=$(dirname $file)

    # ensure that parent directories exist
    mkdir -p $backupDir/$parentDir ~/$parentDir

    # backup old config files
    mv ~/$file $backupDir/$parentDir

    # create symlinks to the files from the repo
    ln -fs $currentDir/$file ~/$file
done

echo

find .scripts -type f -exec chmod +x {} \;

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
