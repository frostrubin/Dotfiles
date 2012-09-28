" Most Tips are from Luke:
" http://www.terminally-incoherent.com/blog/2012/03/26/how-to-configure-vim/
" This setup contains - amongst other things
"   the L9 Library           http://www.vim.org/scripts/script.php?script_id=3252
"   the AutoComplPop Plugin  http://www.vim.org/scripts/script.php?script_id=1879
"

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
 

set expandtab       "Use softtabstop spaces instead of tab characters for indentation
set shiftwidth=2    "Indent by 4 spaces when using >>, <<, == etc.
set softtabstop=2   "Indent by 4 spaces when pressing <TAB>
set copyindent      " copy previous indent on enter 
set autoindent      "Keep indentation from previous line
set smartindent     "Automatically inserts indentation in some cases
set cindent         "Like smartindent, but stricter and more customisable


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

" use ii to quickly re-ident the whole file
inoremap ii <ESC>gg=G


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
