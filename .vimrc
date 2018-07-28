" syntax enable                 " enabled by default
" filetype plugin indent on     " by vim-plug

" indentation
autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
set tabstop=4
set shiftwidth=4
set expandtab

set ruler

" whitespace settings
set listchars=eol:\ ,tab:\|-,trail:·,extends:>,precedes:<
set list

" <C-BS> for word deletion
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

" toggle between line number modes automatically
set number relativenumber
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

set path=$PWD/**
set wildmenu

" <C-Space> for autocomplete
inoremap <Nul> <C-n>

" bracket completion
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}
inoremap        (  ()<Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"

set timeoutlen=1000 ttimeoutlen=0

set t_Co=16

" highlight 81st char on every line
highlight ColorColumn ctermbg=4
call matchadd('ColorColumn', '\%81v', 100)

nnoremap <SPACE> <Nop>

" leader bindings
let mapleader = " "
nnoremap <leader>p :up<CR>:tabfind 
nnoremap <leader>, :up<CR>:tabprevious<CR>
nnoremap <leader>. :up<CR>:tabnext<CR>
nnoremap <leader>1 :up<CR>1gt
nnoremap <leader>2 :up<CR>2gt
nnoremap <leader>3 :up<CR>3gt
nnoremap <leader>4 :up<CR>4gt
nnoremap <leader>5 :up<CR>5gt
nnoremap <leader>6 :up<CR>6gt
nnoremap <leader>7 :up<CR>7gt
nnoremap <leader>8 :up<CR>8gt
nnoremap <leader>9 :up<CR>9gt
nnoremap <leader><F4> :wa<CR>:qall<CR>
nnoremap <leader>w :up<CR>:tabclose<CR>
nnoremap <silent><Leader>] <C-w><C-]><C-w>T

" plugins
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'

call plug#end()

