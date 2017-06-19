" PLUGINS {{{
" ========
  call plug#begin('~/.vim/plugged')

  " Unite
  " {{{
  Plug 'Shougo/vimproc.vim', {
  \ 'do': 'make -f make_mac.mak'
  \ }
  "    'windows' : 'tools\\update-dll-mingw',
  "    'cygwin' : 'make -f make_cygwin.mak',
  "    'mac' : 'make -f make_mac.mak',
  "    'unix' : 'make -f make_unix.mak',

  "Plug 'Shougo/unite.vim', {}

  "Plug 'Shougo/neomru.vim', {}
  "Plug 'Shougo/neoyank.vim', {}
  "Plug 'tsukkee/unite-tag', {}

  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

    let $FZF_DEFAULT_COMMAND = 'ag -l -g ""'
    nnoremap <Leader>o :Files<cr>

  " }}}


  " AutoComplete
  " {{{
  "Plug 'Valloric/YouCompleteMe', {
  "\ 'do': './install.py --all'
  "\ }
    "let g:ycm_complete_in_comments_and_strings=1
    "let g:ycm_autoclose_preview_window_after_completion=1
    "let g:ycm_autoclose_preview_window_after_insertion=1
    "let g:ycm_collect_identifiers_from_tags_files = 1
    "let g:ycm_collect_identifiers_from_tags_files=1
    ""let g:ycm_key_list_select_completion=['<TAB>', '<C-n>', '<Down>']
    ""let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']
    "let g:ycm_filetype_blacklist={'unite': 1}
    "let g:ycm_semantic_triggers = {}
    "let g:ycm_semantic_triggers.php =
    "\ ['->', '::', '(', 'use ', 'namespace ', '\']

    "" http://stackoverflow.com/questions/2169645/vims-autocomplete-is-excruciatingly-slow
    "" Dont scan through included files
    "set complete-=i

  Plug 'ervandew/supertab'

    let g:SuperTabDefaultCompletionType = "context"
    let g:SuperTabContextDefaultCompletionType = "<c-n>"

  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
      let g:deoplete#enable_at_startup=1
      let g:deoplete#file#enable_buffer_path=0 " Relative path completions
      if !exists('g:deoplete#omni#input_patterns')
        let g:deoplete#omni#input_patterns = {}
      endif
      " let g:deoplete#disable_auto_complete = 1
      autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

      " omnifuncs
      augroup omnifuncs
        autocmd!
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
      augroup end
      " tern
      if exists('g:plugs["tern_for_vim"]')
        let g:tern_show_argument_hints = 'on_hold'
        let g:tern_show_signature_in_pum = 1
        autocmd FileType javascript setlocal omnifunc=tern#Complete
      endif

      let g:deoplete#omni#functions = {}
      let g:deoplete#omni#functions.javascript = [
        \ 'tern#Complete',
        \ 'jspc#omni'
      \]

      set completeopt=longest,menuone
      let g:deoplete#sources = {}
      let g:deoplete#sources['javascript.jsx'] = ['file', 'ultisnips', 'ternjs']

      autocmd FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
      "let g:UltiSnipsExpandTrigger="<CR>"
      "let g:UltiSnipsListSnippets="<C-tab>"
      inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

      " close the preview window when you're not using it
      let g:SuperTabClosePreviewOnPopupClose = 1

      " tern
      autocmd FileType javascript nnoremap <silent> <buffer> gb :TernDef<CR>

    Plug 'carlitux/deoplete-ternjs'
      " Use tern_for_vim.
      let g:tern#command = ["tern"]
      let g:tern#arguments = ["--persistent"]
  endif
  " }}}


  " File Navigation
  " {{{

  Plug 'scrooloose/nerdtree', {}

    nnoremap <F2> :NERDTreeFocus<CR>
    nnoremap <S-F2> :NERDTreeClose<CR>
    nnoremap <Leader>sit :NERDTreeFind<CR>

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

  Plug 'tpope/vim-vinegar', {}

  Plug 'mileszs/ack.vim', {}
    if executable('ag')
      let g:ackprg = "ag --nogroup --column --smart-case --follow"
    endif
    " Dont auto open the first match
    " cnoreabbrev Ack Ack!
    " nnoremap <Leader>a :Ack!<Space>
    " Shorthand for literal searches
    command! -nargs=1 Find Ack -Q "<args>"

  " }}}


  " Refactoring
  " {{{
  Plug 'PeterRincker/vim-argumentative', {}

  Plug 'godlygeek/tabular', {}
    nmap <Leader>a,   :Tabularize /,<CR>
    vmap <Leader>a,   :Tabularize /,<CR>
    nmap <Leader>a=   :Tabularize /=<CR>
    vmap <Leader>a=   :Tabularize /=<CR>
    nmap <Leader>a=>  :Tabularize /=><CR>
    vmap <Leader>a=>  :Tabularize /=><CR>
    " Don't typically use these.
    "nmap <Leader>a& :Tabularize /&<CR>
    "vmap <Leader>a& :Tabularize /&<CR>
    "nmap <Leader>a- :Tabularize /-<CR>
    "vmap <Leader>a- :Tabularize /-<CR>
    "nmap <Leader>a: :Tabularize /:<CR>
    "vmap <Leader>a: :Tabularize /:<CR>
    "nmap <Leader>a:: :Tabularize /:\zs<CR>
    "vmap <Leader>a:: :Tabularize /:\zs<CR>
    "nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    "vmap <Leader>a<Bar> :Tabularize /<Bar><CR>

  " }}}


  " Documentation
  " {{{
  Plug 'rizzatti/dash.vim', {}
    map K :Dash<CR>

  " }}}


  " Look & Feel
  " {{{
  Plug 'vim-airline/vim-airline', {}
  Plug 'vim-airline/vim-airline-themes', {}
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


  " Features
  " {{{
  Plug 'SirVer/ultisnips', {}
  Plug 'honza/vim-snippets', {}

  " }}}


  " Tools
  " {{{

  Plug 'tpope/vim-fugitive'
    autocmd QuickFixCmdPost *log* cwindow
    autocmd QuickFixCmdPost *grep* cwindow

  Plug 'sjl/gundo.vim', { 'on': [ 'GundoToggle' ] }
    map <F4> :GundoToggle<CR>
    let g:gundo_right = 1
    let g:gundo_preview_bottom = 1

  Plug 'scrooloose/nerdcommenter', {}

  Plug 'mhinz/vim-signify', {}
    let g:signify_vcs_list = [ 'git' ]

  Plug 'myusuf3/numbers.vim', {}
  Plug 'tpope/vim-repeat', {}
  Plug 'tpope/vim-surround', {}

  Plug 'maxbrunsfeld/vim-yankstack', {}
    nmap <Leader>p <Plug>yankstack_substitute_older_paste
    nmap <Leader>P <Plug>yankstack_substitute_newer_paste

  Plug 'ludovicchabant/vim-gutentags', {}
  Plug 'majutsushi/tagbar', {}
    nmap <F5> :TagbarToggle<CR>

  Plug 'neomake/neomake', {}

    "let g:neomake_verbose=3
    "let g:neomake_logfile='/tmp/neomake.log'
    "let g:neomake_open_list=2
    autocmd! BufWritePost,BufEnter * Neomake

    " Override eslint with local version where necessary.
    "let local_eslint = finddir('node_modules', '.;') . '/.bin/eslint'
    "if matchstr(local_eslint, "^\/\\w") == ''
      "let local_eslint = getcwd() . "/" . local_eslint
    "endif
    "if executable(local_eslint)
      "let eslint_exec = local_eslint
    "else
      "let eslint_exec = 'eslint'
    "endif

    "let g:neomake_javascript_eslint_maker = {
      "\ 'exe': eslint_exec,
    "\}
    "
      "\ 'args': [],
      "\ 'errorformat': ''
    
    let g:neomake_javascript_enabled_makers = ['eslint']
    let g:neomake_jsx_enabled_makers = ['eslint']

    "let g:neomake_php_php_args = ['-l', '%']
    "let g:neomake_php_php_append_file = 0
    let g:neomake_php_php_exe = '/usr/local/bin/php'

  Plug 'joonty/vdebug', {}
    let g:vdebug_keymap = {
    \    "run" : "<F6>",
    \    "run_to_cursor" : "<Left>",
    \    "step_over" : "<Right>",
    \    "step_into" : "<Down>",
    \    "step_out" : "<Up>",
    \    "close" : "q",
    \    "detach" : "x",
    \    "set_breakpoint" : "<Leader>bp",
    \    "eval_visual" : "<Leader>e"
    \}

  " }}}


  " Languages
  " {{{

  Plug 'kchmck/vim-coffee-script', {}

  Plug 'tpope/vim-markdown', {}
    au BufNewFile,BufReadPost *.md set filetype=markdown
    let g:markdown_fenced_languages = ['coffee', 'css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml', 'html', 'shell=sh']

  Plug 'sirtaj/vim-openscad', {}

  Plug 'wavded/vim-stylus', {}

  Plug 'lepture/vim-jinja', {}

  Plug 'evidens/vim-twig', {}

  Plug 'stephpy/vim-yaml', {}
  Plug 'chase/vim-ansible-yaml', {}

  Plug 'pangloss/vim-javascript', {}
  Plug 'mxw/vim-jsx', {}
    let g:jsx_ext_required = 0 " Allow JSX in normal JS files

  Plug 'elzr/vim-json', {}
    au! BufRead,BufNewFile *.json set filetype=json
    augroup json_autocmd
      autocmd!
      autocmd FileType json set autoindent
      autocmd FileType json set formatoptions=tcq2l
      autocmd FileType json set foldmethod=syntax
    augroup END

  Plug 'ternjs/tern_for_vim', {
    \ 'do': 'npm install'
  \ }

  Plug 'shawncplus/phpcomplete.vim', {}
  Plug 'rayburgemeestre/phpfolding.vim', {}
      map <Leader>ffa <Esc>:EnableFastPHPFolds<Cr>
      map <Leader>fa <Esc>:EnablePHPFolds<Cr>
      map <Leader>fn <Esc>:DisablePHPFolds<Cr>

  " }}}



  call plug#end()
"}}}

runtime config/plugins_config.vim
"runtime config/plugins_unite.vim
