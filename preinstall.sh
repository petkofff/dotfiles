#!/bin/bash

# Usage:
# ```
# cd <path to the repo>
# bash preinstall.sh <base|most|all> # default is base
# ```

shopt -s expand_aliases

base="vim emacs tmux zsh git nnn fzf curl"
most="$base base-devel htop wget pwgen rsync less chromium tree"
all="$most texlive-most texlive-lang gimp"

alias pac="sudo pacman -S --needed"

if [ "$1" = "most" ]; then
    pac $most
elif [ "$1" = "all" ]; then
    pac $all
else
    pac $base
fi

# install spacemacs if it hasn't been done
if [ ! -f ~/.emacs.d/spacemacs.mk ]; then
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
fi
