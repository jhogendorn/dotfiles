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

