function s:warning(msg)
  echohl WarningMsg
  echomsg a:msg
  echohl None
endfunction

function! fortran#fpm#msx#RunDebug()
        " It seems that :Run command is broken after setting arguments
        if exists("g:vim_fortran_fpm_run_args")
                let cmd = "Arguments " .. g:vim_fortran_fpm_run_args
                silent execute cmd
        endif
        call TermDebugSendCommand("run")
endfunction

function! fortran#fpm#msx#FirstError()
  try
    silent cfirst
  catch /E42/
      let sHl = get(g:, "vim_fortran_fpm_success_hl", "Comment")
      let sT = get(g:, "vim_fortran_fpm_success_time", 1000)

      let msg = "Success!"
      call popup_notification(msg, #{line: 0, col: 0, highlight: sHl, time: sT})
  endtry
endfunction

function! <SID>EditKeyBindings()
        set tabline=F1\ clean\ F2\ build\ F3\ args(toml)\ F4\ test(debug)\ F5\ run
        nnoremap <silent> <F1> :silent make clean --skip<CR>
        nnoremap <silent> <S-F1> :silent make clean --all<CR>
        nnoremap <silent> <F2> :silent make build <BAR> cwindow <BAR> call fortran#fpm#msx#FirstError()<CR>
        nnoremap <silent> <S-F2> :silent make build --profile release <BAR> cwindow <BAR> call fortran#fpm#msx#FirstError()<CR>
        nnoremap <silent> <F3> :call fortran#fpm#SetRunArgs()<CR>
        nnoremap <silent> <S-F3> :call fortran#fpm#EditToml()<CR>
        nnoremap <silent> <F4> :call fortran#fpm#RunTests()<CR>
        nnoremap <silent> <S-F4> :call fortran#fpm#StartDebugging()<CR>
        nnoremap <silent> <F5> :call fortran#fpm#RunDebugTarget()<CR>
        nnoremap <silent> <S-F5> :call fortran#fpm#RunReleaseTarget()<CR>
endfunction

function! <SID>DebugKeyBindings()
        set tabline=F1\ break\ F2\ clear(stop)\ F3\ next(step)\ F4\ cont(finish)\ F5\ run(args)
        nnoremap <silent> <F1> :Break<CR>
        nnoremap <silent> <S-F1> :Break 
        nnoremap <silent> <F2> :Clear<CR>
        nnoremap <silent> <S-F2> :Stop<CR>
        nnoremap <silent> <F3> :Over<CR>
        nnoremap <silent> <S-F3> :Step<CR>
        nnoremap <silent> <F4> :Cont<CR>
        nnoremap <silent> <S-F4> :Finish<CR>
        nnoremap <silent> <F5> :call fortran#fpm#msx#RunDebug()<CR>
        nnoremap <silent> <S-F5> :call fortran#fpm#SetRunArgs()<CR>
endfunction

function fortran#fpm#msx#Setup()
  if exists(":FullscreenStart")
    FullscreenStart
    sleep 1
  else
    call s:warning("vim-fullscreen is not available")
  endif

  try
    colorscheme msx
  catch /E185/
    call s:warning("MSX colorscheme is not available.")
  endtry

  try
    if !fortran#fpm#CheckTools()
      echoerr "vim-fortran-fpm's tool check failed."
      return 0
    endif
  catch /E117/
    echoerr "vim-fortran-fpm is not available."
    return 0
  endtry

  call fortran#fpm#Setup()

  if exists("g:fortran_fpm_msx_font")
    let cmd = "set guifont=" .. g:fortran_fpm_msx_font
    silent execute cmd
  else
    call s:warning("g:fortran_fpm_msx_font is not set.")
  endif

  if exists("g:fortran_fpm_msx_tw")
    let &tw = g:fortran_fpm_msx_tw
  else
    if !&tw
      call s:warning("g:fortran_fpm_msx_tw is not set and textwidth is zero.")
    endif
  endif

  if &tw
    let &colorcolumn=&tw
  endif

  set guioptions-=e
  set showtabline=2

  call <SID>EditKeyBindings()

  packadd termdebug

  augroup TermdebugEvents
    autocmd!
    autocmd User TermdebugStartPost call <SID>DebugKeyBindings()
    autocmd User TermdebugStopPost call <SID>EditKeyBindings()
  augroup END

  return 1

endfunction
