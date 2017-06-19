" DETECTION {{{
" =========
if has("win32") || has("win16")
  let g:detected_os = 'Win'
else
  let g:detected_os = substitute(system('uname'), "\n", "", "")
endif

if !has("gui_running")
  let g:detected_mode = 'term'
else
  let g:detected_mode = 'gui'
endif
"}}}

