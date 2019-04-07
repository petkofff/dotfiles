HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch
unsetopt beep notify
bindkey -v

# case-insensitive file completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle :compinstall filename ~/.zshrc
autoload -Uz compinit
compinit

# load wal colorscheme if such exists
function load-color-scheme() {
    local pathToColorScheme=~/.cache/wal/sequences
    if [ -f $pathToColorScheme ]; then
        (cat $pathToColorScheme &)
    fi
}
load-color-scheme

autoload -U colors && colors

function precmd() {
    RPROMPT=""
}

function zle-line-init() zle-keymap-select() {
    local VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    local RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

export KEYTIMEOUT=1

PROMPT="%{$fg_bold[green]%}[%m@%M%{$reset_color%} %1~%{$fg_bold[green]%}]$%{$reset_color%} "

alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -h'
alias vp='vim PKGBUILD'
alias more=less

# exports
export PATH="${PATH}:${HOME}/.local/bin/"
export VISUAL=vim
export EDITOR="$VISUAL"

# <C-BACKSPACE> to delete a word
bindkey '^H' backward-kill-word

# <C-r>
bindkey "^R" history-incremental-pattern-search-backward

setopt noflowcontrol

# full path of the selected file or folder appears after
# the cursor and gets copied to the clipboard
function fzf-select() {
    local selected
    local curr_path="$(pwd)"
    local selected_is_a_folder=true

    while [ "$selected_is_a_folder" = true ]; do
        local lsd=$(echo ".." && ls -A --color=always)
        selected="$(printf '%s\n' "${lsd[@]}" |
            fzf --reverse --ansi --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                ls -A --color=always "${__cd_path}";
        ')"

        if [[ ${#selected} = 0 ]] || [[ ! -d "$selected" ]]; then
            selected_is_a_folder=false
        else
            builtin cd "$selected" &> /dev/null
        fi
    done

    local full_path="$(cd "$(dirname "$selected")"; pwd)/$(basename "$selected")"

    LBUFFER="${LBUFFER}${full_path} "

    builtin cd "$curr_path" &> /dev/null

    if hash xclip 2>/dev/null; then
        echo "$full_path" | xclip -sel clip
    fi

    zle redisplay
}
zle -N fzf-select
bindkey '^s' fzf-select

function useconda {
    local __setup_str="'${HOME}/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null"
    local __conda_setup=$(eval "$__setup_str")
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "${HOME}/anaconda3/etc/profile.d/conda.sh" ]; then
            . "${HOME}/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="${HOME}/anaconda3/bin:$PATH"
        fi
    fi
}

source ~/.aliases-and-functions

