runtime! debian.vim

if has("syntax")
  syntax on
endif

if has("autocmd")
  filetype plugin indent on
endif

set showcmd           " Show (partial) command in status line.
set showmatch         " Show matching brackets.
set ignorecase        " Do case insensitive matching
set smartcase         " Do smart case matching
set incsearch         " Incremental search
set autowrite         " Automatically save before commands like :next and :make
set hidden            " Hide buffers when they are abandoned"

set background=dark
set mouse=a

set textwidth=80
set tabstop=4
set shiftwidth=4
set expandtab
" To change the existing tab chars to match the current settings, use :retab

set cm=blowfish2

au BufRead,BufNewFile *.sieve set filetype=sieve

"map j :%!python -m json.tool
"map g :%s/to_be_replaced/replaced/
