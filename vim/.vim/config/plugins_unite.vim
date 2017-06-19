
" CtrlP search
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#source('file_rec/async','sorters','sorter_rank')
call unite#custom#profile('buffer', 'context.ignorecase', 1)

nmap <Space> [unite]
nnoremap [unite] <nop>

"nnoremap <silent> [unite]o :<C-u>Unite -start-insert  -buffer-name=files        file_rec/async<cr>
nnoremap <silent> [unite]e :<C-u>Unite                -buffer-name=recent       file_mru<cr>
nnoremap <silent> [unite]p :<C-u>Unite                -buffer-name=yanks        history/yank<cr>
"nnoremap <silent> [unite]l :<C-u>Unite -auto-resize   -buffer-name=line         line<cr>
nnoremap <silent> [unite]b :<C-u>Unite -auto-resize   -buffer-name=buffers      buffer<cr>
nnoremap <silent> [unite]/ :<C-u>Unite -no-quit       -buffer-name=search       grep:.<cr>
"nnoremap <silent> [unite]m :<C-u>Unite -auto-resize   -buffer-name=mappings     mapping<cr>
"nnoremap <silent> [unite]s :<C-u>Unite -quick-match                             buffer<cr>
nnoremap <silent> [unite]t :<C-u>Unite -auto-resize   -buffer-name=tag          tag tag/file<cr>

if executable('ag')
  let g:unite_source_grep_command='ag'
  let g:unite_source_grep_default_opts =
    \ '-i --vimgrep --hidden --ignore ' .
    \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt=''
elseif executable('ack')
  let g:unite_source_grep_command='ack'
  let g:unite_source_grep_default_opts =
    \ '-i --no-heading --no-color -k -H'
  let g:unite_source_grep_recursive_opt=''
endif

" General Settings
let g:unite_source_history_yank_enable = 1
let g:unite_data_directory='~/.vim/tmp/unite'
"let g:unite_source_rec_max_cache_files=5000
let g:unite_enable_start_insert = 1
let g:unite_split_rule = "botright"
let g:unite_force_overwrite_statusline = 0
let g:unite_winheight = 30

let g:unite_source_buffer_time_format = "%Y-%m-%d  %H:%M:%S  "
let g:unite_source_file_mru_time_format = "%Y-%m-%d  %H:%M:%S  "

" Ignore things
call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
      \ 'ignore_pattern', join([
      \     '\.git',
      \     'app/cache',
      \     'vendor',
      \     '\.vagrant',
      \     '\.ebextensions',
      \     '\.tmp',
      \     'node_modules',
      \     'build',
      \ ], '\|'))

" Shortcut behaviours whilst in unite mode
autocmd FileType unite call s:unite_settings()

function! s:unite_settings()
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  imap <silent><buffer><expr> <C-x> unite#do_action('split')
  imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

  nmap <buffer> <ESC> <Plug>(unite_exit)
endfunction



