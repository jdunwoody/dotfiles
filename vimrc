syntax on
call pathogen#runtime_append_all_bundles()
set number
filetype plugin indent on
color molokai

let mapleader = ";"
set guifont=Monospace\ 10
set encoding=utf-8
set autoread " reload file whenever it changes on disk
set wrapmargin=5
set nowrap
set formatoptions=croqln
set formatoptions=croqln
set tabstop=2
set expandtab
set cursorline
set softtabstop=2
set shiftwidth=2
set ignorecase
set smartcase
set incsearch
set scrolloff=3
set sidescrolloff=5
set wildmode=longest,list
set nocompatible
set autoindent
set smartindent
set mouse=a
set modelines=0
" allow status-bar windows (0-height)
set wmh=0
" set iskeyword-=_ \" allow underscore to delimit words"
set backupdir=/tmp
set directory=/tmp
set noswapfile
set nobackup
set showcmd
set showmode
set cursorline
set ruler
set backspace=indent,eol,start
set laststatus=2
"set relativenumber
"set undofile


"
"
set tags+=.tags
let g:autotagTagsFile=".tags"

"draw tabs & trailing spaces
autocmd BufNewFile,BufRead * set list listchars=tab:▸\
set list listchars=tab:\|_,trail:.

autocmd BufNewFile,BufRead * match Error /\(  \+\t\@=\)\|\(^\(\t\+\)\zs \ze[^ *]\)\|\([^ \t]\zs\s\+$\)/
                             match Error /\(  \+\t\@=\)\|\(^\(\t\+\)\zs \ze[^ *]\)\|\([^ \t]\zs\s\+$\)/

" open NERDTree in every tab
"autocmd VimEnter * NERDTree
" autocmd BufEnter * NERDTreeMirror
autocmd VimEnter * wincmd p

" Tab completion
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,tmp/*,coverage/*,public/*,spec/javascripts/generated/*,db/bootstrap/*,vendor/gems/:

" Command-T configuration
let g:CommandTMaxFiles=20000

"nnoremap <up> <nop>
"nnoremap <down> <nop>
"nnoremap <left> <nop>
"nnoremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" save file on lose of focus
au FocusLost * :wa
au FocusLost * :call <SID>StripTrailingWhitespaces()


:tabnext

nmap Y y$

"" tab left & right
" same for macvim (cmd key, because alt doesn't work)
""NOTE: only run this on macvim - on gnome, it causes an ambiguous map for "<<" (unindent line)
map <D-j> gt
map <D-k> gT

"let Tlist_WinWidth = 50 map <F4> :TlistToggle<cr>

" leader-e for showing nerd-tree
map <leader>e :NERDTreeToggle<cr>
map <leader>r :NERDTreeFind<cr>


" ctrl+f to FuzzyFinder (recursive)
"nmap <C-F> :FuzzyFinderBuffer<cr>
nmap <leader>b :FuzzyFinderBuffer<cr>
nmap <leader>f :FuzzyFinderFileWithFullCwd<cr>
nmap <leader>F :FuzzyFinderTaggedFile<cr>
nmap <leader>g :FuzzyFinderTag<cr>

nmap <leader>cp :CopyPath<cr>

" save file on lose of focus
autocmd FocusLost * :wa

" remove trailing whitespace
autocmd FocusLost,BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

nmap <leader>t :CommandT<cr>
" Ack
nnoremap <leader>a :Ack
"nnoremap <leader>a :Ack %:p:h

" HTML ft mapped to a “fold tag” function:
nnoremap <leader>ft Vatzf

" Re-hardwrap paragraphs of text:
nnoremap <leader>q gqip

" Reselect text just pasted
nnoremap <leader>v V`]

" open up my ~/.vimrc file in a vertically
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

"If I really want a horizontal split I can use <C-w>s to get one
nnoremap <leader>w <C-w>v<C-w>l
" split windoesa
" This next set of mappings maps <C-[h/j/k/l]> to the commands needed to move around your splits. If you remap your capslock key to Ctrl it makes for very easy navigation.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Nerd Commenter - toggle comment
"nnoremap <leader>c<space>

" Ruby stuff
" help ft-ruby-syntax
let ruby_space_errors =1
" let ruby_fold=1

" find usages
nmap <a-F7> :Ack -w <c-r><c-w><cr>

" show tags for current file
" nnoremap <leader>Q :TlistToggle<CR>
" let Tlist_Exit_OnlyWindow = 1     " exit if taglist is last window open
" let Tlist_Show_One_File = 1       " Only show tags for current buffer
" let Tlist_Enable_Fold_Column = 0  " no fold column (only showing one file)

" Bubble lines
nmap <C-Up> [e
nmap <C-Down> ]e

inoremap jj <Esc>
nnoremap JJJJ <Nop>

function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
  endfunction

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction

command! PrettyXML call DoPrettyXML()
