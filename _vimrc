" .vimrc
" 01 Windows, WSL, GUI options {{{
" Windows Gvim stores the '.vimrc' as '_vimrc' in the home directory.
" The following are changes made so that the experience using Windows Gvim
" and WSL, are optimal.  They could be in a . or _ gvimrc, but that would
" require two files, which makes for more maintenance and harder debugging.
"
" Prevent startup in Replace mode in WSL (no impact native Linux/Win32)
set t_u7=
if has("gui_running")
  " allow lines to be as long as you like - easier sometimes to read
  set nowrap
  " don't hide the mouse cursor when something is typed - low value
  set nomousehide
  " set guifont=DejaVu_Sans_Mono_for_Powerline:h12
  " Set gvim-specific font to ensure display of special characters
  " however, for WSL the font can be set in the
  " WSL Properties dialog, but the font should also be installed
  set guifont=FiraCode_NFM:h12 " https://www.nerdfonts.com/font-downloads
  " extend default guioptions to...
  set guioptions+=!abceghLmrtT
  " customise the tabline for when using vim9-tene
  if version > 899
    set guitablabel=%{%join(tabpagebuflist('%'),'\ ˙\ ')..' %t'%}
  endif
  if has("Win32")
    " set renderoptions=type:directx " 'glyphs more beautiful', coloured emoji
    "                                   BUT ligatures in coding fonts ... NO!
    " KEEP cmd.exe default as that keeps gx working!
    "set shell=bash.exe " Vim plays nicest with Linux/bash, so exploit that
    " set shell=powershell.exe " system32\WindowsPowerShell\v1.0\powershell.exe
  endif
else " No GUI, but Windows = console Vim; a more distinct Replace mode cursor
  if has("Win32")
    set guicursor=n-v-c-sm:block,o-r-cr:hor50,i-ci:hor25
    set lines=28
    set shell=powershell.exe
  endif
endif
" Mini thesaurus: use if present
if has("Win32")
  if filereadable($HOME..'\vimfiles\mini-thesaurus.txt')
    set thesaurus=$HOME\vimfiles\mini-thesaurus.txt
  endif
else
  if filereadable($HOME..'/.vim/mini-thesaurus.txt')
    set thesaurus=$HOME/.vim/mini-thesaurus.txt
  endif
endif
" }}}
" 02 Highlights {{{
" There are not a lot of .vimrc highlights as I accept defaults for many
" things and/or use highlights in plugins. The ones here are for the most
" essential things like the line numbers and the current line number,
" non-printing wrap characters, and non-printing special characters, which are
" highlighted so that they are more obvious when editing documents.
" These are in an autocmd group too, so that they re-set if a colorscheme is
" called, and early in the .vimrc to ensure it is called if a colorscheme is.
if has("gui_running")
  highlight CursorLineNr guifg=DarkGrey gui=bold
  highlight LineNr guifg=Grey "| Line numbers colours
  highlight NonText guifg=LightGrey "| For the wrap chrs
  highlight SpecialKey guibg=LightGrey guifg=White "| Tab, etc
  highlight ModeMsg guifg=DarkGrey gui=bold "| Modeline
  highlight ColorColumn guibg=LightGrey "| Column at 80 etc
  highlight CursorLine guibg=LightGrey "| Line the cursor's on
else " Optimising for Windows Vim
  highlight CursorLineNr ctermfg=Green cterm=bold
  highlight LineNr ctermfg=DarkGrey "| Line numbers colours
  highlight NonText ctermfg=DarkGrey "| For the wrap chrs
  highlight SpecialKey ctermfg=Grey "| Tab, etc
  highlight ModeMsg ctermfg=LightGrey cterm=bold "| Modeline
  highlight ColorColumn ctermbg=DarkBlue "| Column at 80 etc
  highlight CursorLine ctermbg=DarkBlue "| Line the cursor's on
endif
" This should reflect the above, but is not at the moment.
augroup MyColors
    autocmd!
    autocmd ColorScheme * highlight LineNr guifg=Grey ctermfg=8
      \ | highlight CursorLineNr guifg=DarkGrey cterm=bold ctermfg=15
      \ | highlight NonText ctermfg=238 guifg=#d0d0d0
      \ | highlight SpecialKey ctermfg=Grey guibg=Grey guifg=White
      \ | highlight ModeMsg ctermfg=252 cterm=bold gui=bold guifg=Grey
augroup END
" }}}
" 03 Settings (global) {{{
" Vim can be run with "-u NONE" or "-C" to not load a vimrc.
" Individual settings can be reverted with ":set option&" in most cases.
" For global settings that are left with the defaults, refer the end of this
" section.
set autoindent " Alhough local, useful if working with text files.
set backspace=indent,eol,start " Allow backspacing everywhere in Insert mode
set belloff=backspace,cursor,esc,insertmode " Turn off the bell!
set clipboard=unnamed " Puts any yanked, deleted text into clipboard reg and *
set cmdheight=2 " Cmd-line height 2 lines; avoid lots of press <Enter> to...
set cmdwinheight=9 " Cmd-line window (q:) height: a few more lines v. default
set colorcolumn=80 " Put a highlighted column at chr 80; refer <leader>I below
"set cursorlineopt=number,line " Highlight the line + number in insert modes
set display=truncate " Show @@@ in last line if truncated
set encoding=utf-8 " Character encoding used inside Vim itself, not files
set expandtab   " Uses No. of spaces to insert a <Tab>s
set foldclose=all " auto close folds when cursor leaves
set foldcolumn=1 " Show folds in a single column; equiv. let &foldcolumn = 1
set foldlevelstart=0 " Start editing with all folds closed
" set gui* are above in Windows...
set helpheight=13 " Minimum initial height for :h when it opens in a window
set hidden      " Enable unsaved buffers to remain open (reduces error msgs)
set history=10000 " keep max lines of command line history (default is 50)
set hlsearch    " use <C-L> to turn off highlighting w/ mapping <C-L> below
set incsearch   " show search patten matches typing; requires has('reltime')
set keymodel=startsel " Makes <S-PageUp> etc. select the text and Visual mode
set keywordprg=:help " Program used for K (jumps to the Word) - use Vim help
set laststatus=2 " Always display statusline, even if when only one window
" set lines is above in Windows/GUI section
set list        " Shows tabs, eol, etc., and refer below for setlistchars
set listchars=nbsp:°,trail:·,tab:——►,eol:¶ " highlight formatting /specials
set matchpairs=(:),{:},[:],“:”,‘:’ " pairs to highlight when one's selected
silent execute has('mouse') ? 'set mouse=ar' : '' | " enable in all modes
" set mousehide is above in GUI section
set nolangremap " prevent opt: may not be needed, but follows defaults.vim
set nrformats=alpha,hex,bin " all except Octal for CTRL-A and CTRL-X
silent execute (version < 900) ? '' : 'set nrformats+=unsigned'
set number      " Display line numbers on the left and number width to 3
set numberwidth=3 " Line number width to min of 3; expand if more
" set operatorfunc is defined in the map section (xnoremap <F8>) section
set printfont=FiraCode_NFM:h9 " This seems to keep things within 80chrs
set printheader=%<%F %h %m (%L lines)%=Page %N " custom header, incl. lines
set printoptions=number:y " prints with line numbers
set pumheight=9 " limit the popup menu for Insert mode completion to 9 lines
set pumwidth=18 " ... and increase the character width for popup menu items
" set renderoptions is above in Windows/GUI section
set scrolloff=99 " keep the cursor in the middle of the window
set sessionoptions=buffers,curdir,folds,help,options,tabpages,winpos,winsize
" set shell is above in Windows/GUI section
set shiftwidth=2 " Spaces for each autoindent
set shortmess=inxtToOs " Close to default; better treatment of long messages
set showbreak=\\  " Show wrapped lines with backwards solidus
set showcmd     " Display incomplete commands
set showmatch   " Briefly jumps and shows matched { } ( ) [ ] when visible
set showmode    " Show the mode you are in with --- INSERT --- et al.
silent execute version < 900 ? '' : 'set showtabline=1' | " use airline in v8
set sidescroll=2 " Just keep moving 1 char off the screen to the right
set smarttab    " Inserts shiftwidth spaces at start of line
set softtabstop=0 " Mix of tabs and spaces ... nah, just confusing
set splitbelow  " Split below rather than above
set startofline " Move to the first non-blank on the line after gg, d, etc.
" set statusline is obviously not a one line entry!
" set tabline is under development and includes guitablabel
set tabstop=8   " Explicit [default] number of spaces a tab equates to
" set thesaurus is above in Windows/GUI section
set tildeop     " Makes ~ for changing case work w/ an operator v just a char
set timeout     " Wait for mapping or key sequences
set title       " Ensures filename [+=-] (path) - VIM in the titlestring
set ttimeout    " time out on key codes, though superfluous with timeout 'on'
set ttimeoutlen=100 " wait up to 100ms after Esc for special key
set viewdir=$HOME/vimfiles/view " Dir to save views (prevents rw errors)
set viminfo='100,<9999,s1000,h,rA:,rB:,r/tmp " viminfo file settings
set virtualedit= " Default the virtual edit setting (but <leader>v below!)
set whichwrap=b,s,h,l,>,<,~,],[ " Allow <Left>, etc., to wrap, all modes allowed
set wildignorecase " ignore case when completing file names and directories
set wildmenu    " display completion matches in a status line
set winheight=3 " Minimum number of lines in current window
set winminheight=3 " Minimum number of lines in each window
" -- Explanation of tabs because they are confusing in the help --
" Do not change 'tabstop' from its default value of 8 - there is good guidance
" out there for why not to mess with tabstop=8).  With 'expandtab' the tab key
" will always insert spaces whereas with noexpandtab (the default, i.e., et=0)
" tabs will be inserted once a threshold of spaces is entered, e.g., at the
" fourth tab when softtabstop is set to 2.  To enter an actual tab, use
" CTRL-V<Tab>, which I have mapped, in Insert mode, to Shift-Tab, which is a
" very easy way of ensuring an actual Tab character can be input but otherwise
" spaces are used.
" -- Non-local off/defaults -- {{{2
" allowrevins; ambiwidth; autochdir; autoshelldir;
" autoread; autowrite; autowriteall; background; backup; backupcopy;
" backupdir; backupext; backupskip; balloon*; breakat; browsedir; casemap;
" cd*; cedit; charconvert; columns; compatible; confirm; cpoptions;
" cryptmethod; cscope*; debug; define; delcombine; dictionary; diff*;
" digraph; directory; eadirection; edcompatible; emoji; equalalways;
" equalprg; errorbells; errorfile; errorformat; esckeys; eventignore; exrc;
" fileencodings; fileformats; fileignorecase; fillchars; foldopen; formatprg;
" fsync; gdefault; grepformat; grepprg; helpfile; helplang; highlight; hkmap;
" hkmapp; icon; iconstring; ignorecase; im*; include*; indentexpr; insertmode;
" isfname; isident; isprint; joinspaces; lang*; lazyredraw; linespace; lisp*;
" loadplugins; luadll; magic; make*; matchtime; maxcombine; maxfuncdepth;
" maxmapdepth; maxme*; menuitems; mkspellmem; modelin*; more; mousemodel;
" mousemoveevent; mouseshape; mousetime; mz*; opendevice; packpath; paragraphs;
" paste; pastetoggle; patchexpr; patchmode; path; perldll; previewheight;
" previewpopup; printdevice; printencoding; printexpr; printmb*; prompt;
" py*; quickfixtextfunc; redrawtime; regexpengine; remap; report; scroll;
" restorescreen; revins; rightlef*; rubydll; rule*; runtimepath; scroll*;
" sections; secure; selection; selectmode; shell?*; shiftround; shortname;
" showbreak; showfulltag; sidescrolloff; smartcase; smartindent;
" spellsuggest; splitright; suffix*; swap*; switchbuf; synmaxcol;
" tabpagemax; tag*; tcldlll; term*; terse; thesaurusfunc; timeoutlen;
" titlestring; titlelen; titleold; toolba*; tty*; undo*; update*; verbos*;
" viewoptions; viminfofile; visualbell; warn; weirdinvert; wildcha*;
" wildignore; wildmode; wildoptions; winaltkeys; window; winheight;
" winminwidth; winptydll; wrapscan; write; writebackup; writedelay; xtermcodes
" 2}}}
" }}}
" 04 Commands {{{
"
" -- COMMAND Cbum — creates a popup menu of the output of a command
" Mapped with <leader>b and <leader><shift>b below, i.e., create a popup
" menu for 8 seconds that displays the current buffers (and which can be
" used to select the buffer wanted and open it in a new split).
command! -nargs=1 -complete=command Cbum redir @x |
            \ silent execute <q-args> | redir END |
            \ let @y = substitute(strtrans(@x),'\^@','|','g') |
            \ let g:lr = split(@y, "|") |
            \ if len(g:lr) == 1 |
            \   let winid = popup_menu(g:lr, #{time: 8000}) |
            \ else |
            \   let winid = popup_menu(g:lr, #{ callback: {id, result ->
                  \ execute("if " .. result .. " > 0 | sbuffer " ..
                  \ str2nr(split(g:lr[result-1])[0]) .. " | endif" ..
                  \ " | if &buftype=='help' | set nolist | endif", "") } }) |
            \ endif
"
" -- COMMAND Cpop — creates a popup of the output of a command
" For example, the command :Cpop ls! would be a synonym for the
" remapped <leader>b below, i.e., create a popup for 8 seconds that
" displays the current buffers (and which can be clicked to hide).
command! -nargs=+ -complete=command Cpop redir @x |
            \ silent execute <q-args> | redir END |
            \ let @y = substitute(strtrans(@x),'\^@','|','g') |
            \ let g:lr = split(@y, "|") |
            \ let winid = popup_menu(lr, #{time: 8000})
"
" -- COMMAND DiffOrig — displays a diff between the buffer and the file loaded
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit #
    \ | 0d_ | diffthis | wincmd p | diffthis
endif
"
" -- COMMAND Rp — redirects outputs of a command to the p register
" This means, for example, :Rp filter /S[duh]/ command
" will put the output of that command to the p register. Then all you need
" to do is "pp to put the contents of that register p to the buffer
" in Normal mode
command! -nargs=+ -complete=command Rp redir @p | silent execute <q-args> | redir END
" }}}
" 05 Functions {{{
"
" NB : the recommendation to add 'abort' after each so that
" if something goes wrong Vim will not try to run the whole function, as
" recommended by the Reddit vimrctips.
"
" -- FUNCTION CustomCursorBLOCK — Cursor shape setting (XFCE only)
function! CustomCursorBLOCK() abort
  if isdirectory('~/.config/xfce4')
    if filewritable('~/.config/xfce4/terminal/terminalrc')
        silent execute "!sed -i.bak -e 's/TERMINAL_CURSOR_SHAPE_IBEAM/TERMINAL_CURSOR_SHAPE_BLOCK/' ~/.config/xfce4/terminal/terminalrc"
    endif
  endif
  set nocursorline
endfunction
"
" -- FUNCTION CustomCursorIBEAM — Cursor shape setting (XFCE only)
function! CustomCursorIBEAM() abort
  if isdirectory('~/.config/xfce4')
    if filewritable('~/.config/xfce4/terminal/terminalrc')
      silent execute "!sed -i.bak -e 's/TERMINAL_CURSOR_SHAPE_BLOCK/TERMINAL_CURSOR_SHAPE_IBEAM/' ~/.config/xfce4/terminal/terminalrc"
    endif
  endif
  set cursorline
endfunction
"
" -- FUNCTION CycleVirtualEdit — Cycle virtualedit settings from "all" to ""
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
  else " One of: empty, none or NONE - synonymns - NB: none/NONE are only vim9
      set virtualedit=all
      echo 'virtualedit=all'
  endif
endfunction
"
" -- FUNCTION GenerateUnicode(160,0xA1) — Puts table of Unicode characters
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
"
" -- FUNCTION Fpopmode ― Makes a popup notification with just the current mode
function! Fpopmode() abort
  let winid = popup_notification(mode(1),#{time: 1000})
  return ''
endfunction
"
" -- FUNCTION FwindowWrapToggle ― toggles wrap and nowrap for the current window
function! FwindowWrapToggle() abort
  if &wrap==0
    set wrap
  else
    set nowrap
  endif
  return ''
endfunction
"
" -- FUNCTION NextBuffer — Next/Prior buffer in the current window
function! NextBuffer(incr) abort
  let current = bufnr("%")
  let last = bufnr("$")
  let new = current + a:incr
  while 1
    if new != 0 && bufexists(new)
      execute ":buffer ".new
      if &buftype == 'help'
        set nolist
      endif
      break
    else
      let new = new + a:incr
      if new < 1
        let new = last
      elseif new > last
        let new = 1
      endif
      if new == current
        break
      endif
    endif
  endwhile
endfunction
"
" -- FUNCTION ToggleComment — Commenting code easily
" Modified from a stackoverflow source (1676632). Could use vim-commentary?
let s:comment_map = {"python": '#', "sh": '#', "bat": 'REM', "vbs": "'",
    \   "omnimark": ";", "vim": '"'}
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
"
" -- FUNCTION ToggleLineNumber — Literal / relative / no line number toggling
function! ToggleLineNumber() abort
  if !&number
    set number
    set norelativenumber
  elseif &number && !&relativenumber
    set relativenumber
  elseif &number && &relativenumber
    set nonumber
    set norelativenumber
  endif
endfunction
" }}}
" 06 Mappings {{{
" Using silent execute enables a | to add a comment :)
" nmap — Normal mode mappings
silent execute 'nnoremap <Space> <Nop>' | " Remap space to nothing so that it
let mapleader = ' '                       " can be remaped to leader in Normal
silent execute 'nnoremap <C-K> i<C-K>' | " Enter :digraphs from Normal mode too
silent execute 'nnoremap <C-L> :nohl<CR><C-L>' | " Redraw screen AND h/l off
silent execute 'nnoremap <C-S> :%sm_x_y_gc<C-Left><Right><Right>' | " CTRL-S
nnoremap <silent> <Tab> :call NextBuffer(1)<CR>
nnoremap <silent> <S-Tab> :call NextBuffer(-1)<CR>

" xmap — Visual mode mappings
silent execute 'xnoremap <C-S> :sm_x_y_gc<S-Left>' | " CTRL-S 'template' :%sm
xnoremap <silent> <leader>l :call ToggleLineNumber()<CR>gv
" From the help, add quotes around the visual selection (w/in line) g@ object
xnoremap <F8> <Cmd>set operatorfunc='{t ->getline(".")
  \ ->split("\\zs") ->insert("\"", col("'']")) ->insert("\"", col("''[") - 1)
  \ ->join("") ->setline(".")}'<CR>g@

" map — Normal, Visual, and Operator Pending modes mappings
noremap <leader>v :call CycleVirtualEdit()<CR>
noremap <leader>w :call FwindowWrapToggle()<CR>
noremap <leader>i :exe "set colorcolumn=80 \| set textwidth=79"<CR>
noremap <leader>I :exe "set colorcolumn=0 \| set textwidth=0"<CR>
noremap <silent> <leader>l :call ToggleLineNumber()<CR>
noremap <silent> <leader>c :call ToggleComment()<cr>
noremap <silent><leader>b :Cbum buffers<cr>
noremap <silent><leader><S-b> :Cbum buffers!<cr>

" imap — Insert mode mappings
silent execute 'inoremap <C-U> <C-G>u<C-U>' | " Bram recommended undo atom
silent execute 'inoremap <S-Tab> <C-V><Tab>' | " Enter a 	 with <S-Tab>

" *map — mappings in all/many modes grouped for common sense
" <F9> for a mongo toggle to : and Normal mode from anywhere
" Remapping of the 'arrow' keys is a common practice, e.g., inoremap jk <Esc>
" but the delay is just annoying IMHO. A better approach is setting a specific
" mapping to <C-\><C-N>, the equivalent to escape, from a Function key. Since,
" F8 is a very comfortable key, being Lower with the left thumb and index
" finger on V, that works really well.
"     (NB: Remapping Esc itself has unwanted side effects: don't do that!)
" So, <F9> is mapped in Normal, Insert, Visual, Op. Pending, and Terminal
" modes to go straight to Command mode.  But, then also Command mode with
" <F9> goes to Normal mode. The overall result is that <F9> works like a
" mongo toggle between Normal and Command modes, as well as going there
" from all the other modes, with the exception of Terminal-Normal, where it
" needs to be exited first. (refer :h map-table for all combinations)
" Combined with belloff (turning the bell off, refer above)
" the annoying bell when <ESC> is pressed in Normal mode is also deactivated.
nnoremap <F9> <Esc>:
inoremap <F9> <C-\><C-N>:
vnoremap <F9> <C-\><C-N>:
onoremap <F9> <C-\><C-N>:
cnoremap <F9> <Esc>
tnoremap <F9> <C-W>c:

" gk and gj for Up and Down screenwise
" Up-down motions default behaviour and comments
"   Normal mode - j/k operate linewise
"               - <Up>/<Down> operate linewise
"   Insert mode - <Up>/<Down> operate linewise
" Mapping <C-Up> and <C-Down> in Normal mode makes sense because in Normal
" mode, e.g., j, <Down> and <C-Down> are synonyms and so that is inefficient.
" So, the 'solution' to enable screen-wise motion in Normal mode is to map:
nnoremap <C-Up> gk
" and
nnoremap <C-Down> gj
" There is no 'clean' way for making Insert mode work in the same manner.
" That is because the means of moving a visual line is to use <C-O> to
" make one Normal mode command.  That has a few side effects when the
" statusline refreshes to account for the change in mode (i.e., from i
" to niI to i) as well as (oddly) creating a new buffer momentarily.
" Nonetheless, it is still worth providing the option for the times that there
" are wrapped lines.  It also pays to add it for Visual/Select mode too:
inoremap <C-Down> <C-O>gj
inoremap <C-Up> <C-O>gk
vnoremap <C-Down> gj
vnoremap <C-Up> gk
" Note that with the 40% keyboard this is gold because the Down, Up are
" I turned these off because it makes the statusline jump too much and when
" in insert mode the functionality is not so bad anyhow.
" }}}
" 07 Autocommands {{{
" vimStartup {{{2
augroup vimStartup
  autocmd!
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid, when inside an event handler
  " (happens when dropping a file on gvim) and for a commit message (it's
  " likely a different one than last time).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif
augroup END " 2}}}
" xfce {{{2
augroup xfce
  autocmd!
  autocmd InsertEnter * call CustomCursorIBEAM()
  autocmd InsertLeave * call CustomCursorBLOCK()
  autocmd VimEnter * call CustomCursorBLOCK()
  autocmd VimLeave * call CustomCursorIBEAM()
augroup END " 2}}}
" skeletons (templates) {{{2
augroup skeletons
  autocmd!
  if filereadable(expand('~/vimfiles/skeleton.asciidoc'))
    autocmd BufNewFile *.asciidoc 0r ~/vimfiles/skeleton.asciidoc
  endif
  if filereadable(expand('~/vimfiles/skeleton.txt'))
    autocmd BufNewFile *.txt 0r ~/vimfiles/skeleton.txt
  endif
augroup END " 2}}}
" colorschemes {{{2
if v:version > 899
  augroup colours " This was added only to test vim-tene
    autocmd!
    autocmd ColorScheme gruvbox {
        g:tene_hi = exists("g:tene_hi") ? g:tene_hi : {}
        g:tene_hi['o'] = 'DiffDelete'
        g:tene_hi['i'] = 'IncSearch'
        g:tene_hi['r'] = 'DiffText'
        g:tene_hi['v'] = 'DiffChange'
        hi tene_x gui=italic guifg=#dadada guibg=#d5c4a1
        g:tene_hi['x'] = 'tene_x'
      }
  augroup END
endif " 2}}}
" cursorline always on in Normal mode and Insert modes {{{2
augroup cursorline
  autocmd!
  autocmd InsertLeave * set cursorlineopt=number | let &cursorline = 1
  autocmd InsertEnter * set cursorlineopt=line,number | let &cursorline = 1
augroup END " 2}}}
" }}}
" 08 Plugins {{{
" I am now using the inbuilt Vim plugin handling.
" * Plugins path: $HOME/.vim/pack/plugins  $HOME\vimfiles\pack\plugins
" * To determine the remote git repository: git remote show origin
" Plugins in use (20230225):
"   https://github.com/habamax/vim-asciidoctor.git
"   https://github.com/kennypete/vim-sents.git (my own vim9script plugin)
"   https://github.com/kennypete/vim-characterize.git (a fork, incl. my tools)
"   ADD kennypete/vim-tene.git here once I put it into github!!!!!!!!!
" -----------------------------------------------------
" Statusline - vim-tene with Vim9 and airline with Vim8
" -----------------------------------------------------
"For testing colorschemes with vim-tene:
"set bg=dark
"set bg=light
"colorscheme gruvbox
try
  let g:tene_ga = exists("g:tene_ga") ? g:tene_ga : {}
  let g:tene_ga["line()"] = ['¶', ''] " Use pilcrow for line numbers ASCII
  let g:tene_hi = exists("g:tene_hi") ? g:tene_hi : {}
  if has("gui_running")
    let g:tene_hi['x'] = 'Conceal' " Override for Inactive statuslines
  endif
  let g:tene_modes = exists("g:tene_modes") ? g:tene_modes : {}
  let g:tene_modes["c"] = "CMDLINE" " Override for COMMAND-LINE
  let g:tene_modestate = 1 " Always show the state(), not just mode(1)
  let g:tene_nowarn = 1 " No warning with Vim 8
  packadd! vim-tene
catch " But, if vim-tene is unavailable or fails, create a basic statusline
  set statusline=\ %-6.(%{mode(1)..'\ '..state()}%)\ b%n%<\ %t\ %m\ %r\ %h%=%y
  set statusline+=\ %{&fileencoding}\ %{&fileformat}
  set statusline+=\ %{'¶'..line('.')..'/'..line('$')}\ \|
  set statusline+=%{virtcol('.')}\ U+%B\ 
endtry
" }}}
" 09 Syntax + filetype {{{
syntax enable " syntax h/l; could be 'on' and/or test for t_Co/has('syntax')
filetype plugin indent on " Refer :filetype-overview  Current status :filetype
"}}}
" 88 Deleted {{{
" (notes to more material deletions and .vimrc history)
" VIM MODES ***********************************************************
" Mode information: the table that was included as a comment has been removed.
" Just gx this https://github.com/kennypete/asciidoc/blob/main/vim.asciidoc
" Also gx https://rawgit.com/darcyparker/1886716/raw/vimModeStateDiagram.svg
" PYMODE **************************************************************
" Deleted plugin: Pymode.  I was not using this enough.  If the old setup is
" wanted for whatever reason, the setup as at 6/7/2022 is at:
" https://github.com/kennypete/.vimrc/blob/86db077d1039a4cd43b5d67f050bca1f4f2e8a91/_vimrc
" }}}
" 99 Development {{{
" Tabline?
" set tabline=
" for i in range(tabpagenr('$'))
  " if i + 1 == tabpagenr()
    " set tabline+='%#TabLineSel#'
  " else
    " set tabline+='%#TabLine#'
  " endif
  " set tabline+=%{'%'..(i+1)..'T'}
  " set tabline+='\ '
  " set tabline+=%{%bufname(tabpagewinnr(1))%}
" endfor
" set tabline+='%#TabLineFill#'
" #set tabline+='%T'
" if tabpagenr('$') > 1
  " set tabline+='%=%#TabLine#%999Xclose'
" endif
" }}}
"set tabline=%{%join(tabpagebuflist('%'),'\ ˙\ ')..' %t'%}
" vim: textwidth=79 foldmethod=marker filetype=vim expandtab
