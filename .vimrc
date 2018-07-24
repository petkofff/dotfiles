syntax on

filetype plugin indent on
autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
set tabstop=4
set shiftwidth=4
set expandtab

set ruler

set listchars=eol:\ ,tab:\|-,trail:·,extends:>,precedes:<
set list

noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

set number relativenumber
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

set path=$PWD/**
set wildmenu

inoremap <Nul> <C-n>

