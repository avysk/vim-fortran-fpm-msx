# vim-fortran-fpm-msx

MSX-like setup for **Fortran Project Manager's projects** in gvim. **Only
graphical vim is supported**, things will probably be broken in console.

## Dependencies

You need the following:

- `vim-fortran-fpm` plugin
- `vim-colors-msx` plugin (optional) MSX-like vim colorscheme, strongly recommended.
- `vim-fullscreen` plugin (optional)
- MSX-like font, strongly recomended. Search online for truetype font "MSX Screen 0".

## What does it do

The plugin provides one function (`fortran#fpm#msx#Setup`) which you are supposed to connect to `fortran` data type, approximately like this:

```vimscrit
augroup MsxFortran
  autocmd!
  autocmd FileType fortran ++once call fortran#fpm#msx#Setup()
augroup END
```

Upon the first opening of Fortran file, the following will be done:

1. Gvim will be switched to fullscreen mode, if vim-fullscreen plugin is installed. If you are running X Window, installing `wmctrl` is highly recommended. On Windows there will be no fullscreen mode, but the gvim window will be maximized. If vim-fullscreen plugin is not available, the warning is logged into vim messages (`:h messages`).
2. Gvim will be switched to the usage of "msx" colorscheme, if vim-colors-msx plugin is installed. If "msx" colorscheme is not available, the warning is logged into vim messages.
3. `vim#fortran#fortran#fpm#CheckTools()` is called. If the required vim-fortran-fpm plugin is not installed, the error message will be shown, the function returns 0, and nothing more is done. If tools check fails, the error message will be shown, the function returns 0, and nothing more is done.
4. If `g:fortran_fpm_msx_font` is set, the `guifont` is set to its value. Otherwise, the warning is logged into vim messages.
5. If `g:fortran_fpm_msx_tw` is set, the `textwidth` option is set to its value.
6. If `g:fortran_fpm_msx_tw` is not set, and `textwidth` is zero, the warning is logged into vim messages. Otherwise, `colorcolumn` is set to the value of `textwidth`.
7. Graphical tabline is replaced by the text one, and it is set to be shown always. It will be used to show mapped keys' descriptions (see below).
8. F-key mappings are set and shown in tabline (see below).
9. The built-in termdebug plugin is loaded.

## Key bindings the plugin adds

### "Editing" keybindings

If you run the plugin, you will notice that in the tabline (on the top of the window) approximately the following is written: `F1 clean F2 build F3 args(toml) F4\ test(debug) F5 run`. This tries to describe the **normal** mode mapping the plugin adds. In the table below "S-" means "shift".

| Key  | Meaning                         | Comments                                                                                                                                                         |
| :--- | :------------------------------ | :--------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| F1   | Clean fpm project               | Dependencies are not removed. Runs `fpm clean --skip`,                                                                                                           |
| S-F1 | Clean fpm project               | Dependencies are removed. Runs `fpm clean --all`.                                                                                                                |
| F2   | Build fpm project               | Builds the default (debug) version.                                                                                                                              |
| S-F2 | Build fpm project               | Builds the release version.                                                                                                                                      |
| F3   | Setup arguments for fpm project | The arguments will be used when the project is run or debugger is run (see below).                                                                               |
| S-F3 | Edit `fpm.toml`                 | If there is an open window with `fpm.toml`, switch there. Otherwise, open `fpm.toml` in a new tab for editing. Notice that opened tabs are not shown in tabline. |
| F4   | Test the project                | Runs `fpm.test`. Success or failure will be shown in a popup.                                                                                                    |
| S-F4 | Debug the project               | See below.                                                                                                                                                       |
| F5   | Run the project                 | Runs the debug version. The arguments, set via "F3", will be applied, if any                                                                                     |
| S-F5 | Run the project                 | Runs the release version. The arguments, set via "F3", will be applied, if any                                                                                   |

### "Debugging" keybindings

If you enter the debug mode via "S-F4", you will notice that **normal** mode keybinds (normal -- i.e. they won't work in insert mode in gdb window) will change, and tabline will reflect it, showing something like `F1 break F2 clear(stop) F3 next(step) F4 cont(finish) F5 run(args)`. The debugger window will be opened and your binary will be loaded into the debugger. **Warning:** before doing this, make sure that the debug version of the project (via "F2") is already built.

The meaning of the keys is shown in the table below.

| Key  | Meaning                                           | Comments                                                                                                                                                                                                           |
| :--- | :------------------------------------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| F1   | Set breakpoint                                    | On the line with cursor in the source window.                                                                                                                                                                      |
| S-F1 | Set breakpoint                                    | Asks for file name and the line number in the command line.                                                                                                                                                        |
| F2   | Clear breakpount                                  | On the line with cursor in the source window.                                                                                                                                                                      |
| S-F2 | Interrupt the program                             | Executes `:Stop`.                                                                                                                                                                                                  |
| F3   | Go to the next statement, jumping over procedures | Executes `:Over`.                                                                                                                                                                                                  |
| S-F3 | Go to the next statement, going into procedures   | Executes `:Next`.                                                                                                                                                                                                  |
| F4   | Continue program                                  | Executes `:Continue`.                                                                                                                                                                                              |
| S-F4 | Finishes execution of the current stack frame     | Executes `:Finish`.                                                                                                                                                                                                |
| F5   | Starts debugging                                  | In vim (at least on Windows) `:Run` is broken after using `:Arguments`, so after `:Arguments` executes `:TermDebugSendCommand("run")`.                                                                             |
| S-F5 | Setup arguments for fpm project                   | Exactly the same as "F3" mapping in "editing" keybindings. Queries for arguments on the command line. Entered arguments will be passed to binary if it is run (either in debug or release mode) or it is debugged. |

## Installation

### Vimplug

The incantation is `Plug "avysk/vim-fortran-fpm-msx"`.

### Manual

Make sure that you have `autoload/fortran/fpm` subdirectory in your vim folder. Copy there `msx.vim` file from this repository.

## Customization

See "vim-fortran-fpm" plugin documentation for its options. There are also `g:fortran_fpm_msx_font` and `g:fortran_fpm_msx_tw` variables, described above.

## Screenshots

To be done.

## Tutorial

To be done.
