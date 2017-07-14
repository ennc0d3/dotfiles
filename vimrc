set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
   Plugin 'VundleVim/Vundle.vim'
   Plugin 'tpope/vim-fugitive'
   Plugin 'scrooloose/nerdtree'
   Plugin 'scrooloose/syntastic'
   Plugin 'bronson/vim-trailing-whitespace'
   "Plugin 'Valloric/YouCompleteMe'
   Plugin 'altercation/vim-colors-solarized'
call vundle#end()

filetype plugin indent on    " required

" Solarized Plugin{{{
   syntax enable
   set background=dark
   if &t_Co >=256 || has("gui_running")
	   colorscheme solarized
	endif
" }}}
"
" Common setings{{{
let mapleader=","
set nowrap        " don't wrap lines
set tabstop=3     " a tab is four spaces
set backspace=indent,eol,start
                  " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set number        " always show line numbers
set shiftwidth=3  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                    "    case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to
                    "    shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type

set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep

set nobackup
set noswapfile

set list
set listchars=tab:▸\ ,eol:¬
autocmd filetype html,xml set listchars-=tab:>.
" }}}
"
" Autocmd for aterating defaults {{{
autocmd filetype python set expandtab
" }}}
"
"
" Mapped Keys {{{
nmap <leader>l :set list!<CR>
nmap <silent> <leader>ev :e $MYVIMRC<CR>     "edit .vimrc
nmap <silent> <leader>sv :so $MYVIMRC<CR>    "source .vimrc
" }}}

