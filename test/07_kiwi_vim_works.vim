call pathogen#infect()
filetype plugin indent on

function! CheckKiwiVim()
  if exists('g:loaded_kiwi')
    q
  else
    cq
  endif
endfunction
autocmd VimEnter * call CheckKiwiVim()
