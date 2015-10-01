runtime! debian.vim

if has("syntax")
  syntax on
endif

if has("autocmd")
  filetype plugin indent on
endif

set mouse=a
set background=dark

set ignorecase
set tabstop=4
set shiftwidth=4
set expandtab
" To change the existing tab chars to match the current settings, use :retab
set showcmd
set showmatch
set smartcase
"set incsearch
set textwidth=80
set cm=blowfish2

au BufRead,BufNewFile *.sieve set filetype=sieve

"map j :%!python -m json.tool
"map g :%s/to_be_replaced/replaced/
