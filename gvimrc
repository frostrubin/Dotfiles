" set go-=T
:colorscheme desert
"set transp=10
set lines=30

" Window Size
set columns=120

"Line Numbering
set number

"Default <Tab> is 2
set sts=2

"Auto-Indent
set ai

" Wrap at Word
set lbr!

" Show tabs and trailing characters.
set listchars=tab:»·,trail:·
set list

" Delete trailing white space and Dos-returns and to expand tabs to spaces.
nnoremap S :set et<CR>:retab!<CR>:%s/[\r \t]\+$//<CR>

"Start in <insert>-mode
:start
