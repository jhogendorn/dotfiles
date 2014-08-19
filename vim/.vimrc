" DETECTION {{{
" =========
if has("win32") || has("win16")
	let os = 'Win'
else
	let os = substitute(system('uname'), "\n", "", "")
endif

if !has("gui_running")
	let type = 'term'
else
	let type = 'gui'
endif
"}}}

" NEOBUNDLE {{{
" ========
  " INIT {{{
  if has('vim_starting')
    set nocompatible               " Be iMproved

    " Required:
    set runtimepath+=~/.vim/neobundle/
  endif

  " Required:
  call neobundle#begin(expand('~/.vim/bundle/'))

  " Let NeoBundle manage NeoBundle
  " Required:
  NeoBundleFetch 'Shougo/neobundle.vim'

  " }}}

  " MY BUNDLES {{{
    " Vimproc {{{
    NeoBundle 'Shougo/vimproc.vim', {
    \  'lazy' : 0,
    \  'build' : {
    \    'windows' : 'tools\\update-dll-mingw',
    \    'cygwin' : 'make -f make_cygwin.mak',
    \    'mac' : 'make -f make_mac.mak',
    \    'unix' : 'make -f make_unix.mak',
    \  },
    \}
    " }}}

    " Unite {{{
    NeoBundle 'Shougo/unite.vim', {
    \  'lazy' : 0,
    \}
    let bundle = neobundle#get('unite.vim')
    function! bundle.hooks.on_post_source(bundle)
      " Search Recent Files
      nnoremap <silent> <Leader>m :Unite -buffer-name=recent -winheight=10 file_mru<cr>
      " Search open buffers
      nnoremap <Leader>b :Unite -buffer-name=buffers -winheight=10 buffer<cr>
      " Search in contents of files
      nnoremap <Leader>f :Unite grep:.<cr>

      " CtrlP search
      call unite#filters#matcher_default#use(['matcher_fuzzy'])
      call unite#filters#sorter_default#use(['sorter_rank'])
      call unite#custom#source('file_rec/async','sorters','sorter_rank')
      call unite#custom#profile('buffer', 'ignorecase', 1)
      " replacing unite with ctrl-p
      nnoremap <silent> <C-p> :Unite -start-insert -buffer-name=files -winheight=10 file_rec/async<cr>

      " General Settings
      let g:unite_source_history_yank_enable = 1
      let g:unite_data_directory='~/.vim/tmp/unite'
      let g:unite_source_rec_max_cache_files=5000
      let g:unite_enable_start_insert = 1
      let g:unite_split_rule = "botright"
      let g:unite_force_overwrite_statusline = 0
      let g:unite_winheight = 10

      " Ignore things
      call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
            \ 'ignore_pattern', join([
            \ '\.git/',
            \ '\app/cache',
            \ '\vendor/',
            \ '\.vagrant/',
            \ '\.ebextensions/'
            \ ], '\|'))

      " Shortcut behaviours whilst in unite mode
      autocmd FileType unite call s:unite_settings()

      function! s:unite_settings()
        "imap <buffer> <C-j> <NOP>
        imap <buffer> <C-j>   <Plug>(unite_select_next_line)
        imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
        imap <silent><buffer><expr> <C-x> unite#do_action('split')
        imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
        imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

        nmap <buffer> <ESC> <Plug>(unite_exit)
      endfunction
    endfunction
    " }}}

    " NERDTree {{{
    NeoBundle "scrooloose/nerdtree", {
    \  'lazy' : 1,
    \  'autoload' : {
    \    'commands' : [ 'NERDTree','NERDTreeFromBookmark','NERDTreeToggle','NERDTreeMirror','NERDTreeClose','NERDTreeFind','NERDTreeCWD' ],
    \    'mappings' : [ '<F2>', '<S-F2>', '<Leader>sit' ]
    \  }
    \}
    let bundle = neobundle#get('nerdtree')
    function! bundle.hooks.on_post_source(bundle)
      map <F2> :NERDTreeFocus<CR>
      map <S-F2> :NERDTreeClose<CR>
      map <Leader>sit :NERDTreeFind<CR>
      let NERDTreeShowHidden=1

            " Ignore vcs files, project files and resource forks.
      let NERDTreeIgnore=[  '\.git$',
                                \ '\.svn$',
                                \ '\.project$',
                                \ '\.settings$',
                                \ '\.buildpath$',
                                \ '\._.+$',
                                \ '\.git_externals$',
                                \ '\.gitignore',
                                \ '\.gitkeep',
                                \'\.DS_Store' ]

      let NERDTreeMinimalUI=1
      let NERDTreeShowBookmarks=1
      let NERDTreeShowLineNumbers=1
    endfunction
    " }}}

    " Ack {{{
    NeoBundle "mileszs/ack.vim", {
    \  'lazy' : 1,
    \  'autoload' : {
    \    'commands' : ['Ack']
    \  }
    \}
    " }}}

    " Ag {{{
    NeoBundle "rking/ag.vim", {
    \  'lazy' : 0
    \}
    " }}}

    " Fugitive {{{
    NeoBundle "tpope/vim-fugitive", {
    \  'lazy' : 0
    \}
    let bundle = neobundle#get('vim-fugitive')
    function! bundle.hooks.on_post_source(bundle)
      autocmd QuickFixCmdPost *log* cwindow
      autocmd QuickFixCmdPost *grep* cwindow
    endfunction
    " }}}

    " Gundo {{{
    NeoBundle "sjl/gundo.vim", {
    \  'lazy' : 1,
    \  'autoload' : {
    \    'commands' : ['GundoShow'],
    \    'mappings' : [ '<F4>' ]
    \  }
    \}
    let bundle = neobundle#get('gundo.vim')
    function! bundle.hooks.on_post_source(bundle)
			map <F4> :GundoToggle<CR>
			let g:gundo_right = 1
			let g:gundo_preview_bottom = 1
    endfunction
    " }}}

	" IndentGuides {{{
    NeoBundle "nathanaelkane/vim-indent-guides", {
    \  'lazy' : 1,
    \  'autoload' : {
    \    'commands' : ['IndentGuidesToggle','IndentGuidesEnable','IndentGuidesDisable'],
    \    'mappings' : [ '<Leader>ig' ]
    \  }
    \}
    let bundle = neobundle#get('vim-indent-guides')
    function! bundle.hooks.on_post_source(bundle)
			let g:indent_guides_auto_colors = 0
			let g:indent_guides_start_level = 2
			autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  guibg=#1c1c1c   ctermbg=234
			autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=#262626 ctermbg=235
    endfunction
	"}}}

    " NERDCommenter {{{
    NeoBundle "scrooloose/nerdcommenter", {
    \  'lazy' : 0,
    \  'autoload' : {
    \    'commands' : [ 'NERDComComment','NERDComNestedComment','NERDComToggleComment','NERDComMinimalComment','NERDComInvertComment','NERDComSexyComment','NERDComYankComment','NERDComEOLComment','NERDComAppendComment','NERDComInsertComment','NERDComAltDelim','NERDComAlignedComment','NERDComUncommentLine' ]
    \  }
    \}
    " }}}

    " Numbers {{{
    NeoBundle "myusuf3/numbers.vim", {
    \  'lazy' : 0
    \}
    " }}}

    " Repeat {{{
    NeoBundle "tpope/vim-repeat", {
    \  'lazy' : 0
    \}
    " }}}

    " Surround {{{
    NeoBundle "tpope/vim-surround", {
    \  'lazy' : 0
    \}
    " }}}

    " YankStack {{{
    NeoBundle "maxbrunsfeld/vim-yankstack", {
    \  'lazy' : 0
    \}
    let bundle = neobundle#get('vim-yankstack')
    function! bundle.hooks.on_post_source(bundle)
			nmap <Leader>p <Plug>yankstack_substitute_older_paste
            call yankstack#setup() " so it doesn't clobber vim-surround
    endfunction
    "}}}

    " YouCompleteMe {{{
    NeoBundle "Valloric/YouCompleteMe", {
    \  'lazy' : 0,
    \}
    " }}}

    " Syntastic {{{
    NeoBundle "scrooloose/syntastic", {
    \  'lazy' : 0
    \}
    let bundle = neobundle#get('syntastic')
    function! bundle.hooks.on_post_source(bundle)
			let g:syntastic_enable_signs=1
      let g:syntastic_quiet_messages = {'level': 'warnings'}
			let g:syntastic_mode_map = { 'mode': 'active',
									   \ 'active_filetypes': [],
									   \ 'passive_filetypes': ['twig'] }
    endfunction
    "}}}

    " Sparkup {{{
    NeoBundle "rstacruz/sparkup", {
    \  'lazy' : 0
    \}
    " }}}

    " Airline {{{
    NeoBundle "bling/vim-airline", {
    \  'lazy' : 0
    \}
    " }}}

    " Matchit {{{
    NeoBundle "vim-scripts/matchit.zip", {
    \  'lazy' : 0
    \}
    " }}}

    " Tabular {{{
    NeoBundle "godlygeek/tabular", {
    \  'lazy' : 0
    \}
    " }}}

    " Taboo {{{
    NeoBundle "gcmt/taboo.vim", {
    \  'lazy' : 0
    \}
    " }}}

    " Slime {{{
    NeoBundle "jpalardy/vim-slime", {
    \  'lazy' : 0
    \}
    let bundle = neobundle#get('vim-slime')
    function! bundle.hooks.on_post_source(bundle)
			let g:syntastic_enable_signs=1
      let g:syntastic_quiet_messages = {'level': 'warnings'}
			let g:syntastic_mode_map = { 'mode': 'active',
									   \ 'active_filetypes': [],
									   \ 'passive_filetypes': ['twig'] }
    endfunction
    "}}}

    " delimitMate {{{
    NeoBundle "Raimondi/delimitMate", {
    \  'lazy' : 0
    \}
    " }}}

    " Matchmaker {{{
    NeoBundle "qstrahl/vim-matchmaker", {
    \  'lazy' : 0
    \}
    " }}}

    " Over {{{
    NeoBundle "osyo-manga/vim-over", {
    \  'lazy' : 1,
    \  'autoload' : {
    \    'commands' : [ 'OverCommandLine' ]
    \  }
    \}
    " }}}

    " Lang: Coffee-Script {{{
    NeoBundle "kchmck/vim-coffee-script", {
    \  'lazy' : 1,
    \  'autoload' : {
    \    'filetypes' : [ 'css', 'scss' ]
    \  }
    \}
    " }}}

    " Lang: Markdown {{{
    NeoBundle "plasticboy/vim-markdown", {
    \  'lazy' : 1,
    \  'autoload' : {
    \    'filetypes' : [ 'markdown' ]
    \  }
    \}
    " }}}

    " Lang: Stylus {{{
    NeoBundle "wavded/vim-stylus", {
    \  'lazy' : 1,
    \  'autoload' : {
    \    'filetypes' : [ 'stylus' ]
    \  }
    \}
    " }}}

    " Lang: Jinja {{{
    NeoBundle "lepture/vim-jinja", {
    \  'lazy' : 1,
    \  'autoload' : {
    \    'filetypes' : [ 'jinja2' ]
    \  }
    \}
    " }}}

    " Lang: Yaml {{{
    NeoBundle "avakhov/vim-yaml", {
    \  'lazy' : 1,
    \  'autoload' : {
    \    'filetypes' : [ 'yaml' ]
    \  }
    \}

    NeoBundle "stephpy/vim-yaml", {
    \  'lazy' : 1,
    \  'autoload' : {
    \    'filetypes' : [ 'yaml' ]
    \  }
    \}
    " }}}

    " Lang: PHP {{{
    NeoBundle "rayburgemeestre/phpfolding.vim", {
    \  'lazy' : 0,
    \}
    let bundle = neobundle#get('phpfolding.vim')
    function! bundle.hooks.on_post_source(bundle)
      map <F5> <Esc>:EnableFastPHPFolds<Cr>
      map <F6> <Esc>:EnablePHPFolds<Cr>
      map <F7> <Esc>:DisablePHPFolds<Cr>
    endfunction
    " }}}

  " }}}

  call neobundle#end()

  " If there are uninstalled bundles found on startup,
  " this will conveniently prompt you to install them.
  NeoBundleCheck
"}}}

" INITIAL IMPORTANT SETTINGS {{{
" ==========================
set nocompatible				" Turn off vi compatibility
filetype plugin indent on		" Turn on the filetype stuff
colorscheme molokai				" Set the colour scheme
"}}}

" GUI SETTINGS {{{
" ============
if type == 'gui'
	if os == 'Win'
		set guifont=Lucida_Console:h9:cANSI
	endif
	set guioptions+=lrbmTLce
	set guioptions-=lrbmTLce
	set guioptions+=c
endif
"}}}

" GENERAL SETTINGS {{{
" ================
set encoding=utf-8

" Save shift key wear-out :P
nnoremap ; :

set backup
set writebackup
set viminfo+=n~/.vim/tmp/viminfo

set backupdir=~/.vim/tmp/back//,./.vim/back//,/var/tmp/vim/back//,/tmp/vim/back//
set backupskip=/tmp/*,/private/tmp/*

set directory=~/.vim/tmp/swap//,./.vim/swap//,/var/tmp/vim/swap//,/tmp/vim/swap//

set viewdir=~/.vim/tmp/view/

if v:version >= 703
	set undofile
	set undodir=~/.vim/tmp/undo//,./.vim/undo//,/var/tmp/vim/undo//,/tmp/vim/undo//
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
set listchars=trail:⋅,tab:\ \      " Defines how to show whitespace chars
set winminheight=0                 " Allows windows to be collapsed
set winminwidth=0                  " Ditto
set tabstop=2                      " How many columns a tab is worth.
set shiftwidth=2                   " How many columns using reindent, >> etc.
set expandtab                      " Expand tabs into spaces
set tildeop                        " Change tilde to be an operator so you can use movement commands
if type == 'gui' && os == 'Darwin'
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
set ttymouse=sgr                   " Fix the mouse in wide windows in iTerm2 http://www.reddit.com/r/vim/comments/282gr6/i_didnt_know_you_could_do_this_with_the_mouse/ci6yiep

let mapleader = ','                " Set the map leader to comma

set exrc                           " enable per-directory .vimrc files
set secure                         " disable unsafe commands in local .vimrc files

"Ignore these files when completing names
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

"Use the system ruby, not whatever rvm is set to
let g:ruby_path = system('rvm current')

"}}}

" STATUSLINE BUILD {{{
" ================
"

set laststatus=2				" Always show the file status line

    " AIRLINE {{{
        let g:airline#extensions#tabline#enabled = 1
        let g:airline_powerline_fonts = 1
        let g:airline_theme = 'powerlineish'

        if !exists('g:airline_symbols')
          let g:airline_symbols = {}
        endif

        let g:airline_left_sep = ''
        let g:airline_left_alt_sep = ''
        let g:airline_right_sep = ''
        let g:airline_right_alt_sep = ''
        let g:airline_symbols.branch = ''
        let g:airline_symbols.readonly = ''
        let g:airline_symbols.linenr = ''
    " }}}

" }}}

" FILE SPECIFIC SETTINGS {{{
" ======================
"
" PHP
	autocmd FileType php set cc=80,120
	autocmd FileType php set keywordprg=pman
	" autocmd BufEnter *.php :%s/\s\+$//e		" Remove trailing whitespace when opening files.

" Git Commits
	autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
	autocmd FileType gitcommit set cc=50,74

" Vimrc
	autocmd FileType vim set foldmethod=marker

" HTML
    autocmd FileType html setlocal indentkeys-=*<Return>
"}}}

" GENERAL COMMAND MAPPINGS {{{
" ========================
	map <Leader>cw mt:%s/    /\t/gc<CR>`t:delm t<CR>:noh<CR>:let @/ = ""<CR>			" Command for converting whitespace
	map <Leader>tw	mt:%s@\s\+$@@g<CR>`t:delm t<CR>:noh<CR>:let @/ = ""<CR>	    " Trim whitespace
	map <Leader>f-> mt:%s/\s\+->\s\+/->/g<CR>vt:delm t<CR>:noh<CR>:let @/ = ""<CR>   " Fix my extra spaced arrows
	map <Leader>rvrc :source $MYVIMRC<CR>		" Quick command for reloading vimrc

	map <Leader>fx :silent 1,$!xmllint --format --recover - 2>/dev/null<CR>

	" Change working dir to current
	nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

	nnoremap <Space> :noh<CR>

	" Fly between buffers
	nnoremap <Leader>l :ls<CR>:b<space>

  " Make Y work like everything else
	map Y y$
"}}}

" FOLD SETTINGS {{{
" =============
	" Preserve folds over file open/close
	"au BufWritePost,BufLeave,WinLeave ?* mkview
	"au BufWinEnter ?* silent loadview
	let g:skipview_files = [
				\ '.git/COMMIT_EDITMSG'
				\ ]
	function! MakeViewCheck()
		if has('quickfix') && &buftype =~ 'nofile'
			" Buffer is marked as not a file
			return 0
		endif
		if empty(glob(expand('%:p')))
			" File does not exist on disk
			return 0
		endif
		if len($TEMP) && expand('%:p:h') == $TEMP
			" We're in a temp dir
			return 0
		endif
		if len($TMP) && expand('%:p:h') == $TMP
			" Also in temp dir
			return 0
		endif
		if index(g:skipview_files, expand('%')) >= 0
			" File is in skip list
			return 0
		endif
		return 1
	endfunction
	augroup vimrcAutoView
		autocmd!
		" Autosave & Load Views.
		autocmd BufWritePost,BufLeave,WinLeave ?* if MakeViewCheck() | mkview | endif
		autocmd BufWinEnter ?* if MakeViewCheck() | silent loadview | endif
	augroup end
"}}}

" OSX TERMINAL FIXES {{{
" ===================

	if type != 'gui' && os == 'Darwin'
	" KEYBOARD NUMPAD FIX {{{
	" ===================
		"set <k1>=Oq
		"set <k2>=Or
		"set <k3>=Os
		"set <k4>=Ot
		"set <k5>=Ou
		"set <k6>=Ov
		"set <k7>=Ow
		"set <k8>=Ox
		"set <k9>=Oy
		"set <k0>=Op
	"}}}

	" FUNCTION KEY FIX {{{
	" ===================
		set <F1>=OP
		set <S-F1>=[1;2P
		set <F2>=OQ
		set <S-F2>=[1;2Q
		set <F3>=OR
		set <S-F3>=[1;2R
		set <F4>=OS
		set <S-F4>=[1;2S
		set <F5>=[15~
		set <F6>=[17~
		set <F7>=[18~
		set <F8>=[19~
		set <F9>=[20~
		set <F10>=[21~
		" <F11> Expose
		" <F12> Dashboard
	"}}}
	endif

"}}}

" WINDOW NAVIGATION {{{
" =================
"

map <tab> <c-w>
map <tab><tab> <c-w><c-w>

set winminwidth=0
set winminheight=0

nmap <c-w><c-h> <c-w>h500<c-w>>
nmap <c-w><c-l> <c-w>l500<c-w>>
nmap <c-w><c-j> <c-w>j<c-w>_
nmap <c-w><c-k> <c-w>k<c-w>_

" Navigate splits
	nmap <Leader>cwk <C-W>k
	nmap <Leader>cwj <C-W>j
	nmap <Leader>cwh <C-W>h
	nmap <Leader>cwl <C-W>l
" Close a window
	nnoremap <Leader>qw <C-w>c
" Closes the current buffer
	nnoremap <Leader>qb :Bclose<CR>
" Manage Tabs
	nnoremap <Leader>mtr :tabp<CR>
	nnoremap <Leader>mtl :tabn<CR>
	nnoremap <Leader>it :tabnew<CR>
" Change Sizes
" 	Vertical Size
	nmap <Leader>mwl <C-W>+
	nmap <Leader>mwh <C-W>-
"	Horizontal Size
	nmap <Leader>mwk <C-W><
	nmap <Leader>mwj <C-W>>
"	Zoom Toggle
	nmap <Leader>mwm <C-W>=
	nmap <Leader>mwn <C-W>_<C-W><Bar>
"}}}

" WINDOW CREATION {{{
" ==============
"
" Vertical total span
" 	Left
	nmap <Leader>iwH   :topleft  vnew<CR>
"	Right
	nmap <Leader>iwL   :botright  vnew<CR>
" Horizontal total span
" 	Left
	nmap <Leader>iwK   :topleft  new<CR>
"	Right
	nmap <Leader>iwJ   :botright new<CR>
"
" Horizontal Split
" 	Left
	nmap <Leader>iwh :leftabove  vnew<CR>
"	Right
	nmap <Leader>iwl :rightbelow vnew<CR>
" Horizontal Split
" 	Left
	nmap <Leader>iwk :leftabove  new<CR>
"	Right
	nmap <Leader>iwj :rightbelow new<CR>
"}}}

" DISABLE ARROW KEYS {{{
" ==================
"
" Normal Mode
	noremap   <Up>     <NOP>
	noremap   <Down>   <NOP>
	noremap   <Left>   <NOP>
	noremap   <Right>  <NOP>
"}}}
