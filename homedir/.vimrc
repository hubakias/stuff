"runtime! debian.vim

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
set hlsearch          " highlight search pattern
set autowrite         " Automatically save before commands like :next and :make
set hidden            " Hide buffers when they are abandoned"

set cindent

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

"Highlight more than 80 chars
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

set encoding=utf-8

"set number " show line numbers

" Show trailing whitespace:
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

