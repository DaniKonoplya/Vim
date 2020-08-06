source $VIMRUNTIME/vimrc_example.vim

set diffexpr=MyDiff()
function MyDiff()

  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

" autocmd VimEnter * echo "<^.^>"
set relativenumber
set wrap
" Cntrl+U uppercase word in Insert mode
inoremap <c-u> <esc>0viwU<esc>$
" Cntrl+U uppercase word inside Normal mode
nnoremap <c-u> vimU<esc>
"set leaders {{{
let mapleader = "-"
"set localleader 
let maplocalleader = "\\"
"delete line and enter to Insert mode
"}}}
nnoremap <leader>c ddO
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" surround string in quotes in visual mode 
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>
" more comfortable exit to a normal mode from insert mode 
inoremap jk <esc>
autocmd FileType powershell nnoremap <buffer> <localleader>c I#<esc>
autocmd FileType cpp nnoremap <buffer> <localleader>c I//<esc>

" python auto options {{{
autocmd FileType python setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType python     :iabbrev <buffer> iff if:<left>
autocmd FileType python     :iabbrev <buffer> forr for i in range(,):<esc>0f,i
autocmd FileType python     :iabbrev <buffer> whilee while :<esc>0fea
autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>
" }}}

augroup testgroup
	autocmd!
	autocmd FileType html nnoremap <buffer> <localleader>f Vatzf
augroup END 

function GTnum(line_count)
	let l = 1
	for ln in range(0,a:line_count)
		let @b=string(l)
		exec 's/\d\+/' . getreg('b')  .'/e' | normal! j
		let l += 1
	endfor
endfunction

" change title , possible delimeters -- or == 
onoremap <buffer> ih :<c-u>execute "normal! ?^\\(--\\+$\\\|==\\+$\\)\r:nohlsearch\rkvg_"<cr>

" Vimscript file settings ------------------------------{{{
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" switch automaticly from relative to non relative mode
augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set number  relativenumber
	autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END



