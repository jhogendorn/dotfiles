" WINDOW NAVIGATION {{{
" =================
"

"map <tab> <c-w>
"map <tab><tab> <c-w><c-w>

set winminwidth=0
set winminheight=0

"nmap <c-w><c-h> <c-w>h500<c-w>>
"nmap <c-w><c-l> <c-w>l500<c-w>>
"nmap <c-w><c-j> <c-w>j<c-w>_
"nmap <c-w><c-k> <c-w>k<c-w>_
"
  nnoremap <Leader>q <C-W>q

  nnoremap <Leader>k <C-W>k
  nnoremap <Leader>j <C-W>j
  nnoremap <Leader>h <C-W>h
  nnoremap <Leader>l <C-W>l

" Closes the current buffer
" Manage Tabs
  nnoremap <Leader>mtr :tabp<CR>
  nnoremap <Leader>mtl :tabn<CR>
  nnoremap <Leader>it :tabnew<CR>
" Change Sizes
"   Vertical Size
  nnoremap <Leader>mwl <C-W>+
  nnoremap <Leader>mwh <C-W>-
"  Horizontal Size
  nnoremap <Leader>mwk <C-W><
  nnoremap <Leader>mwj <C-W>>
"  Zoom Toggle
  nnoremap <Leader>mwm <C-W>=
  nnoremap <Leader>mwn <C-W>_<C-W><Bar>
"}}}

" WINDOW CREATION {{{
" ==============
"
" Vertical total span
"   Left
  nnoremap <Leader>iwH   :topleft  vnew<CR>
"  Right
  nnoremap <Leader>iwL   :botright  vnew<CR>
" Horizontal total span
"   Left
  nnoremap <Leader>iwK   :topleft  new<CR>
"  Right
  nnoremap <Leader>iwJ   :botright new<CR>
"
" Horizontal Split
"   Left
  nnoremap <Leader>iwh :leftabove  vnew<CR>
"  Right
  nnoremap <Leader>iwl :rightbelow vnew<CR>
" Horizontal Split
"   Left
  nnoremap <Leader>iwk :leftabove  new<CR>
"  Right
  nnoremap <Leader>iwj :rightbelow new<CR>
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

