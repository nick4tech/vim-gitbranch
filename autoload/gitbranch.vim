" =============================================================================
" Filename: autoload/gitbranch.vim
" Author: itchyny
" License: MIT License
" Last Change: 2021/08/20 23:05:12.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! gitbranch#name() abort
  let use_icon = get(g:, 'gitbranch_icon', 0)
  if use_icon 
    return ' ' . gitbranch#calculate_name()
  else
    return gitbranch#calculate_name()
  endif
endfunction

function gitbranch#calculate_name() abort
  if get(b:, 'gitbranch_pwd', '') !=# expand('%:p:h') || !has_key(b:, 'gitbranch_path')
    call gitbranch#detect(expand('%:p:h'))
  endif
  if has_key(b:, 'gitbranch_path') && filereadable(b:gitbranch_path)
    let branch = get(readfile(b:gitbranch_path), 0, '')
    if branch =~# '^ref: '
      return substitute(branch, '^ref: \%(refs/\%(heads/\|remotes/\|tags/\)\=\)\=', '', '')
    elseif branch =~# '^\x\{20\}'
      return branch[:6]
    endif
  endif
  return ''
endfunction

function! gitbranch#dir(path) abort
  let path = a:path
  let prev = ''
  let git_modules = path =~# '/\.git/modules/'
  while path !=# prev
    let dir = path . '/.git'
    let type = getftype(dir)
    if type ==# 'dir' && isdirectory(dir.'/objects') && isdirectory(dir.'/refs') && getfsize(dir.'/HEAD') > 10
      return dir
    elseif type ==# 'file'
      let reldir = get(readfile(dir), 0, '')
      if reldir =~# '^gitdir: '
        return simplify(path . '/' . reldir[8:])
      endif
    elseif git_modules && isdirectory(path.'/objects') && isdirectory(path.'/refs') && getfsize(path.'/HEAD') > 10
      return path
    endif
    let prev = path
    let path = fnamemodify(path, ':h')
  endwhile
  return ''
endfunction

function! gitbranch#detect(path) abort
  unlet! b:gitbranch_path
  let b:gitbranch_pwd = expand('%:p:h')
  let dir = gitbranch#dir(a:path)
  if dir !=# ''
    let path = dir . '/HEAD'
    if filereadable(path)
      let b:gitbranch_path = path
    endif
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
