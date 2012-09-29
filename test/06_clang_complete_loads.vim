
call pathogen#infect()
filetype plugin indent on

function! ClangCompleteLoads()
  if exists('*g:ClangUpdateQuickFix')
    q
  else
    cq
  endif
endfunction
autocmd VimEnter * call ClangCompleteLoads()
