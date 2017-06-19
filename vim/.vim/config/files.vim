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


