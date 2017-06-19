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

  " Fly between buffers " Relaced by unite
  " nnoremap <Leader>l :ls<CR>:b<space>

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

  " delete without yanking
  nnoremap <leader>d "_d
  vnoremap <leader>d "_d

  " replace currently selected text with default register
  " without yanking it
  vnoremap <leader>p "_dP

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

command! CloseHiddenBuffers call s:CloseHiddenBuffers()
function! s:CloseHiddenBuffers()
  let open_buffers = []

  for i in range(tabpagenr('$'))
    call extend(open_buffers, tabpagebuflist(i + 1))
  endfor

  for num in range(1, bufnr("$") + 1)
    if buflisted(num) && index(open_buffers, num) == -1
      exec "bdelete ".num
    endif
  endfor
endfunction
