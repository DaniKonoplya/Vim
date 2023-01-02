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
" In normal mode: leader+c - Delete the whole line and return to the start
" Open split window from the right for the old file. 
nnoremap <leader>vs :execute "rightbelow vsplit " . bufname("#")<cr>
nnoremap <leader>c ddO
" Open the vimrc file 
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" Source the vimrc file
nnoremap <leader>sv :source $MYVIMRC<cr>
" surround string in quotes in visual mode 
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>
" more comfortable exit to a normal mode from insert mode 
inoremap jk <esc>
" These autocmd add the right comment sign according to the file's type
autocmd FileType powershell nnoremap <buffer> <localleader>c I#<esc>
autocmd FileType cpp nnoremap <buffer> <localleader>c I//<esc>
autocmd FileType sh  nnoremap <buffer> <localleader>c I#<esc>
autocmd FileType ksh  nnoremap <buffer> <localleader>c I#<esc>
autocmd FileType ksh  nnoremap <buffer> <localleader>c I#<esc>


" python auto options {{{
augroup filetype_python 
	autocmd! 
	autocmd FileType python setlocal shiftwidth=2 softtabstop=2 expandtab
	autocmd FileType python setlocal statusline=%F\ %-4y
	autocmd FileType python     :iabbrev <buffer> forr for i in range(,):<esc>0f,i
	autocmd FileType python     :iabbrev <buffer> whilee while :<esc>
	autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>
	autocmd FileType python     :iabbrev <buffer> deff def():<esc>Ffa
augroup END
" }}}

augroup testgroup
	autocmd!
	autocmd FileType html nnoremap <buffer> <localleader>f Vatzf
augroup END 

" Numerate lines function
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
	autocmd FileType vim setlocal foldmethod=marker foldlevelstart=0
augroup END
" }}}

" switch automaticly from relative to non relative mode
augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set number  relativenumber
	autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END

" Global statusline settings ------------------------{{{
augroup status_line
	set statusline=%F
	set laststatus=2 " Status line always visible
augroup END
" }}}

" Global matching settings -------------------------{{{
        " Find all lines with spaces at the end.
	nnoremap <leader>w :match Error /\v +$/<cr>
	nnoremap <leader>W :match none<cr>
	set hlsearch incsearch
	" Find the string under the cursor in all files in the current folder
	" nnoremap <leader>g :exe "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>
	" Map search between all files in buffer.
	nnoremap <leader>cn :exe "cnext"<cr>
	nnoremap <leader>cp :exe "cprevious"<cr>
	" Toggle numeric and relativenumber only in the current window
	nnoremap <leader>sw :exe "setlocal nu!"<cr><esc>:exe "setlocal rnu!"<cr><esc>	
	" Delete all line aren't pertaining to errors.
	nnoremap <leader>err :call Just_errors()<cr>

" }}}
"
"
"Function is used in logs. It deletes all lines aren't relevant to ERROR
"messages.

function! Just_errors()
        setlocal nowrapscan
        exe "normal! gg"
        for ln in range(0,100)
                exe "normal! /Severity:.*INF\\|Severity:.*WARN\<cr>3kmm/Severity:.*ERR\<cr>3kmn`md`n"
        endfor
        setlocal wrapscan
        " exe "normal! dG\<cr>"
endfunction


" Example of various keys usage. 
" execute "normal! 04j\<C-v>$2jx4kea\<tab>\<esc>p8jq:k\<cr>"

