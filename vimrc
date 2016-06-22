" set colors
syntax enable filetype on
set background=dark

" feedback options
set number
set relativenumber
set ruler
set showcmd

" search options
set nohlsearch
map <silent> <C-N> :se invhlsearch<CR>
set ignorecase
set showmatch

" don't wrap text
set nowrap

" tabs to spaces
set tabstop=4
set shiftwidth=4
set expandtab

" autoindent & sane backspacing
" set noautoindent
" set smartindent
set backspace=indent,eol,start

" map ALT+p = highlight contents of bracketed region
nmap <M-p> m[%v%`[
imap <M-p> <Esc>m[%v%`[a

" map ctrl j and ctrl k to move between splits
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-L> <C-W>l<C-W>_
map <C-H> <C-W>h<C-W>_
map <F12> <C-W>+<C-W>
map <F11> <C-W>-<C-W>

" set minimum width of split to 0 lines
set wmh=0

" alias w!! to sudo when you forget
cmap w!! %!sudo tee > /dev/null %

" alias c with comment and u with uncomment in visual mode for all files
autocmd BufNewFile,Bufread * vmap u :s/^#//<CR>
autocmd BufNewFile,Bufread * vmap c :s/^/#/<CR>

" alias c with comment and u with uncomment in visual mode for c / java files
autocmd BufNewFile,BufRead *.h,*.c,*.cpp,*.java vmap u :-1/^\/\//s///<CR>
autocmd BufNewFile,BufRead *.h,*.c,*.cpp,*.java vmap c :-1/^/s//\/\//<CR>


" keep cursor from jumping when joining lines
noremap J mzJ`z

" keep a buffer between the cursor and edge of screen
set scrolloff=5

" move by virtual lines
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
