#!/bin/bash

ARGS=$@
aliased_and_functions=".aliases-and-functions"
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
backup_dir="$HOME/.dotfilesbackup"

function help_message {
    local name="$(basename "$0")"
    local usage="Usage:
    cd <path to the repo>
    ./$name [arguments]

Default behaviour:
    By default $name will try to install vim-plug, spacemacs if this
    has not been done and create symlinks to all the files from the repo
    except those listed in ignorefiles.

Accepted arguments:
    help
        shows this message
    base
        installs the packages listed in packages/arch/base.txt
    all
        installs the packages listed in packages/arch/all.txt
    anaconda, conda
        installs anaconda
    -spacemacs, -space
        will not attempt to install spacemacs
    -symlinks, -links, -symlink, -link
        will not attempt to make symlinks to the files from the repo
    "

    echo "$usage"
}

function passed {
    for arg in $ARGS; do
       if [ "$1" = "$arg" ]; then
            return 0
       fi
    done

    return 1
}

if passed "help"; then
    help_message
    exit 0
fi

function info {
    printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

function ask {
    printf "\r  [ \033[0;33m??\033[0m ] $1"
}

function ok () {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

function fail () {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
}

function check_availability {
    local needed="git readlink find pacman curl"

    info "availability check..."

    local success=1

    for c in $needed; do
        if ! command -v "$c" > /dev/null; then
            fail "could not find \`$c\`"
            success=0
        fi
    done

    if [ $success = 0 ]; then
        ask "continue running the script? [Y/n] "
        local ans="y"
        read ans

        if [ "$ans" = "n" ]; then
            exit 1
        fi
    fi
}

check_availability

packages=""

if passed "base"; then
    packages="$(cat packages/arch/base.txt)"
fi

if passed "all"; then
    packages="$(cat packages/arch/all.txt)"
fi

if [ ! "$packages" = "" ]; then
    sudo bash -c "for p in \"$packages\"; do
                      pacman -S --noconfirm --needed \$p
                  done"
fi

passed "-spacemacs" || passed "-space" || {
    if [ ! -f "$HOME/.emacs.d/spacemacs.mk" ]; then
        info "installing spacemacs..."
        git clone https://github.com/syl20bnr/spacemacs "$HOME/.emacs.d"
    fi
}

function unignored_files {
    set -f

    local uncommented="$(cat ignorefiles | sed -e 's/#.*$//' -e '/^$/d')"

    find . -type f  $(printf "! -wholename ./%s " $uncommented) -printf '%P\n'

    set +f
}

function restore_backup {
    local files="$(unignored_files)"

    # # # # #
    # TO DO #
    # # # # #
}

function make_symlinks_and_backup {
    # files to install
    local files="$(unignored_files)"

    info "linking and creating backups..."

    for file in $files; do
        local parent_dir=$(dirname $file)

        mkdir -p $HOME/$parent_dir

        # backup old config files
        if [ -f "$HOME/$file" ]; then
            local link_to="$(readlink "$HOME/$file")"
            if [ ! "$link_to" = "$current_dir/$file" ]; then

                # ensure that parent directories exist
                mkdir -p $backup_dir/$parent_dir

                mv $HOME/$file $backup_dir/$parent_dir && \
                    ok "copied file:  $HOME/$file -> $backup_dir/$parent_dir"
            fi
        else
            info "doesn't exist: $HOME/$file"
        fi

        # create symlinks to the files from the repo
        ln -fs "$current_dir/$file" "$HOME/$file" && \
            ok "created link: $current_dir/$file -> $HOME/$file"
    done

    find $current_dir/.scripts -type f -exec chmod +x {} \;

    path_to_aliases_and_functions="$HOME/$aliased_and_functions"

    # source .aliases-and-functions in .bashrc if it hasn't been done
    if grep -q "source $path_to_aliases_and_functions" ~/.bashrc; then
        info "$path_to_aliases_and_functions already sourced into .bashrc"
    else
        printf "\nsource $path_to_aliases_and_functions\n" >> ~/.bashrc && \
            ok "sourced $path_to_aliases_and_functions into .bashrc"
    fi
}


passed "-symlinks" || passed "-links" || passed "-symlink" || passed "-link" || {
    make_symlinks_and_backup
}

path_to_plug="$HOME/.vim/autoload/plug.vim"

# install vim-plug if it hasn't been done
if [ ! -f $path_to_plug ]; then
    echo
    info "attempt to download vim-plug"

    curl -fLo $path_to_plug --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    echo
    info "running PlugInstall"
    vim +PlugInstall +qall
fi

function install_anaconda {
    echo

    local archive="https://repo.anaconda.com/archive/"

    function latest_install_file {
        curl $archive | grep -o 'Anaconda3[0-9.-]*-Linux-x86_64.sh' | head -1
    }

    info "checking archieves for the latest version of Anaconda3"

    local install_file="$(latest_install_file)"

    echo
    info "attempt to download: $install_file"

    curl $archive$install_file -o "$install_file"
    bash "$install_file"
    rm "$install_file"
}

if passed "anaconda" || passed "conda"; then
    if [ -d "$HOME/anaconda3" ]; then
        info "anaconda already installed"
    else
        install_anaconda
    fi
fi

