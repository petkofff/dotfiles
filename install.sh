#!/bin/bash

pathToAliasesAndFunctions="~/.aliases-and-functions"

cp ./bash/.aliases-and-functions ~
if grep -q "source $pathToAliasesAndFunctions" ~/.bashrc; then
    echo "$pathToAliasesAndFunctions already sourced"
    else
        printf "\nsource $pathToAliasesAndFunctions\n" >> ~/.bashrc
fi

cp .tmux.conf ~
cp .gitconfig ~
