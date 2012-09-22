call pathogen#infect()
filetype plugin indent on

function! CheckCommandTWorks()
  try
    CommandTFlush
    q
  catch
    cq
  endtry
endfunction

autocmd VimEnter * call CheckCommandTWorks()
