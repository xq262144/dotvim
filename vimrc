""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim configuration skeleton
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source $HOME/.vim/vimrc_skeleton.vim


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Runtime Environment
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disabled plugins
let g:pathogen_disabled=[]

" Activate pathogen
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set how many lines of history Vim has to remember
set history=1000

" With a map leader it's possible to do extra key combinations
let g:mapleader=","

" Fast editing of the .vimrc
map <Leader>e :e! $HOME/.vim/vimrc<CR>

" When vimrc is edited, reload it
autocmd! BufWritePost vimrc source $HOME/.vim/vimrc


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim user interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn on wild menu
set wildmenu

" Set completion mode as Zsh's style
" 1st TAB: complete longest common string
" 2nd TAB: start wild menu if it is enabled
" 3rd and later TABs: complete the next full match in wild menu
set wildmode=longest:full,full

" Always show current position
set ruler

" The commandbar height
set cmdheight=2

" Change buffer - without saving
set hidden

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search things
set hlsearch

" Make search act like search in modern browsers
set incsearch

" Set magic on, for regular expressions
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2

" Show line number
set number

" Enable the use of the mouse
" The xterm handling of the mouse buttons can still be used by keeping
" the shift key pressed.
set mouse=a

" Highlight the screen line of the cursor
set cursorline

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

" Don't redraw while executing macros (good performance config)
set lazyredraw

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set timeoutlen=500


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 256 Colors Theme
if $TERM =~ '-256color$'
  colorscheme wombat256mod
else
  colorscheme default
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off
set nobackup

" Persistent undo
set undodir=$HOME/.vim/tmp/undo
set undofile

" Swap file
set directory=$HOME/.vim/tmp/swap

" netrw
let g:netrw_home=$HOME.'/.vim/tmp/netrw'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Auto indent
set autoindent

" Smart indent
set smartindent


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann

function! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

function! VisualSelection(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>
vnoremap <silent> <Leader>r :call VisualSelection('replace')<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Quickfix
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Leader>cc :botright copen<CR>
map <Leader>n :cnext<CR>
map <Leader>p :cprevious<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Encoding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,gbk,euc-jp,euc-kr,big5,gb18030,latin1

function! s:CheckGBLocale(locale_var)
  let locale_var=toupper(a:locale_var)
  if (match(locale_var, '.GBK$') != -1 || match(locale_var, '.GB18030$') != -1 || match(locale_var, '.GB2312$') != -1)
    return 1
  else
    return 0
  endif
endfunction

if (s:CheckGBLocale($LC_ALL) || s:CheckGBLocale($LC_CTYPE) || s:CheckGBLocale($LANG))
  set termencoding=gb18030
else
  set termencoding=
endif

" Set terminal encoding to GB18030
map <Leader>tg :set termencoding=gb18030<CR>

" Set terminal encoding to UTF-8, same as encoding option
map <Leader>tu :set termencoding=<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Always show status line
set laststatus=2

" Use compatible symbols
let g:Powerline_symbols="compatible"

" Override the dividers by ASCII chars
let g:Powerline_dividers_override=['', '|', '', '|']

" Insert the charcode segment before the fileformt segment
call Pl#Theme#InsertSegment('charcode', 'before', 'fileformat')


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Delete trailing whitespace
function! DeleteTrailingWS()
  if (&bin > 0)
    return
  endif

  let save_cursor = getpos(".")
  %substitute/\s\+$//ge
  nohlsearch
  call setpos(".", save_cursor)
endfunc
map <F12> :call DeleteTrailingWS()<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Switch between buffers
map <C-H> :bp<CR>
map <C-L> :bn<CR>

" Treat long lines as break lines (useful when moving around in them)
nnoremap <silent> k gk
nnoremap <silent> j gj


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""
" autofmt
""""""""""""""""""""""""""""""""""""
" Use uax14
set formatexpr=autofmt#uax14#formatexpr()

" Customize Line Break Property
let s:unicode = unicode#import()
let s:orig_prop_line_break = s:unicode.prop_line_break
function! s:unicode.prop_line_break(char)
  if a:char == "\u201c" || a:char == "\u2018"
    return "OP"   " Open Punctuation
  elseif a:char == "\u201d" || a:char == "\u2019"
    return "CL"   " Close Punctuation
  endif
  return call(s:orig_prop_line_break, [a:char], self)
endfunction


""""""""""""""""""""""""""""""""""""
" AutoTag
""""""""""""""""""""""""""""""""""""
let g:autotagCtagsCmd="ctags --sort=yes --c++-kinds=+lpx --fields=+aiKSz --extra=+q"


""""""""""""""""""""""""""""""""""""
" CtrlP
""""""""""""""""""""""""""""""""""""
let g:ctrlp_by_filename=1
let g:ctrlp_clear_cache_on_exit=0
let g:ctrlp_cache_dir=$HOME.'/.vim/tmp/ctrlp'
let g:ctrlp_mruf_relative=1
let g:ctrlp_user_command={
  \ 'types': {
    \ 1: ['.git/', 'cd %s && git ls-files'],
    \ 2: ['.hg/', 'hg --cwd %s locate -I .'],
    \ },
  \ 'fallback': 'find %s -type f',
  \ }


""""""""""""""""""""""""""""""""""""
" Gundo
""""""""""""""""""""""""""""""""""""
let g:gundo_preview_bottom=1
let g:gundo_close_on_revert=1
nnoremap <Leader>gt :GundoToggle<CR>


""""""""""""""""""""""""""""""""""""
" Mini Buffer Explorer
""""""""""""""""""""""""""""""""""""
let g:miniBufExplModSelTarget=1
let g:miniBufExplMapWindowNavArrows=1


""""""""""""""""""""""""""""""""""""
" neocomplcache
""""""""""""""""""""""""""""""""""""
let g:neocomplcache_enable_at_startup=1
let g:neocomplcache_enable_camel_case_completion=1
let g:neocomplcache_enable_underbar_completion=1
let g:neocomplcache_enable_smart_case=1

" default # of completions is 100, that's crazy
let g:neocomplcache_max_list=10

" words less than 3 letters long aren't worth completing
let g:neocomplcache_auto_completion_start_length=3


""""""""""""""""""""""""""""""""""""
" Syntastic
""""""""""""""""""""""""""""""""""""
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': ['c', 'cpp', ] }


""""""""""""""""""""""""""""""""""""
" Tagbar
""""""""""""""""""""""""""""""""""""
let g:tagbar_iconchars = ['+', '-']
nnoremap <silent> <Leader>tt :TagbarToggle<CR>


""""""""""""""""""""""""""""""""""""
" YankRing
""""""""""""""""""""""""""""""""""""
let g:yankring_history_dir=$HOME.'/.vim/tmp/yankring'
let g:yankring_replace_n_pkey='<C-K>'
let g:yankring_replace_n_nkey='<C-J>'


" vim: set expandtab tabstop=2 shiftwidth=2:
