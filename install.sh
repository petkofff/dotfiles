#!/bin/bash

# Usage:
# ``` 
# cd <path to the repo>
# bash install.sh
# ```

aliasesAndFunctions=".aliases-and-functions"
files="$aliasesAndFunctions .tmux.conf .gitconfig"
backupDir=~/.dotfilesbackup
currentDir=`pwd`

mkdir -p $backupDir

for file in $files; do
    mv ~/$file $backupDir               # backup old config files
    ln -fs $currentDir/$file ~/$file    # create symlinks to the files from the repo
done

pathToAliasesAndFunctions="~/$aliasesAndFunctions"

# source .aliases-and-functions in .bashrc if it hasn't been done
if grep -q "source $pathToAliasesAndFunctions" ~/.bashrc; then
    echo "$pathToAliasesAndFunctions already sourced"
    else
        printf "\nsource $pathToAliasesAndFunctions\n" >> ~/.bashrc
fi

