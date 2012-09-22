call pathogen#infect()
filetype plugin indent on

function! CheckIOSVim()
  if exists('g:loaded_ios')
    q
  else
    cq
  endif
endfunction
autocmd VimEnter * call CheckIOSVim()
