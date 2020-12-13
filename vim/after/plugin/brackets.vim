"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
" $Id: brackets.vim,v 1.0 2009/01/06 19:48:57 Exp$ 
" Copyright (c) 2009 Andrew E. Smith <andrew1972.es@gmail.com>
" All rights reserved.
"===========================================================
if exists("g:my_brackets") | fini | en
let g:my_brackets = 1
let g:bracket_enable = 0

fu! BracketClosePair(char)
    if getline('.')[col('.') - 1] == a:char
       return "<Right>"
    else
        return a:char
    endif
endf

fu! s:Bracket_Open()
    if(g:bracket_enable==1)
        let g:bracket_enable=0
        call s:Bracket_Disable()
        return
    else
        let g:bracket_enable=1
        call s:Bracket_Enable()
        return
    endif
endf

fu! s:Bracket_Enable()
    :inoremap ( ()<ESC>i
    :inoremap ) <c-r>=BracketClosePair(')')<CR>
    :inoremap { {}<ESC>i
    :inoremap } <c-r>=BracketClosePair('}')<CR>
    :inoremap [ []<ESC>i
    :inoremap ] <c-r>=BracketClosePair(']')<CR>
endf

fu! s:Bracket_Disable()
    :iunmap (
    :iunmap )
    :iunmap {
    :iunmap }
    :iunmap [
    :iunmap ]
endf

command! -nargs=0 -bar BracketToggle call s:Bracket_Open()

