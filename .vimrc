" MY .vimrc SECTIONS
" ==================
" 01 The default vimrc file, copied verbatim + modified where commented
" 02 Windows and WSL handling
" 03 Various additions from different sources (as noted)
" 04 Functions and commands
" 05 Plugins information
" ...
" 11 Airline plugin settings/overrides
" ...
" 77 Deleted content (notes)
" 88 Testing area

" =====================================================================
" 01 The default vimrc file, copied verbatim + modified where commented
" =====================================================================
" Based on Bram Moolenaar's defaults (2020 Sep 30), which is loaded when no
" vimrc file is found. Vim can be run with "-u NONE" or "-C" to not load a
" vimrc. Individual settings can be reverted with ":set option&".

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200      " keep 200 lines of command line history
set ruler            " show the cursor position all the time
set showcmd          " display incomplete commands
set wildmenu         " display completion matches in a status line

set ttimeout         " time out for key codes
set ttimeoutlen=100  " wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Do use Ex mode ,, deleted: map Q gq default setting, i.e., do NOT use Q for
" formatting, use the default Ex mode

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
" PK: note that the undo atom is determined by rules, e.g., a return creates
" an undo point
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
" Only xterm can grab the mouse events when using the shift key, for other
" terminals use ":", select text and press Esc.
if has('mouse')
  if &term =~ 'xterm'
    set mouse=a
  else
    set mouse=nvi
  endif
endif

" Only do this part when Vim was compiled with the +eval feature.
if 1
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on
  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
  augroup END
endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors). ,, PK since I do not use C the C comments
" highlighting option is deleted (let c_comment_strings=1)
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
    \ | wincmd p | diffthis
  command DO DiffOrig " ,,PK added a synonym since this is so great
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

" =====================================================================
" 02 Windows and WSL handling
" =====================================================================
" Windows Gvim stores the '.vimrc' as '_vimrc' in the home directory.
" The following are changes made so that the experience using Windows Gvim
" and WSL, are optimal.

" Prevent startup in Replace mode when using WSL (has no impact on
" native Linux) as well as Windows.
" https://superuser.com/questions/1284561/why-is-vim-starting-in-replace-mode
set t_u7=

" These should be immume to Linux, so can be retained.
if has('win32')
  " Force utf-8 as otherwise the display will be square boxes / upside down ?s
  " https://vim.fandom.com/wiki/Working_with_Unicode
  set encoding=utf-8
  " Set gvim-specific font to ensure display of special characters
  " https://dejavu-fonts.github.io/ (DejaVu Sans Mono for Powerline)
  " This handles Windows Gvim, which does not have sticky fonts,
  " however, for WSL the font can be set in the
  " WSL Properties dialog, but the font should also be installed, i.e.,
  " https://packages.debian.org/bullseye/fonts-dejavu
  if has("gui_running")
    if has("gui_win32")
      set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h12 " https://github.com/powerline/fonts/tree/master/DejaVuSansMono
      set guifontwide=DejaVu\ Sans\ Mono\ for\ Powerline:h12 " For windows to display mixed character sets
      " Note: http://dejavu.sourceforge.net/samples/DejaVuSansMono.pdf provides the addressed characters as at 2016 but this is a 2018 font so it may cover more
    endif
  endif
else " WSL test for airline Powerline
  " But set no Powerline fonts when in WSL as they are a pain to get right
  if strlen(system('uname -a | grep Microsoft')) > 0
    set encoding=utf-8
    let g:airline_powerline_fonts = -1 " I believe init.vim has this wrongly set up so this should work
    let g:airline_symbols_ascii = 1 " Set the symbols to ascii but override some later
  endif
endif

" =====================================================================
" 03 Various additions from different sources (as noted)
" =====================================================================

" Remap space to leader in Normal mode
nnoremap <SPACE> <Nop>
let mapleader = " "

" Define Next/Prior buffer function and use Tab and Shift-Tab to navigate them
" in Normal mode
function! NextBuffer() abort
  silent! execute "bn!"
endfunction
function! PriorBuffer() abort
  silent! execute "bp!"
endfunction
nnoremap <TAB> :call NextBuffer()<CR>
nnoremap <S-TAB> :call PriorBuffer()<CR>

" Selected .vimrc from https://vim.fandom.com/wiki/Example_vimrc
"
" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" Always display the status line, even if only one window is displayed
set laststatus=2

" Set the command window height to 2 lines, to avoid many cases of having to
" press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left and set line number width to 3
" Change the color used for the line numbers
" https://vim.fandom.com/wiki/Display_line_numbers#Mapping_to_toggle_line_numbers
set number
set numberwidth=3
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=Grey guibg=NONE

" Function and <leader>l mapping for relative line number toggling (note
" <leader> default is the \ key
" Modified from https://tuckerchapman.com/2018/06/16/how-to-use-the-vim-leader-key/
function! ToggleLineNumber() abort
  if v:version > 703
    set relativenumber!
  endif
endfunction
map <leader>l :call ToggleLineNumber()<CR>

" Allow left and right arrow keys, as well as h and l, to wrap when used at
" beginning or end of lines. Since I have the 40% keyboard which uses
" Upper-h and Upper-L to mimic the Left and Right arrow keys, this ensures
" that they behave the way I want them to.
" gx https://vim.fandom.com/wiki/Automatically_wrap_left_and_right
set whichwrap+=<,>,h,l,[,]

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
" (noting that there is good guidance out there for why not to mess with
" tabstop=8)
set shiftwidth=4
set softtabstop=4
set expandtab

" https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim
" recommendations (noting wildmenu already set by default)
set smarttab

" Show the mode you are on the last line. A lot of folk turn this off
" when using plugins like Airline, but I prefer it always on.
set showmode

" *** Thinking this is not that great and keep to <ESC> or <CTRL>[
" Map, without recursion, during Visual, Select and Insert modes
" ;; to escape to Normal. This helps provide
" another option on the right side of the keyboard.
" The remapping of the 'arrow' keys is another common
" method, e.g., inoremap jk <Esc> but the delay is just annoying IMHO.
" Mapping C-\ C-n is equivalent to escape.
" (NB: Remapping Esc itself has unwanted side effects: don't!)
" inoremap ;; <C-\><C-n>
" vnoremap ;; <C-\><C-n>
" *** Thinking this is not that great and keep ; to do next after f/F/t/T
" Common remapping of ; to : when in Normal mode to save having to Shift
" nnoremap ; :
" Map CTRL-C so that (in Normal mode, where it is alrealy almost a synonym for
" <ESC>) it goes to Command mode.  And, similarly, in Insert and Visual mode
" it goes to Command Mode too, skipping Normal Mode.  This then means CTRL-C
" works like a master toggle between Normal and Command modes as well as going
" there from the other modes.  Combined with belloff (turning the bell off)
" the annoying bell when <ESC> is pressed in Normal mode is also deactivated.
nnoremap <C-c> <ESC>:
inoremap <C-c> <C-\><C-n>:
vnoremap <C-c> <C-\><C-n>:

" Turn the error bell off for whtn backspace or cursor movement results in an
" error and also when ESC is pressed in Normal mode, which is annoying.
set belloff=backspace,cursor,esc

" Make the arrow keys work exclusively (down a wrapped text line) rather
" than linewise which is a real pain. (:norm j etc. can be used if wanted)
" Note that with the 40% keyboard this is gold because the Down, Up are
" actually Upper-j and Upper-k.  The inoremaps are needed because gj and gk
" are literals in Insert mode, so <C-o> for one command is needed to make it
" work the same in Insert mode.
nnoremap <Down> gj
nnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" Use Control-S in Normal mode to act like any other text editor (Windows)
" where it saves the file.
nnoremap <C-s> :w<CR>

" Use Control-K in Normal mode to display digraphs since Control-K in Insert
" mode actually inserts the digraphs.  Note that in Normal mode Control-K is
" actually unmapped, so this is not a change, and is just logical.
nnoremap <C-k> :digraphs<CR>

" Function and <leader>v mapping for virtual editing (refer :help
" virtualedit), which can be used especially for editing tables such as
" markdown when you effectively want to treat blank space as spaces.
" They can be combined, e.g., block,onemore (not handled here).
set virtualedit=
function! CycleVirtualEdit() abort
  if &virtualedit == "all"
      set virtualedit=block
      echo 'virtualedit=block'
  elseif &virtualedit == "block"
      set virtualedit=insert
      echo 'virtualedit=insert'
  elseif &virtualedit == "insert"
      set virtualedit=onemore
      echo 'virtualedit=onemore'
  elseif &virtualedit == "onemore"
      set virtualedit=
      echo 'virtualedit='
  elseif &virtualedit == ""
      set virtualedit=all
      echo 'virtualedit=all'
  endif
endfunction
map <leader>v :call CycleVirtualEdit()<CR>

" When joining lines, only one space - NB: there is no true nospace option
set nojoinspaces

" --- highlight special characters and the cursor ---

" Highlight special characters, including nbsp and trailing spaces
"  < non-breaking space  |  tab 	  |  trailing space > 
set list
set listchars=nbsp:°,trail:·,tab:→—,eol:¶
highlight SpecialKey ctermbg=Yellow guibg=DarkYellow guifg=Black
highlight NonText ctermfg=238 guifg=#d0d0d0

" Highlight line when in Insert mode as a key way to show you are in the mode
set cursorlineopt=line

function! CustomCursorIBEAM() abort
  " Set the cursor to reflect the mode in XFCE
  " https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
  if isdirectory('~/.config/xfce4')
    if filewritable('~/.config/xfce4/terminal/terminalrc')
      silent execute "!sed -i.bak -e 's/TERMINAL_CURSOR_SHAPE_BLOCK/TERMINAL_CURSOR_SHAPE_IBEAM/' ~/.config/xfce4/terminal/terminalrc"
    endif
  endif
  set cursorline
endfunction

function! CustomCursorBLOCK() abort
  " Set the cursor to reflect the mode in XFCE
  if isdirectory('~/.config/xfce4')
    if filewritable('~/.config/xfce4/terminal/terminalrc')
        silent execute "!sed -i.bak -e 's/TERMINAL_CURSOR_SHAPE_IBEAM/TERMINAL_CURSOR_SHAPE_BLOCK/' ~/.config/xfce4/terminal/terminalrc"
    endif
  endif
  set nocursorline
endfunction

autocmd InsertEnter * call CustomCursorIBEAM()

autocmd InsertLeave * call CustomCursorBLOCK()

autocmd VimEnter * call CustomCursorBLOCK()

autocmd VimLeave * call CustomCursorIBEAM()

" Put a highlight at column 80
set colorcolumn=80

" Enable unsaved buffers to remain open rather than forcing saves/erroring
set hidden

" =====================================================================
" 04 Functions and Commands
" =====================================================================
"
" NB : the recommendation to add 'abort' after each so that
" if something goes wrong Vim will not try to run the whole function, as
" recommended by the Reddit vimrctips.
"
":call GenerateUnicode(0x9900,0x9fff)
function! GenerateUnicode(first, last) abort
  let i = a:first
  while i <= a:last
    if (i%256 == 0)
      $put ='------------------------------------'
      $put ='     0 1 2 3 4 5 6 7 8 9 A B C D E F'
      $put ='------------------------------------'
    endif
    let c = printf('%04X ', i)
    for j in range(16)
      let c = c . nr2char(i) . ' '
      let i += 1
    endfor
    $put =c
  endwhile
endfunction

" --------------------------------------------------------------------
" Commenting code
" From source in
" https://stackoverflow.com/questions/1676632/whats-a-quick-way-to-comment-uncomment-lines-in-vim
let s:comment_map = {
    \   "c": '\/\/',
    \   "cpp": '\/\/',
    \   "go": '\/\/',
    \   "java": '\/\/',
    \   "javascript": '\/\/',
    \   "lua": '--',
    \   "scala": '\/\/',
    \   "php": '\/\/',
    \   "python": '#',
    \   "ruby": '#',
    \   "rust": '\/\/',
    \   "sh": '#',
    \   "desktop": '#',
    \   "fstab": '#',
    \   "conf": '#',
    \   "profile": '#',
    \   "bashrc": '#',
    \   "bash_profile": '#',
    \   "mail": '>',
    \   "eml": '>',
    \   "bat": 'REM',
    \   "ahk": ';',
    \   "vim": '"',
    \   "tex": '%',
    \ }

function! ToggleComment() abort
    if has_key(s:comment_map, &filetype)
        let comment_leader = s:comment_map[&filetype]
        if getline('.') =~ "^\\s*" . comment_leader . " "
            " Uncomment the line
            execute "silent s/^\\(\\s*\\)" . comment_leader . " /\\1/"
        else
            if getline('.') =~ "^\\s*" . comment_leader
                " Uncomment the line
                execute "silent s/^\\(\\s*\\)" . comment_leader . "/\\1/"
            else
                " Comment the line
                execute "silent s/^\\(\\s*\\)/\\1" . comment_leader . " /"
            end
        end
    else
        echo "No comment leader found for filetype"
    end
endfunction
nnoremap <leader>c :call ToggleComment()<cr>
vnoremap <leader>c :call ToggleComment()<cr>

" --------------------------------------------------------------------

" User-command Rp (redir to register p)
command! -nargs=+ -complete=command Rp redir @p | silent execute <q-args> | redir END
" This means, for example, :Rp filter /S[duh]/ command
" will put the output of that command to the p register. Then all you need
" to do is "pp to put the contents of that register p to the buffer
" in Normal mode

" =====================================================================
" 05 Plugins information
" =====================================================================
" I am now using the inbuilt Vim plugin handling.
" * Plugins path: ~/.vim/pack/plugins/start/ or ~\vimfiles\pack\plugins\start
" * To determine the remote git repository: git remote show origin
" * Deleted plugin: Pymode.  I was not using this enough.  If the old setup is
"   wanted for whatever reason, the setup as at 6/7/2022 is at:
"   https://github.com/kennypete/.vimrc/blob/86db077d1039a4cd43b5d67f050bca1f4f2e8a91/_vimrc
" Plugins in use (20221024):
" https://github.com/kennypete/vim-airline.git
" https://github.com/kennypete/vim-airline-themes.git
" https://github.com/habamax/vim-asciidoctor.git
" https://github.com/kennypete/vim-sents.git
" https://github.com/kennypete/vim-characterize.git


" =====================================================================
" 11 Airline plugin settings/overrides
" =====================================================================
"
" PLUGIN >>> airline <<<
let g:airline_theme='ansi_focus'
let g:airline_section_warning = ""
let g:airline_mode_map_codes = 0
" mode map overrides
if g:airline_mode_map_codes != 1
    " overrides modes' display (entering by <C-v><C-{char}>)
    let g:airline_mode_map = {
        \ 'niV' : 'VIRTUAL REPLACE (NORMAL)',
        \ 'V' : 'VISUAL LINE',
        \ '' : 'VISUAL BLOCK',
        \ 'S' : 'SELECT LINE',
        \ '' : 'SELECT BLOCK',
        \ 'ic' : 'INSERT COMPLETION GENERIC',
        \ 'ix' : 'INSERT COMPLETION',
        \ 'Rc' : 'REPLACE COMPLETION GENERIC',
        \ 'Rv' : 'VIRTUAL REPLACE',
        \ 'Rx' : 'REPLACE COMPLETION',
        \ 'c' : 'COMMAND-LINE',
        \ }
else
    let g:airline_mode_map = {
        \ '' : '^S',
        \ '' : '^V',
        \ }
endif
let g:airline_section_c_only_filename = 1
" Requires a font that will display Unicode when in WSL - DejaVu Sans Mono for
" Powerline is the most touted
" https://github.com/powerline/fonts/tree/master/DejaVuSansMono NOT
" https://packages.debian.org/bullseye/fonts-dejavu NOR other Debian ones
" The first if line here may not be needed?
if strlen(system('uname -a | grep Microsoft')) == 0
  let g:airline_powerline_fonts=1
endif
" Don't set the g:airline_left_sep and g:airline_right_sep as they, with
" g:airline_powerline_fonts enabled, seem to managed to produce a full left
" and right triangle for the status line.  I was using g:airline_left_sep='◤'
" \u25e5 and g:airline_right_sep='◢' \u25e2
" Overwrite the symbols with what I want, being characters that display okay
" when using DejaVu Sans Mono for Powerline font.
let g:airline_symbols = {}
let g:airline_symbols.colnr = ' '     " \u2009\ue0a3
let g:airline_symbols.crypt = 'Ȼ'      " \u023b
let g:airline_symbols.linenr = ' ¶'    " \u2009\u00b6
let g:airline_symbols.maxlinenr = 'Ω'  " \u03a9
let g:airline_symbols.branch = ''     " \ue0a0
let g:airline_symbols.paste = 'ρ'      " \u03c1
let g:airline_symbols.spell = '✓'      " \u2713
let g:airline_symbols.notexists = '∄'  " \u2204
let g:airline_symbols.whitespace = 'Ξ' " \u039e
let g:airline_symbols.space = ' '
let g:airline_symbols.readonly = '⊝'   " \u229d
let g:airline_symbols.dirty='☣'        " \u2623
let g:airline_symbols.modified='Δ'     " \u0394
let g:airline_symbols.keymap='Keymap:'
let g:airline_symbols.ellipsis='⋯'     " \u22ef
" Enable the list of buffers, not tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#show_buffers = 1
" Show just the filename
let g:airline#extensions#tabline#formatter = 'unique_tail'

" =====================================================================
" 77 Deleted content (notes)
" =====================================================================
" VIM MODES ***********************************************************
" Mode information: the table that was included as a comment has been removed.
" Just gx this https://github.com/kennypete/asciidoc/blob/main/vim.asciidoc
" Also gx https://rawgit.com/darcyparker/1886716/raw/vimModeStateDiagram.svg
" PYMODE **************************************************************
" Deleted plugin: Pymode.  I was not using this enough.  If the old setup is
" wanted for whatever reason, the setup as at 6/7/2022 is at:
" https://github.com/kennypete/.vimrc/blob/86db077d1039a4cd43b5d67f050bca1f4f2e8a91/_vimrc
"
" =====================================================================
" ================================ 88 =================================
" =====================================================================

