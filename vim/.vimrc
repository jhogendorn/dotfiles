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
  let g:neobundle#install_process_timeout = 1500

  " }}}

  " MY BUNDLES {{{
    " Vimproc {{{
    NeoBundle 'Shougo/vimproc.vim', {
    \  'lazy' : 0,
    \  'disabled': 0,
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

      " CtrlP search
      call unite#filters#matcher_default#use(['matcher_fuzzy'])
      call unite#filters#sorter_default#use(['sorter_rank'])
      call unite#custom#source('file_rec/async','sorters','sorter_rank')
      call unite#custom#profile('buffer', 'context.ignorecase', 1)

      nmap <Space> [unite]
      nnoremap [unite] <nop>

      nnoremap <silent> [unite]p :<C-u>Unite -start-insert  -buffer-name=files        file_rec/async<cr>
      nnoremap <silent> [unite]e :<C-u>Unite                -buffer-name=recent       file_mru<cr>
      nnoremap <silent> [unite]y :<C-u>Unite                -buffer-name=yanks        history/yank<cr>
      nnoremap <silent> [unite]l :<C-u>Unite -auto-resize   -buffer-name=line         line<cr>
      nnoremap <silent> [unite]b :<C-u>Unite -auto-resize   -buffer-name=buffers      buffer<cr>
      nnoremap <silent> [unite]/ :<C-u>Unite -no-quit       -buffer-name=search       grep:.<cr>
      nnoremap <silent> [unite]m :<C-u>Unite -auto-resize   -buffer-name=mappings     mapping<cr>
      nnoremap <silent> [unite]s :<C-u>Unite -quick-match                             buffer<cr>

      if executable('ag')
        let g:unite_source_grep_command='ag'
        let g:unite_source_grep_default_opts='--nocolor --line-numbers --nogroup -S -C4'
        let g:unite_source_grep_recursive_opt=''
      elseif executable('ack')
        let g:unite_source_grep_command='ack'
        let g:unite_source_grep_default_opts='--no-heading --no-color -C4'
        let g:unite_source_grep_recursive_opt=''
      endif

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
            \     '\.git',
            \     'app/cache',
            \     'vendor',
            \     '\.vagrant',
            \     '\.ebextensions',
            \     '\.tmp'
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

    " Unite: tags {{{
    NeoBundle 'tsukkee/unite-tag', {
    \  'lazy' : 0,
    \  'autoload' : {
    \    'unite_sources' : ['tag','tag/file']
    \  }
    \}
    let bundle = neobundle#get('unite-tag')
    function! bundle.hooks.on_post_source(bundle)
      nnoremap <silent> [unite]t :<C-u>Unite -auto-resize -buffer-name=tag tag tag/file<cr>
    endfunction
    " }}}

    " FZF {{{
    NeoBundle "junegunn/fzf.vim", {
    \  'lazy' : 0,
    \  'autoload' : {
    \  },
    \}
    let bundle = neobundle#get('fzf.vim')
    function! bundle.hooks.on_post_source(bundle)
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
    let bundle = neobundle#get('ack.vim')
    function! bundle.hooks.on_post_source(bundle)
      if executable('ag')
        let g:ackprg = "ag --nogroup --column --smart-case --follow"
      endif

      nnoremap <silent> \a :set opfunc=<SID>AckMotion<CR>g@
      xnoremap <silent> \a :<C-U>call <SID>AckMotion(visualmode())<CR>

      function! s:CopyMotionForType(type)
          if a:type ==# 'v'
              silent execute "normal! `<" . a:type . "`>y"
          elseif a:type ==# 'char'
              silent execute "normal! `[v`]y"
          endif
      endfunction

      function! s:AckMotion(type) abort
          let reg_save = @@

          call s:CopyMotionForType(a:type)

          execute "normal! :Ack! --literal " . shellescape(@@) . "\<cr>"

          let @@ = reg_save
      endfunction
    endfunction
    " }}}

    " Ag {{{
    NeoBundle "rking/ag.vim", {
    \  'lazy' : 0,
    \  'disabled' : 1
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

    " GitGutter {{{
    NeoBundle "airblade/vim-gitgutter", {
    \  'lazy' : 0
    \}
    let bundle = neobundle#get('vim-gitgutter')
    function! bundle.hooks.on_post_source(bundle)
      let g:gitgutter_realtime = 1
      let g:gitgutter_eager = 1
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
    \    'mappings' : [ '<Space>ig' ]
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
    \  'lazy' : 0,
    \  'disabled' : 0
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
      nmap <Leader>pp <Plug>yankstack_substitute_older_paste
            call yankstack#setup() " so it doesn't clobber vim-surround
    endfunction
    "}}}

    " YouCompleteMe {{{
    NeoBundle "Valloric/YouCompleteMe", {
    \  'lazy' : 0,
     \ 'build'      : {
        \ 'mac'     : './install.sh --all',
        \ 'unix'    : './install.sh --all',
        \ 'windows' : './install.sh --all',
        \ 'cygwin'  : './install.sh --all'
        \ }
    \}
    let bundle = neobundle#get('YouCompleteMe')
    function! bundle.hooks.on_post_source(bundle)
      let g:ycm_complete_in_comments_and_strings=1
      let g:ycm_autoclose_preview_window_after_completion=1
      let g:ycm_autoclose_preview_window_after_insertion=1
      let g:ycm_collect_identifiers_from_tags_files = 1
      "let g:ycm_key_list_select_completion=['<TAB>', '<C-n>', '<Down>']
      "let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']
      let g:ycm_filetype_blacklist={'unite': 1}
      let g:ycm_semantic_triggers = {}
      let g:ycm_semantic_triggers.php =
      \ ['->', '::', '(', 'use ', 'namespace ', '\']
    endfunction
    " }}}

    " TernJS {{{
    NeoBundle "ternjs/tern_for_vim", {
    \  'lazy' : 0,
     \ 'build'      : {
        \ 'mac'     : 'npm install',
        \ 'unix'    : 'npm install',
        \ 'windows' : 'npm install',
        \ 'cygwin'  : 'npm install'
        \ }
    \}
    let bundle = neobundle#get('tern_for_vim')
    function! bundle.hooks.on_post_source(bundle)
    endfunction
    " }}}

    " UltiSnips {{{
    NeoBundle "SirVer/ultisnips", {
    \  'lazy' : 0
    \}
    NeoBundle "honza/vim-snippets", {
    \  'lazy' : 0
    \}

    let bundle = neobundle#get('ultisnips')
    function! bundle.hooks.on_post_source(bundle)
      let g:UltiSnipsEditSplit="vertical"

      "let g:UltiSnipsExpandTrigger       = "<c-tab>"
      let g:UltiSnipsExpandSnippetOrJump = "<enter>"
      let g:UltiSnipsJumpForwardTrigger  = "<c-j>"
      let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
      "let g:UltiSnipsJumpForwardTrigger  = "<tab>"
      "let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

      " Enable tabbing through list of results
      function! g:UltiSnips_Complete()
          call UltiSnips#ExpandSnippet()
          if g:ulti_expand_res == 0
              if pumvisible()
                  return "\<C-n>"
              else
                  call UltiSnips#JumpForwards()
                  if g:ulti_jump_forwards_res == 0
                     return "\<TAB>"
                  endif
              endif
          endif
          return ""
      endfunction

      au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"

      " Expand snippet or return
      let g:ulti_expand_res = 0
      function! Ulti_ExpandOrEnter()
          call UltiSnips#ExpandSnippet()
          if g:ulti_expand_res
              return ''
          else
              return "\<return>"
      endfunction

      " Set <space> as primary trigger
      inoremap <return> <C-R>=Ulti_ExpandOrEnter()<CR>
    endfunction
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
      let g:syntastic_javascript_checkers = ['eslint'] ", 'jshint']
      " let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute " ,"trimming empty <", "unescaped &" , "lacks \"action", "is not recognized!", "discarding unexpected"] " fix for angularjsisms

      " Override eslint with local version where necessary.
      let local_eslint = finddir('node_modules', '.;') . '/.bin/eslint'
      if matchstr(local_eslint, "^\/\\w") == ''
        let local_eslint = getcwd() . "/" . local_eslint
      endif
      if executable(local_eslint)
        let g:syntastic_javascript_eslint_exec = local_eslint
      endif
    endfunction
    "}}}

    " Sparkup {{{
    NeoBundle "rstacruz/sparkup", {
    \  'lazy' : 0
    \}
    " }}}

    " Airline {{{
    NeoBundle "vim-airline/vim-airline", {
    \  'lazy' : 0
    \}
    let bundle = neobundle#get('vim-airline')
    "function! bundle.hooks.on_post_source(bundle)
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
    "endfunction

    NeoBundle "vim-airline/vim-airline-themes", {
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
    let bundle = neobundle#get('tabular')
    function! bundle.hooks.on_post_source(bundle)
      nmap <Leader>a& :Tabularize /&<CR>
      vmap <Leader>a& :Tabularize /&<CR>
      nmap <Leader>a= :Tabularize /=<CR>
      vmap <Leader>a= :Tabularize /=<CR>
      nmap <Leader>a- :Tabularize /-<CR>
      vmap <Leader>a- :Tabularize /-<CR>
      nmap <Leader>a: :Tabularize /:<CR>
      vmap <Leader>a: :Tabularize /:<CR>
      nmap <Leader>a:: :Tabularize /:\zs<CR>
      vmap <Leader>a:: :Tabularize /:\zs<CR>
      nmap <Leader>a, :Tabularize /,<CR>
      vmap <Leader>a, :Tabularize /,<CR>
      nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
      vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    endfunction
    " }}}

    " Taboo {{{
    NeoBundle "gcmt/taboo.vim", {
    \  'lazy' : 0
    \}
    " }}}

    " Slime {{{
    NeoBundle "jpalardy/vim-slime", {
    \  'lazy' : 0,
    \  'disabled': 0
    \}
    let bundle = neobundle#get('vim-slime')
    function! bundle.hooks.on_post_source(bundle)
      let g:slime_target = "tmux"
      let g:slime_paste_file = tempname()
    endfunction
    "}}}

    " delimitMate {{{
    NeoBundle "Raimondi/delimitMate", {
    \  'lazy' : 0,
    \  'disabled' : 1
    \}
    " }}}

    " lexima {{{
    NeoBundle "cohama/lexima.vim", {
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

    " ShowMotion {{{
    NeoBundle "boucherm/ShowMotion", {
    \  'lazy' : 0,
    \  'disabled': 1,
    \  'autoload' : {
    \  }
    \}
    let bundle = neobundle#get('ShowMotion')
    function! bundle.hooks.on_post_source(bundle)
      "*** If your plugins are loaded after your colorscheme
      highlight SM_SmallMotionGroup cterm=italic                ctermbg=53 gui=italic                guibg=#5f005f
      highlight SM_BigMotionGroup   cterm=italic,bold,underline ctermbg=54 gui=italic,bold,underline guibg=#5f0087
      highlight SM_CharSearchGroup  cterm=italic,bold           ctermbg=4  gui=italic,bold           guibg=#3f6691

      "*** Highlights both big and small motions
      nmap <silent> w <Plug>(show-motion-both-w)
      nmap <silent> W <Plug>(show-motion-both-W)
      nmap <silent> b <Plug>(show-motion-both-b)
      nmap <silent> B <Plug>(show-motion-both-B)
      nmap <silent> e <Plug>(show-motion-both-e)
      nmap <silent> E <Plug>(show-motion-both-E)

      "*** Only highlights motions corresponding to the one you typed
      "nmap <silent> w <Plug>(show-motion-w)
      "nmap <silent> W <Plug>(show-motion-W)
      "nmap <silent> b <Plug>(show-motion-b)
      "nmap <silent> B <Plug>(show-motion-B)
      "nmap <silent> e <Plug>(show-motion-e)
      "nmap <silent> E <Plug>(show-motion-E)

      "Show motion for chars:
      nmap f <Plug>(show-motion-f)
      nmap t <Plug>(show-motion-t)
      nmap F <Plug>(show-motion-F)
      nmap T <Plug>(show-motion-T)
      nmap ; <Plug>(show-motion-;)
      nmap , <Plug>(show-motion-,)
    endfunction
    " }}}

    " Dash {{{
    NeoBundle "rizzatti/dash.vim", {
    \  'lazy' : 0,
    \  'autoload' : {
    \  }
    \}
    let bundle = neobundle#get('dash.vim')
    function! bundle.hooks.on_post_source(bundle)
      map K :Dash<CR>
    endfunction
    " }}}

    " PHP Completion {{{
    NeoBundle "shawncplus/phpcomplete.vim", {
    \  'lazy' : 0
    \}
    NeoBundle "m2mdas/phpcomplete-extended", {
    \  'lazy' : 0,
    \  'disabled' : 1,
    \}
      NeoBundle "m2mdas/phpcomplete-extended-symfony", {
      \  'lazy' : 0,
      \  'disabled' : 1,
      \}
    let bundle = neobundle#get('phpcomplete-extended')
    function! bundle.hooks.on_post_source(bundle)
      autocmd  FileType  php setlocal omnifunc=phpcomplete_extended#CompletePHP
    endfunction

    "NeoBundle "mkusher/padawan.vim", {
    "\  'lazy' : 0,
    "\  'disabled' : 0,
    "\}
    "let bundle = neobundle#get('padawan.vim')
    "function! bundle.hooks.on_post_source(bundle)
    "  let g:padawan#composer_command = "./bin/composer"
    "endfunction
    " }}}

    " PHPQA {{{
    NeoBundle "jhogendorn/vim-phpqa", {
    \  'lazy' : 0,
    \  'autoload' : {
    \    'commands' : [ 'Phpcc','Phpcs','Phpmd','Php' ],
    \    'mappings' : [ '<Leader>qc' ]
    \  }
    \}
    let bundle = neobundle#get('vim-phpqa')
    function! bundle.hooks.on_post_source(bundle)
      " Don't run messdetector on save (default = 1)
      let g:phpqa_messdetector_autorun = 0

      " Don't run codesniffer on save (default = 1)
      let g:phpqa_codesniffer_autorun = 0

      " Show code coverage on load (default = 0)
      let g:phpqa_codecoverage_autorun = 0

      " Stop the location list opening automatically
      let g:phpqa_open_loc = 0

      " Clover code coverage XML file
      " let g:phpqa_codecoverage_file = "/path/to/clover.xml"

      " Show markers for lines that ARE covered by tests (default = 1)
      let g:phpqa_codecoverage_showcovered = 1
    endfunction
    " }}}

    " VDebug {{{
    NeoBundle "joonty/vdebug", {
    \  'lazy' : 0,
    \  'autoload' : {
    \  }
    \}
    "let bundle = neobundle#get('vdebug')
    "function! bundle.hooks.on_post_source(bundle)
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
    "endfunction
    " }}}

    " QuickHL {{{
    NeoBundle "t9md/vim-quickhl", {
    \  'lazy' : 0,
    \}
    let bundle = neobundle#get('vim-quickhl')
    function! bundle.hooks.on_post_source(bundle)
      nmap <Leader>m <Plug>(quickhl-manual-this)
      xmap <Leader>m <Plug>(quickhl-manual-this)
      nmap <Leader>M <Plug>(quickhl-manual-reset)
      xmap <Leader>M <Plug>(quickhl-manual-reset)

      nmap <Leader>j <Plug>(quickhl-cword-toggle)
      nmap <Leader>] <Plug>(quickhl-tag-toggle)
      map H <Plug>(operator-quickhl-manual-this-motion)
    endfunction
    " }}}

    " LOTR {{{
    NeoBundle "dahu/vim-lotr", {
    \  'lazy' : 0,
    \  'disabled' : 0
    \}
    " }}}

    " Fetch {{{
    NeoBundle "kopischke/vim-fetch", {
    \  'lazy' : 0,
    \  'disabled' : 0
    \}
    " }}}

    " Diff Enhanced {{{
    NeoBundle "chrisbra/vim-diff-enhanced", {
    \  'lazy' : 0,
    \  'autoload' : {
    \  }
    \}
    " }}}

    " Vim Expand Region {{{
    NeoBundle "terryma/vim-expand-region", {
    \  'lazy' : 0,
    \  'autoload' : {
    \  }
    \}
    let bundle = neobundle#get('vim-expand-region')
    function! bundle.hooks.on_post_source(bundle)
        vmap v <Plug>(expand_region_expand)
        vmap <C-v> <Plug>(expand_region_shrink)
    endfunction
    " }}}

    " Argumentative {{{
    NeoBundle "PeterRincker/vim-argumentative", {
    \  'lazy' : 0,
    \  'autoload' : {
    \  }
    \}
    let bundle = neobundle#get('vim-argumentative')
    function! bundle.hooks.on_post_source(bundle)
    endfunction
    " }}}

    " Enmasse {{{
    NeoBundle "Olical/vim-enmasse", {
    \  'lazy' : 0,
    \  'autoload' : {
    \  }
    \}
    let bundle = neobundle#get('vim-enmasse')
    function! bundle.hooks.on_post_source(bundle)
    endfunction
    " }}}

    " Lang: Coffee-Script {{{
    NeoBundle "kchmck/vim-coffee-script", {
    \  'lazy' : 0,
    \  'autoload' : {
    \    'filetypes' : [ 'coffee' ]
    \  }
    \}
    " }}}

    " Lang: Markdown {{{
    NeoBundle "tpope/vim-markdown", {
    \  'lazy' : 0,
    \  'autoload' : {
    \    'filetypes' : [ 'markdown', 'md' ]
    \  }
    \}
    au BufNewFile,BufReadPost *.md set filetype=markdown
    let g:markdown_fenced_languages = ['coffee', 'css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml', 'html', 'shell=sh']
    " }}}

    " Lang: Stylus {{{
    NeoBundle "wavded/vim-stylus", {
    \  'lazy' : 0,
    \  'autoload' : {
    \    'filetypes' : [ 'stylus' ]
    \  }
    \}
    " }}}

    " Lang: Jinja {{{
    NeoBundle "lepture/vim-jinja", {
    \  'lazy' : 0,
    \  'autoload' : {
    \    'filetypes' : [ 'jinja2' ]
    \  }
    \}
    " }}}

    " Lang: Twig {{{
    NeoBundle "evidens/vim-twig", {
    \  'lazy' : 0,
    \  'autoload' : {
    \    'filetypes' : [ 'html', 'twig', 'html.twig' ]
    \  }
    \}
    " }}}

    " Lang: Yaml {{{
    "NeoBundle "avakhov/vim-yaml", {
    "\  'lazy' : 0,
    "\  'autoload' : {
    "\    'filetypes' : [ 'yaml' ]
    "\  }
    "\}

    NeoBundle "stephpy/vim-yaml", {
    \  'lazy' : 0,
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
      map <Leader>ffa <Esc>:EnableFastPHPFolds<Cr>
      map <Leader>fa <Esc>:EnablePHPFolds<Cr>
      map <Leader>fn <Esc>:DisablePHPFolds<Cr>
    endfunction
    " }}}

    " Lang: Ansible Yaml {{{
    NeoBundle "chase/vim-ansible-yaml", {
    \  'lazy' : 0,
    \}
    let bundle = neobundle#get('vim-ansible-yaml')
    function! bundle.hooks.on_post_source(bundle)
    endfunction
    " }}}

    " Lang: Javascript {{{
    NeoBundle "pangloss/vim-javascript", {
    \  'lazy' : 0,
    \}
    let bundle = neobundle#get('vim-javascript')
    function! bundle.hooks.on_post_source(bundle)
    endfunction
    " }}}

    " Lang: JSON {{{
    NeoBundle "elzr/vim-json", {
    \  'lazy' : 0,
    \}
    let bundle = neobundle#get('vim-json')
    function! bundle.hooks.on_post_source(bundle)
      au! BufRead,BufNewFile *.json set filetype=json
      augroup json_autocmd
        autocmd!
        autocmd FileType json set autoindent
        autocmd FileType json set formatoptions=tcq2l
        "autocmd FileType json set textwidth=78 shiftwidth=2
        "autocmd FileType json set softtabstop=2 tabstop=8
        "autocmd FileType json set expandtab
        autocmd FileType json set foldmethod=syntax
      augroup END
    endfunction
    " }}}

    " Lang: JSX {{{
    NeoBundle "mxw/vim-jsx", {
    \  'lazy' : 0,
    \}
    let bundle = neobundle#get('vim-jsx')
    function! bundle.hooks.on_post_source(bundle)
      let g:jsx_ext_required = 0 " Allow JSX in normal JS files
    endfunction
    " }}}

    " Lang: OpenSCAD {{{
    NeoBundle "sirtaj/vim-openscad", {
    \  'lazy' : 0,
    \}
    let bundle = neobundle#get('vim-openscad')
    function! bundle.hooks.on_post_source(bundle)
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
set nocompatible        " Turn off vi compatibility
filetype plugin indent on    " Turn on the filetype stuff
colorscheme molokai        " Set the colour scheme
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

set nobackup                        " Backups hinder more than help.
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
set listchars=trail:⋅,tab:»»       " Defines how to show whitespace chars
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

"let mapleader = ','                " Set the map leader to comma
let mapleader = "\<Space>"         " Use space as the leader

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

set laststatus=2        " Always show the file status line

" }}}

" FILE SPECIFIC SETTINGS {{{
" ======================
"
" PHP
  autocmd FileType php set cc=80,120
  autocmd FileType php set keywordprg=pman
  autocmd BufReadPre,FileReadPre php :EnableFastPHPFolds
  " autocmd BufEnter *.php :%s/\s\+$//e    " Remove trailing whitespace when opening files.

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
  map <Leader>cw mt:%s/    /\t/gc<CR>`t:delm t<CR>:noh<CR>:let @/ = ""<CR>      " Command for converting whitespace
  map <Leader>tw  mt:%s@\s\+$@@ge<CR>`t:delm t<CR>:noh<CR>:let @/ = ""<CR>      " Trim whitespace
  map <Leader>f-> mt:%s/\s\+->\s\+/->/g<CR>vt:delm t<CR>:noh<CR>:let @/ = ""<CR>   " Fix my extra spaced arrows
  map <Leader>rvrc :source $MYVIMRC<CR>    " Quick command for reloading vimrc

  map <Leader>fx :silent 1,$!xmllint --format --recover - 2>/dev/null<CR>

  " Change working dir to current
  nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

  " Hide highlights
  nnoremap <Leader><Leader> :noh<CR>

  " Fly between buffers
  nnoremap <Leader>l :ls<CR>:b<space>

  " Always use no magic
  nnoremap / /\V

  " Helper for search/replace repeatability
  vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
      \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
  omap s :normal vs<CR>

  " Make Y work like everything else
  map Y y$

  " Go to the end of pasted blocks so you can just smash p to multipaste
  vnoremap <silent> y y`]
  vnoremap <silent> p p`]
  nnoremap <silent> p p`]

  " Quickly reselect the last paste
  noremap gV `[v`]

  " Stop that q window popping up
  map q: :q

  " Mappings for tag navigation
  " Use [] for back/forward. Use the g behaviour by default
  "nnoremap <c-[> <c-t>
  "vnoremap <c-[> <c-t>
  nnoremap <c-]> g<c-]>
  vnoremap <c-]> g<c-]>
  nnoremap g<c-]> <c-]>
  vnoremap g<c-]> <c-]>
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
  " Disabled 200715 This just throws errors a lot of the time for me and I
  " reset the view anyway. lets see how annoying disabling it ends up being
  "augroup vimrcAutoView
  "  autocmd!
  "  " Autosave & Load Views.
  "  autocmd BufWritePost,BufLeave,WinLeave ?* if MakeViewCheck() | mkview | endif
  "  autocmd BufWinEnter ?* if MakeViewCheck() | silent loadview | endif
  "  if version >= 702
  "    " Clear matches when you leave a window, performance tweak
  "    autocmd BufWinLeave * call clearmatches()
  "  endif
  "augroup end
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
"   Vertical Size
  nmap <Leader>mwl <C-W>+
  nmap <Leader>mwh <C-W>-
"  Horizontal Size
  nmap <Leader>mwk <C-W><
  nmap <Leader>mwj <C-W>>
"  Zoom Toggle
  nmap <Leader>mwm <C-W>=
  nmap <Leader>mwn <C-W>_<C-W><Bar>
"}}}

" WINDOW CREATION {{{
" ==============
"
" Vertical total span
"   Left
  nmap <Leader>iwH   :topleft  vnew<CR>
"  Right
  nmap <Leader>iwL   :botright  vnew<CR>
" Horizontal total span
"   Left
  nmap <Leader>iwK   :topleft  new<CR>
"  Right
  nmap <Leader>iwJ   :botright new<CR>
"
" Horizontal Split
"   Left
  nmap <Leader>iwh :leftabove  vnew<CR>
"  Right
  nmap <Leader>iwl :rightbelow vnew<CR>
" Horizontal Split
"   Left
  nmap <Leader>iwk :leftabove  new<CR>
"  Right
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
