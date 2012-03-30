" Most Tips are from Luke:
" http://www.terminally-incoherent.com/blog/2012/03/26/how-to-configure-vim/
" break compatibility with vi
set nocompatible

" buffers can exist in background
set hidden

"enable inline spellcheck
set spell
set spelllang=en

" enable line numbers
set nu
 
" show line and column markers
set cursorline
set cursorcolumn

" enable soft word wrap
set formatoptions=l
set lbr

" move by screen lines, not by real lines - great for creative writing
nnoremap j gj
nnoremap k gk
 
" also in visual mode
vnoremap j gj
vnoremap k gk

syntax on
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
 
set autoindent
" copy previous indent on enter 
set copyindent
set smartindent

" toggle paste mode (to paste properly indented text)
" you can hit F2 to temporarily suspend auto-indenting
" and paste a block of code properly. 
" Then hit F2 again to toggle it back to the default settings.
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode


set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
 
set incsearch		" incremental search
set hlsearch		" highlights searches

" pressing \<space> clears the search highlights
nmap <silent> <leader><space> :nohlsearch<CR>

" prevent .backup files 
set noswapfile
set nobackup
set nowb

" use jj to quickly escape to normal mode while typing 
inoremap jj <ESC>

" Start Pathogen
call pathogen#infect()

" Set default color scheme
set guioptions-=T
set t_Co=256
:colorscheme railscat

" Set relative Line numbers in normal mode
" And absolute numbers in insert mode
" Useful for a quick 5j to jump 5 lines...
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
