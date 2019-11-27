" plugins
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'

Plug '/usr/bin/fzf'

call plug#end()

function! Edit(filepath)
    execute "e ".fnameescape(a:filepath)
endfunction

function! CD(path)
    execute 'cd' fnameescape(a:path)
endfunction

function! FuzzyFind()
    let selected = ""
    let is_dir = 1

    while is_dir
        let selected = fzf#run({'source': 'echo ".." && ls -A --color=always', 'options': '--reverse --ansi'})

        if len(selected) == 0
            return
        end

        let selected = selected[0]

        let is_dir = isdirectory(selected)

        if !is_dir
            call Edit(selected)
        else
            call CD(selected)
        end
    endwhile

endfunction

" syntax enable                 " enabled by default
" filetype plugin indent on     " by vim-plug

" case insensitive search
set ignorecase

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
set wildignorecase

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

highlight VertSplit cterm=NONE
set fillchars=vert:│

" open split panes to right and bottom
set splitbelow
set splitright

nnoremap + :vertical resize +10<CR>:resize +5<CR>
nnoremap - :vertical resize -10<CR>:resize -5<CR>

" autoremove all trailing whitespace when saving
autocmd BufWritePre * %s/\s\+$//e

nnoremap <SPACE> <Nop>

" commenting blocks of code
let s:comment_map = {
    \   "c": '\/\/',
    \   "cpp": '\/\/',
    \   "go": '\/\/',
    \   "java": '\/\/',
    \   "javascript": '\/\/',
    \   "lua": '--',
    \   "scala": '\/\/',
    \   "php": '\/\/',
    \   "rust": '\/\/',
    \   "mail": '>',
    \   "eml": '>',
    \   "bat": 'REM',
    \   "ahk": ';',
    \   "vim": '"',
    \   "tex": '%',
    \ }

function! ToggleComment()
    let comment_leader = '#' " defualt leader
    if has_key(s:comment_map, &filetype)
        let comment_leader = s:comment_map[&filetype]
    end
    if getline('.') =~ "^\\s*" . comment_leader . " "
        " Uncomment the line
        execute "silent s/^\\(\\s*\\)" . comment_leader . " /\\1/"
    else
        if getline('.') =~ "^\\s*" . comment_leader
            " Uncomment the line
            execute "silent s/^\\(\\s*\\)" . comment_leader . "/\\1/"
        else
            " Comment the line
            execute "silent s/^\\(\\s*\\)/\\1" . comment_leader . " /"
        end
    end
endfunction

nnoremap gcc :call ToggleComment()<cr>
vnoremap gc :call ToggleComment()<cr>

" leader bindings
let mapleader = " "
nnoremap <leader>fs :up<CR>
nnoremap <leader>ff :up<CR>:call FuzzyFind()<CR>
nnoremap <leader>bb :up<CR>:find *
nnoremap <leader>pp :up<CR>:find *
nnoremap <leader>pt :up<CR>:tabfind *
nnoremap <leader>ph :up<CR>:split *
nnoremap <leader>pv :up<CR>:vsplit *
nnoremap <leader>, :up<CR>:bp<CR>
nnoremap <leader>. :up<CR>:bn<CR>
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
nnoremap <leader>W :up<CR>:hide<CR>
nnoremap <leader>w :up<CR><C-w>
nnoremap <silent><Leader>] <C-w><C-]><C-w>T
nnoremap <leader>r :so ~/.vimrc<CR>
nnoremap <leader><Tab> <C-^>


