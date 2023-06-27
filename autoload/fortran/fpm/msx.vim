function s:warning(msg)
  echohl WarningMsg
  echomsg a:msg
  echohl None
endfunction

function fortran#fpm#msx#Setup()
  try
    colorscheme msx
  catch /E185/
    call s:warning("MSX colorscheme is not available.")
  endtry

  try
    if !(call fortran#fpm#CheckTools()
      echoerr "vim-fortran-fpm's tool check failed."
      return 0
    endif
  catch /E117/
    echoerr "vim-fortran-fpm is not available."
    return 0
  endtry

  if exists(":FullscreenStart")
    FullscreenStart
  else
    call warning("vim-fullscreen is not available")
  endif

  if exists("g:fortran_fpm_msx_font")
    let cmd = "set guifont=" .. g:fortran_fpm_msx_font
    silent execute cmd
  else
    call warning("g:fortran_fpm_msx_font is not set")
  endif

  set guioptions-=e
  set showtabline=2

  packadd termdebug

endfunction
