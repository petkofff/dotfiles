HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch
unsetopt beep notify
bindkey -v

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

alias mntwin="sudo mount -o ro /dev/sda4 /media/win"

# Exports
export PATH="${PATH}:${HOME}/.local/bin/"

# <C-BACKSPACE> to delete a word
bindkey '^H' backward-kill-word

# <C-r> 
bindkey "^R" history-incremental-pattern-search-backward

source ~/.aliases-and-functions
