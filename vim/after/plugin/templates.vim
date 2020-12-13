""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" $Id: templates.vim,v 1.0 2009-01-06 13:38:01 Exp$
"
" templates for auto new files
"
" Copyright (c) 2009 Andrew E. Smith <andrew1972.es@gmail.com>
" All rights reserved
"
"========================================================

if exists("g:my_templates") | fini | en
let g:my_templates = 1
let g:copyrights="Copyright (c) 2020."
"let g:author="Andrew E. Smith"
let g:author="Wenyin Wang"
let g:email="andrew1972.es@gmail.com"
let g:version="v 1.0"

if !exists('$VIMTEMPLATES')
  let rtp=&rtp
  wh strlen(rtp)
    let idx=stridx(rtp,',')
    if idx<0|let idx=65535|en
    let $VIMTEMPLATES=strpart(rtp,0,idx).'/templates'
    if isdirectory($VIMTEMPLATES)
      brea
    en
    let rtp=strpart(rtp,idx+1)
  endw
en

fu! TplExec(what)
    exe 'retu' a:what
endf

fu! TplLoad(extension)
    let ext=strlen(&ft) ? a:extension : 'default'
    let tpl=$VIMTEMPLATES.'/'.ext.'.tpl'
    sil exe '0r '.tpl
"   <++call++>
    sil %s/<++\(.\{-1,}\)++>/\=TplExec(submatch(1))/ge
"   translate __define__ to __DEFINE__

    if expand('%:e') == "h" || expand('%:e') == "hh" || expand('%:e') == "hpp"
      sil %s/__\(.\{-1,}\)__/\U&/ge
    endif
endf

autocmd BufNewFile * silent! call TplLoad('%:e')
nnoremap <c-j><c-j> /<+.\{-1,}+><cr>c/+>/e<cr>
nnoremap <c-j><c-p> :1,2s/\(coding[:=]\s*\)[a-zA-Z0-9-.]\+/\1<+encoding+><cr><cr>
inoremap <c-j><c-j> <ESC>/<+.\{-1,}+><cr>c/+>/e<cr>

