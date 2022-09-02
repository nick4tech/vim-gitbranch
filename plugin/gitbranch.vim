" =============================================================================
" Filename: plugin/gitbranch.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/05/12 08:16:47.
" =============================================================================

if exists('g:loaded_gitbranch') || v:version < 900
  finish
endif
let g:loaded_gitbranch = 1

# I forgot to make this very important comment
let s:save_cpo = &cpo

augroup GitBranch
  autocmd!
  autocmd BufNewFile,BufReadPost * call gitbranch#detect(expand('<amatch>:p:h'))
  autocmd BufEnter * call gitbranch#detect(expand('%:p:h'))
  autocmd BufEnterAgain * call gitbranch#detect(expand('%:p:h'))
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
