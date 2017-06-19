" GENERAL SETTINGS {{{
" ================
set encoding=utf-8

set nobackup                        " Backups hinder more than help.
set writebackup
if has('nvim')
  set viminfo+=n~/.nvim/tmp/viminfo
  set viminfo+=n~/.nvim/tmp/viminfo
  set backupdir=~/.nvim/tmp/back//,./.nvim/back//,/var/tmp/nvim/back//,/tmp/nvim/back//
  set backupskip=/tmp/*,/private/tmp/*

  set directory=~/.nvim/tmp/swap//,./.nvim/swap//,/var/tmp/nvim/swap//,/tmp/nvim/swap//

  set viewdir=~/.nvim/tmp/view/

  set undofile
  set undodir=~/.nvim/tmp/undo//,./.nvim/undo//,/var/tmp/nvim/undo//,/tmp/nvim/undo//
else
  set viminfo+=n~/.vim/tmp/viminfo
  set backupdir=~/.vim/tmp/back//,./.vim/back//,/var/tmp/vim/back//,/tmp/vim/back//
  set backupskip=/tmp/*,/private/tmp/*

  set directory=~/.vim/tmp/swap//,./.vim/swap//,/var/tmp/vim/swap//,/tmp/vim/swap//

  set viewdir=~/.vim/tmp/view/

  if v:version >= 703
    set undofile
    set undodir=~/.vim/tmp/undo//,./.vim/undo//,/var/tmp/vim/undo//,/tmp/vim/undo//
  endif
endif


syntax on                          " Syntax highlighting on

set ruler                          " Shows the line/col info
set hidden                         " When you close a window the buffer hides rather than closing
set hlsearch                       " Highlight all search pattern matches
set number                         " Show line numbers
set autoindent                     " Turn on autoindenting
" set smartindent                  " Turn on smartindenting (apparently)
set history=1000                   " Long undo history
set showmode                       " Show the current mode for dummies like me
set incsearch                      " Start searching as soon as you start typing
set ignorecase                     " ignore case when using a search pattern
set smartcase                      " override 'ignorecase' when pattern has upper case character
set backspace=indent,eol,start     " Makes backspace a bit more intelligent
set scrolloff=20                   " Keep context when moving to search results
set clipboard=unnamed              " Use the system clipboard by default
set pastetoggle=<F12>              " Use F12 to paste in insertmode from system clipboard
set ttyfast                        " Using vim locally normally, so fast tty
set cursorline                     " Highlight the current line
set list                           " Show whitespace chars
set listchars=trail:⋅,tab:»»       " Defines how to show whitespace chars
set winminheight=0                 " Allows windows to be collapsed
set winminwidth=0                  " Ditto
set tabstop=2                      " How many columns a tab is worth.
set shiftwidth=2                   " How many columns using reindent, >> etc.
set expandtab                      " Expand tabs into spaces
set tildeop                        " Change tilde to be an operator so you can use movement commands
if g:detected_mode == 'gui' && g:detected_os == 'Darwin'
  set macmeta
endif
set foldcolumn=2                   " Turn on the fold gutter
" set noswapfile                   " Disable the swap file
set lazyredraw                     " Lazyredraw for vim refresh speed
set shortmess=filnxtToOI           " Do not show welcome message

if v:version >= 703
  set numberwidth=6                " Always have a numberwidth supporting 9999 so changing between nu/rnu doesnt shift viewport
endif

set ttimeoutlen=50

set mouse=a                        " Turn on mouse support for scrolling
if !has('nvim')
  set ttymouse=sgr                 " Fix the mouse in wide windows in iTerm2 http://www.reddit.com/r/vim/comments/282gr6/i_didnt_know_you_could_do_this_with_the_mouse/ci6yiep
endif

"let mapleader = ','                " Set the map leader to comma
let mapleader = "\<Space>"         " Use space as the leader

set exrc                           " enable per-directory .vimrc files
set secure                         " disable unsafe commands in local .vimrc files

"Ignore these files when completing names
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

"Use the system ruby, not whatever rvm is set to
let g:ruby_path = system('rvm current')

"}}}
