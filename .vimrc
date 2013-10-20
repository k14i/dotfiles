" .vimrc
" http://www.vim.org/docs.php


"#######################################
"# System Settings
"#######################################

set notitle
set number

" Unicode =============================
"let &termencoding=&encoding
"set termencoding=utf-8
"set encoding=utf-8
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,euc-jp,iso-2022-jp,ucs-2le,ucs-2,cp932
"set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp-2,euc-jisx0213,euc-jp,cp932

if &encoding == 'utf-8'
  set ambiwidth=double
endif
" =====================================

" Backup ==============================
set backup
"set backupdir=~/.vim/backup
set backupdir=~/.Trash
set swapfile
"set directory=~/.vim/swap
set directory=~/.Trash
set backupskip=/tmp/*,/private/tmp/*
" =====================================

" autodate.vim ========================
let g:autodate_format = '%Y-%m-%d'
let g:autodate_keyword_pre = 'Last Modified:'
let g:autodate_keyword_post = '$'

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

endif " has("autocmd")
" =====================================


"#######################################
"# Display Settings
"#######################################

if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

set shortmess+=I

set list
set listchars=tab:>.,trail:.,extends:>,precedes:<
set display=uhex

set laststatus=2
set cmdheight=2
set showcmd
set title

set scrolloff=2

set statusline=%<%f\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%4v\ %l/%L

" format.vim ==========================
let format_allow_over_tw = 0
" =====================================


"#######################################
"# Search Settings
"#######################################

set incsearch
set ignorecase
set smartcase


"#######################################
"# Normal Mode Settings
"#######################################

nnoremap j gj
nnoremap k gk


"#######################################
"# Input Mode Settings
"#######################################

set autoindent
set backspace=indent,eol,start
set showmatch
set wildmenu
set formatoptions+=mM

" tab =================================
set tabstop=4
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab
inoremap <C-Tab> <C-V><Tab>
" =====================================

inoremap <Leader>date <C-R>=strftime('%A, %B %d, %Y')<CR>
inoremap <Leader>time <C-R>=strftime('%H:%M')<CR>
inoremap <Leader>rdate <C-R>=strftime('%A, %B %d, %Y %H:%M')<CR>
inoremap <Leader>w3cdtf <C-R>=strftime('%Y-%m-%dT%H:%M:%S+09:00')<CR>

" putline =============================
let putline_tw = 60

inoremap <Leader>line <ESC>:call <SID>PutLine(putline_tw)<CR>A
function! s:PutLine(len)
  let plen = a:len - strlen(getline('.'))
  if (plen > 0)
    execute 'normal ' plen . 'A-'
  endif
endfunction
" =====================================


"#######################################
"# Visual Mode Settings
"#######################################

" Parentheses, Brackets, Braces =======
vnoremap * "zy:let @/ = @z<CR>n
" =====================================


"#######################################
"# Command Line Mode Settings
"#######################################


"#######################################
"# Plugins
"#######################################

" GNU Global ==========================
let GtagsCscope_Auto_Load = 1
let GtagsCscope_Auto_Map = 1
let GtagsCscope_Quiet = 1
set cscopetag
" =====================================

" Chalice (2ch.net browser) ===========
set runtimepath+=$HOME/.vim/chalice
nnoremap <F2> :call <SID>DoChalice()<CR>
let chalice_preview = 0
let chalice_columns = 120
let chalice_exbrowser = 'openurl %URL% &'
function! s:DoChalice()
  Chalice
endfunction
" =====================================
