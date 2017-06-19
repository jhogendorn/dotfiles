" GUI SETTINGS {{{
" ============
if g:detected_mode == 'gui'
  if g:detected_os == 'Win'
    set guifont=Lucida_Console:h9:cANSI
  endif
  set guioptions+=lrbmTLce
  set guioptions-=lrbmTLce
  set guioptions+=c
endif
"}}}


