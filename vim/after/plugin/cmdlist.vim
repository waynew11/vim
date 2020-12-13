"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
" $Id: misc.vim,v 1.0, 02/23/2012 21:12:30 Exp$ 
"
" <+description+>
"
" Copyright (c) 2012 Andrew E. Smith <andrew1972.es@gmail.com>
" All rights reserved.
"  
"===========================================================
if exists("g:my_cmdlist_scripts") | fini | en
let g:my_cmdlist_scripts=1

function! Find(name)
	let l:list=system("find . -name '".a:name."'|perl -ne 'print \"$.  $_\"'")
	let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
	if l:num < 1
		echo "'".a:name."' not found"
		return
	endif

	if l:num != 1
		echo l:list
		let l:input = input("Which ? (CR=nothing)\n")
		if strlen(l:input) ==0
			return
		endif
		if strlen(substitute(l:input, "[0-9]", "", "g"))> 0
			echo "Not a number"
			return
		endif
		if l:input<1 || l:input>l:num
			echo "Out of range"
			return
		endif
		let l:line=matchstr("\n".l:list, "\n".l:input."  [^\n]*")
	else
		let l:line = l:list
	endif
	let l:line=substitute(l:line, "^[^ ]*  ./", "", "")
	execute ":e ".l:line
endfunction

command! -nargs=+ Find :call Find("<args>")

"""""""""""""""""""""""""""""""""""""""""
"cmdlist_path
"---------------------------------------
"[c] command_name  - comment
"[e] comment       - file_name
"""""""""""""""""""""""""""""""""""""""""
function! ShowCmdList(cmdlist_path)
	let l:list=system("cat ".a:cmdlist_path."|sed -e '/^#/d;/^$/d'|perl -ne 'print \"$. $_\"'")
	let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
	if l:num < 1
		echo "no command found"
		return
	endif

	echo l:list
	let l:input = input("Which ? (CR=nothing)\n")
	if strlen(l:input) ==0
		return
	endif

	if strlen(substitute(l:input, "[0-9]", "", "g"))> 0
		echo "Not a number"
		return
	endif
	if l:input<1 || l:input>l:num
		echo "Out of range"
		return
	endif
	let l:line=matchstr("\n".l:list, "\n".l:input." [^\n]*")
	if match(l:line, "\n".l:input." .c")>=0
		let l:cmd=substitute(l:line, "^[^ ]* \\[c\\][ \t]*\\([^ \t]*\\).*", "\\1", "")
		if exists(":".l:cmd)
			redraw
			execute l:cmd
		else
			echo "Command '".l:cmd."' not found"
		endif
	endif

	if match(l:line, "\n".l:input." .e")>=0
		let l:cmdfile=substitute(l:line, "^[^-]*-[ \t]*\\([^\n]*\\)", "\\1", "")
		if filereadable(l:cmdfile)
			execute ":e ".l:cmdfile
		else
			echo "File '".l:cmdfile."' not exists"
		endif
	endif
	
endfunction
command! -nargs=1 ShowCmdList :call ShowCmdList("<args>")

