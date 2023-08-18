" .vimrc _vimrc - vim9mix - refer :h vim9mix
if (v:version < 802 || (v:version == 802 && !has('patch3434')))
  " -------------------------------------------------------------------------
  " If the version is before 8.2.3434 use vimscripts _vimrc8 and _gvimrc8
  " rather than this vim9script .vimrc/_vimrc (and .gvimrc/_gvimrc)
  " A few things do not work with versions 8.2.3434 and 9.0.1677 - those are
  " handed inline, e.g., in the 'fillchars' option, item lastline
  try
    " -----------------------------------------------------------------------
    " Use :source as this works whereas :runtime does not (in this instance)
    " -----------------------------------------------------------------------
    source $HOME/_vimrc8
    if has("gui_running")
      source $HOME/_gvimrc8
    endif
  catch
    echom "Failed sourcing _vimrc8 / _gvimrc8"
  endtry
  finish
endif
vim9script
# 01 Windows, WSL specific options {{{
# Windows, instead of '~/.vimrc', has '~\_vimrc'.
# Gvim: using a .gvimrc / _gvimrc, despite being two separate files,
# is the recommended approach.  It is particularly useful for separating
# GUI-only things, like customising the GUI Toolbar.
#
# Prevent startup in Replace mode in WSL (no impact native Linux/Win32)
set t_u7=
if (has("Win32") || has("Win64")) && !has("gui_running")
  # No GUI, but Windows = console Vim; a more distinct Replace mode cursor
  # Only partially works in console Win32, but use it nonetheless (guicursor)
  set guicursor=n-v-c-sm:block,o-r-cr:hor50,i-ci:hor25
  set lines=28
  # Keep cmd.exe as the default terminal in Windows (and you can
  # use "powershell" from the terminal to start powershell anyhow)
endif
# Mini thesaurus: use if present
if has("Win32") || has("Win64")
  if filereadable($HOME .. '\vimfiles\mini-thesaurus.txt')
    set thesaurus=$HOME\vimfiles\mini-thesaurus.txt
  endif
else
  if filereadable($HOME .. '/.vim/mini-thesaurus.txt')
    set thesaurus=$HOME/.vim/mini-thesaurus.txt
  endif
endif
# Create the view directory if it doesn't exist
# Setting option 'viewdir' defaults used here
if has("Win32") || has("Win64")
  if !isdirectory(expand($HOME .. '\vimfiles\view'))
    silent! call mkdir($HOME .. '\vimfiles\view', 'p')
  endif
else
  if !isdirectory(expand($HOME .. '/.vim/view'))
    silent! call mkdir($HOME .. '/.vim/view', 'p')
  endif
endif
# }}}
# 02 Highlights {{{
# There are not a lot of .vimrc highlights because I accept defaults for many
# things.  The ones here are for just a few key highlights like the line
# numbers and the current line number, non-printing wrap characters, and
# non-printing special characters, which are highlighted so that they are
# more obvious when editing documents.  These are in an autocmd group too,
# so that they re-set if a colorscheme is called, and early in the .vimrc
# to ensure it is called if a colorscheme is.
# ----------------------------------------------------------------------------
# NB: This is set for my setup in Windows Vim (non-GUI).  It needs to be
#     optimised for Debian 12, WSL, and Vim from PowerShell?
# Screen column indicator
highlight ColorColumn ctermbg=DarkBlue
# Just the current (cursor's) line number indicator - makes it more distinct
highlight CursorLineNr ctermfg=White cterm=bold
# The colour of the line numbers
highlight LineNr ctermfg=DarkGrey
# The showmode message's colour (e.g., -- INSERT --)
highlight ModeMsg ctermfg=LightGrey cterm=bold
# Colour of 'showbreak' and other non-text characters
highlight NonText ctermfg=DarkGrey
# Colour of the 'list' characters like Tab
highlight SpecialKey ctermfg=Grey
# Define the autocmd for when a colorscheme is changed
augroup MyColours
  autocmd!
  autocmd ColorScheme * ColorSchemeChanged()
augroup END
# Function to handle the ColorSchemeChange event - this sets the highlights
# above and in the .gvimrc / _gvimrc back to what I want them to be again,
# regardless of what colorscheme is chosen.
def ColorSchemeChanged()
  if has("gui_running")
    highlight ColorColumn guibg=LightGrey
    highlight CursorLineNr guifg=DarkGrey gui=bold
    highlight LineNr guifg=Grey
    highlight ModeMsg guifg=DarkGrey gui=bold
    highlight NonText guifg=LightGrey guibg=White
    highlight SpecialKey guibg=LightGrey guifg=White
  elseif !has("gui_running")
    highlight ColorColumn ctermbg=DarkBlue
    highlight CursorLineNr ctermfg=White cterm=bold
    highlight LineNr ctermfg=DarkGrey
    highlight ModeMsg ctermfg=LightGrey cterm=bold
    highlight NonText ctermfg=DarkGrey
    highlight SpecialKey ctermfg=Grey
  elseif has("unix") && !has("gui_running")
    # nothing for now - I think these were for Debian 11 native, GUI perhaps?
    # highlight CursorLineNr guifg=DarkGrey cterm=bold ctermfg=15
    # highlight LineNr guifg=Grey ctermfg=8
    # highlight NonText ctermfg=238 guifg=#d0d0d0
    # highlight SpecialKey ctermfg=Grey guibg=Grey guifg=White
    # highlight ModeMsg ctermfg=252 cterm=bold gui=bold guifg=Grey
  else
    # Default behavior otherwise
  endif
enddef
# }}}
# 03 Settings (global) {{{
# Vim can be run with "-u NONE" if you do not want to load a vimrc.
# Individual settings can be reverted with ":set {option}&" in most cases, so
# for example, ":set colorcolumn&" will remove the column indicator (if set).
# For global settings that are not set here, and are therefore defaults, refer
# the end of this section.
#   autochdir  Change current working dir to the current window's buffer's dir
set autochdir
#   backspace  Allow backspacing everywhere in Insert mode
set backspace=indent,eol,start
#   belloff  Turn off that annoying bell!  Rationale for "off" settings:
#            backspace	Why give a warning bell for an unallowed <BS>/<Del>?
#            cursor	Failing Insert mode cursor/<Up> etc.: why bell those?
#            error	"Other" errors - e.g., navigating below history end.
#            esc	Why give a warning bell for <Esc> in Normal mode?
#            insertmode	Mostly n/a as who uses 'insertmode' option anyway!
#            insertmode	Mostly n/a as who uses 'insertmode' option anyway!
set belloff=backspace,cursor,error,esc,insertmode,showmatch
#   browsedir  If applicable, incl. Win32, browse the _buffer's_ directory
set browsedir=buffer
#   cdhome  :cd, etc., changes current working directory to $HOME, like Linux
set cdhome
#   clipboard  Puts Visual mode selected text into selection register "*
set clipboard=autoselect
#   cmdheight  Makes its height two lines; avoid lots of "press <Enter> to..."
set cmdheight=2
#   cmdwinheight  Cmd-line window (q: or :<C-f>) height: +2 more than default
set cmdwinheight=9
#   colorcolumn  Highlighted column after 'textwidth'; see <leader>I below
set colorcolumn=+1
#   columns  This is set for the GUI in gvimrc.  Else, let terminal determine
#   compatible  Set by many people, but it's unnecessary when there is a
#               vimrc, noting 'compatible' says:
#               	"When a vimrc or gvimrc file is found while Vim is
#               	 starting up, this option is switched off, and all
#               	 options that have not been modified will be set to
#               	 the Vim defaults.  Effectively, this means that when
#               	 a vimrc or gvimrc file exists, Vim will use the Vim
#               	 defaults...."  Also refer :h compatible-default
#   completeopt  Use menuone and noinsert in addition to the default
set completeopt=menu,menuone,preview,noinsert
#   cpoptions  This sets desired Vi 'compatible' option "flags"
#              Flags added: n	Make wrapped lines appear in 'number' column
#                           q	:h cpo-q - Joining 3+ lines cursor pos option
#              Defaults:
#                Vim	aABceFs
#                Vi	aAbBcCdDeEfFgHiIjJkKlLmMnoOpPqrRsStuvwWxXyZ$!%*-+<>;
#              Incidental:
#              1. B, but no b, are Vim defaults.  But it's better using ^V
#                 Refer :h map_bar - it is the most versatile.
#              2. An autocommand could be used to re-add nq, but they're not
#                 a big deal.  So, I'm okay with it reverting to the Vim
#                 defaults if ":set compatible" does occur, and "set nocp"
#                 sets it back to not compatible again, less the nq.
set cpoptions+=nq
#   cursorline  Highlights all, or just the number, of the cursor's line
set cursorline
#   cursorlineopt  Highlight just the number, not the whole line - all modes
set cursorlineopt=number
#   delcombine  Using x, <BS>, etc., only deletes combining char in, e.g., a̅
set delcombine
#   display  Show @@@ at start of last buffer line if last para is truncated
set display=truncate
#   encoding  Character encoding used inside Vim itself, not files
set encoding=utf-8
#   expandtab  Uses n spaces to insert a <Tab>
set expandtab
#   fileformats  New buffers' <EOL> is <NL> (linefeed, U+000A) not <CR><NL>
set fileformats=unix,dos
#   fillchars  I prefer more distinctive characters for folds + the vsplit bar
set fillchars=vert:⏽,fold:-,eob:~,foldopen:┏,foldsep:│,foldclose:╋
    # And add lastline if the version is >=9 with patch 0656
    if v:versionlong >= 9000656
      set fillchars+=lastline:@
    endif
#   foldclose  Automatically close folds when moving out of them
set foldclose=all
#   foldcolumn  Show folds in a single column
set foldcolumn=1
#   foldlevelstart Start editing with all folds closed
set foldlevelstart=0
# set gui* options are in my .gvimrc / _gvimrc
#   helpheight  Minimum initial height for :h when it opens in a window
set helpheight=13
#   hidden  Hide buffers when they are abandoned
set hidden
#   history  Keep max lines of command line history (default is only 50)
set history=5000
#   hlsearch  Highlight searches (see nnoremap <C-L> also, below)
set hlsearch
#   incsearch  Show search patten matches typing; requires has('reltime')
set incsearch
#   keymodel  Makes <S-PageUp>, <Right>, etc., select text + Visual
set keymodel=startsel
#   keywordprg  Program used for K (jumps to :h {word} - i.e., uses Vim help!)
set keywordprg=:help
#     langremap (no)  Prevent it - may not be needed? - follows defaults.vim
set nolangremap
#   laststatus  Always display statusline, even if when only one window
set laststatus=2
# set lines is above in Windows/GUI section (number of lines when opening Vim)
#   list  Shows <Tab>, <EOL>, etc., visually: see listchars for which ones
set list
#   listchars  Highlight them, and character(s) used for U+00A0, U+0009, et al
set listchars=nbsp:°,trail:·,tab:——►,eol:¶
#   matchpairs  Pairs highlighted vimSetEqual when a start/end one is selected
set matchpairs=(:),{:},[:],“:”,‘:’
#   maxcombine  Set to maximum combining; e.g., किँ is U+0915,U+093F,U+0901
set maxcombine=6
#   mouse  Enable the mouse in all modes
silent execute has('mouse') ? 'set mouse=ar' : ''
#   nomousefocus  Do not change the window focus when pointer is moved over it
silent execute has('mouse') ? 'set nomousefocus' : ''
#   nomousehide  Don't hide mouse's cursor when something's typed (Silly, IMO)
silent execute has('mouse') ? 'set nomousehide' : ''
#   numberwidth  Default to 3, but use SetNumberWidth() function and au to alt
set numberwidth=3
# set operatorfunc  This defined in xnoremap <F8>, below
#   printfont  This prints optimally on my HP LaserJet Pro M148
set printfont=FiraCode_NFM:h9
#   printheader  My custom header, incl. lines and page number
set printheader=%<%F %h %m (%L lines)%=Page %N
#   printoptions  Prints line numbers
set printoptions=number:y
#   pumheight  Limit the popup menu length for Insert mode completion
set pumheight=9
#   pumwidth  Increase the characters width for popup menu items
set pumwidth=18
# set renderoptions is in _gvimrc (needs GUI, Windows, _and_ DIRECTX)
#   report  Report the # of lines changed _always_, not only when >2 (default)
set report=0
# set ruler, rulerformat = n/a: I use a statusline, vim-tene - refer :h ruler
#   scrolloff  Keep a few lines above cursor; 99 has it in the window's middle
set scrolloff=2
#   sessionoptions  Self-evident things that get saved with :mksession
set sessionoptions=buffers,curdir,globals,folds,help,options,tabpages,winsize
# set shell  Keep defaults.  If in Windows use PowerShell if wanted _in cmd_
#   shiftwidth  Number of spaces for each autoindent/tab press
set shiftwidth=2
#   shortmess  Close to default (filnxtToOS) treatment of short messages
set shortmess=inxtToOs
#   showbreak  Indicate wrapped lines with U+21AA (Rightwards Arrow with Hook)
set showbreak=↪
#   showcmd  Display incomplete commands (a setting per defaults.vim)
set showcmd
#   showmatch  Briefly jumps and shows matched { } ( ) [ ] when visible
set showmatch
#   showmode  Show the mode you are in with -- INSERT -- et al.
set showmode
#   showtabline  Show tab page labels if there are >1 tabs
set showtabline=1
#   sidescroll  Just keep scrolling one character off the screen horizontally
set sidescroll=1
#   sidescrolloff Keep two characters to the right when scrolling horizontally
set sidescrolloff=2
#   smarttab  Inserts shiftwidth spaces at start of line when <Tab> is pressed
set smarttab
#   smoothscroll  Scrolling works w/ screen lines.  (It works earlier but...)
if v:versionlong >= 9001677
  set smoothscroll
endif
#   softtabstop  No tabs+spaces!  Use <C-v><Tab> for 	.  (Local; global-ish)
set softtabstop=0
#   splitbelow  New split goes below rather than above (personal preference)
set splitbelow
#   startofline  Move not just to first non-blank on a line after G, M, etc.
set nostartofline
# set statusline  Not a one line entry!  I use my own vim-tene plugin
#   synmaxcol  Increase max. search cols.  (Local, but acts global/default?)
set synmaxcol=9999
# set tabline  Under development.  Refer _gvimrc for guitablabel too
#   tabstop  Explicit [default is 8, so n/c] number of spaces a U+0009 is
set tabstop=8
# set thesaurus  This is set above in the Windows/WSL section
#   tildeop  Makes ~ when changing case behave like an operator, e.g., 4~h
set tildeop
#   timeout  Wait 1500ms for :mappings 150ms for key code sequence completion
set timeout timeoutlen=1500 ttimeoutlen=150
#   title  Ensures titlestring appears as the title of the current window
set title
#   titlelen  Percentage of the columns to use for the title - almost to max
set titlelen=95
#   titlestring  The title of the window (gvim, vim), tab (PowerShell), etc.
set titlestring=%{expand(\"%:t\")}%{&modified&&&buftype!='terminal'?',+':''}
\%{&readonly?',RO':''}%{(!&modifiable&&mode()!=#'t')?',-':''}
\%{&buftype=='help'?',HLP':''}\ (%{fnamemodify(expand('%:p'),':h')}) 
# set viewdir is done in 01, using the defaults for Win32/64, Unix
#   viewoptions  Adding unix <NL> and slash (/ not \), as is recommended
set viewoptions+=unix,slash
#   viminfo  file settings - refer :h 'viminfo'
set viminfo='100,<9999,s1000,h,rA:,rB:,r/tmp
#   virtualedit  Default the virtual edit setting (_but_ see <Leader>v below!)
set virtualedit=
#   whichwrap  Allow <Left>, etc., to wrap, all modes; only h + l are excepted
set whichwrap=b,s,>,<,~,],[
#   wildignorecase  Ignore case completing wild file names and directories
set wildignorecase
#   wildmenu  Display completion matches for things like :colorscheme <Tab>
set wildmenu
#   wildoptions  Use a popup menu for wildmenu lists, which is nicer (IMO)
set wildoptions=pum
#   winheight  Minimal number of lines for the current window
set winheight=3
#   winminheight  Minimum number of lines for non-current windows
set winminheight=3
# -- Explanation of tabs because they are confusing in the help --
# Do not change 'tabstop' from its default value of 8 - there is good guidance
# out there for why not to mess with tabstop=8).  With 'expandtab' the tab key
# will always insert spaces whereas with noexpandtab (the default, i.e., et=0)
# tabs will be inserted once a threshold of spaces is entered, e.g., at the
# fourth tab when softtabstop is set to 2.  To enter an actual tab, use
# <C-v><Tab>, which I have mapped, in Insert mode, to Shift-Tab, which is a
# very easy way of ensuring an actual Tab character can be input but otherwise
# spaces are used.
# Global settings that have the defaults accepted {{{2
# ----------------------------------------------------------------------------
# Note, some are commented above to make it 100% clear why they have been
# defaulted, so those are not listed here.  Key: (d=deprecated) (r=redundant)
# ----------------------------------------------------------------------------
# aleph; allowrevins; altkeymap (d); ambiwidth; arabicshape; autoshelldir;
# autoread; autowrite; autowriteall; background; backup; backupcopy;
# backupdir; backupext; backupskip; balloon*; bioskey (r); breakat;
# casemap; cdpath; cedit; charconvert; completepopup; confirm; conskey (r);
# cryptmethod; cscop*; debug; define; dictionary; diff*;
# digraph; directory; eadirection; edcompatible; emoji; equalalways;
# equalprg; errorbells; errorf*; esckeys; eventignore; exrc;
# fileencodings; fileignorecase; fkmap (r); foldopen; formatprg; fsync;
# gdefault (d); grepformat; grepprg; helpfile; helplang; highlight; hkma*;
# icon; iconstring; ignorecase; im*; include*; indentexpr; insertmode;
# isfname; isident; isprint; joinspaces; lang*; lazyredraw; linespace; lisp*;
# loadplugins; luadll; magic; make*; matchtime; maxcombine; maxfuncdepth;
# maxmapdepth; maxme*; menuitems; mkspellmem; modelin*; more; mousemo*;
# mouseshape; mousetime; mz*; opendevice; packpath; paragraphs;
# paste; pastetoggle; patchexpr; patchmode; path; perldll; previewheight;
# previewpopup; printdevice; printencoding; printexpr; printmb*; prompt;
# py*; quickfixtextfunc; redrawtime; regexpengine; remap; restorescreen;
# revins; rubydll; rule*; runtimepath; scrollfocus; scrolljump; scrollopt;
# sections; secure; selection; selectmode; shell*; shiftround; shortname;
# showcmdloc; showfulltag; sidescrolloff; smartcase; smartindent;
# spellsuggest; splitkeep; splitright; suffixes; swap*; switchbuf;
# tabpagemax; tag*; tcldlll; term*; terse; text* (r); thesaurusfunc;
# ttimeout; titlelen; titleold; toolba*; tty*; undo*; update*; verbose;
# verbosefile; viminfofile; visualbell; warn; weirdinvert; wildcha*;
# wildignore; wildmode; winaltkeys; window; winheight; winminwidth;
# winptydll; winwidth; wrapscan; write*; writebackup; writedelay; xtermcodes
# 2}}}
# {{{2 Local settings that I want initially (usually)
#   autoindent  This is useful if working with text files.
set autoindent
#   nrformats  Not Octal when applying either CTRL-A (+1) or CTRL-X (-1)
set nrformats=alpha,hex,bin,unsigned
#   number  Display line numbers (on left)
set number
#   nowrap  Prefer to not wrap initially - turn it on if wanted
set nowrap
# 2}}}
# }}}
# 04 Commands {{{
# DiffOrig {{{2
# Displays a diff between the buffer and the file loaded
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit #
  \ | 0d_ | diffthis | wincmd p | diffthis
endif
# 2}}}
# Redirr {{{2
# Redirects outputs of a command to the @p register
# This means, for example, :Redirr filter /S[duh]/ command
# will put the output of that command to the p register.
# Then all you need to do is "pp to put the contents of that
# register p to the buffer in Normal mode
command! -nargs=+ -complete=command Redirr redir @p
      \ | silent execute <q-args>
      \ | redir END
# 2}}}
# B {{{2
# Goes to the first instance of a window of {buffer number} in _any_ tab
command! -nargs=1 -complete=command B
      \ silent execute ':call g:GoToBufferInTab(' .. <f-args> .. ')'
# 2}}}
# Mb and Gb {{{2
# Mark a buffer and go to a buffer (uses :B command, above)
g:mbuf = {}
command! -nargs=1 -complete=command Mb g:mbuf[<q-args>] = bufnr('%')
command! -nargs=1 -complete=command Gb execute ':B ' .. g:mbuf[<q-args>]
# 2}}}
# }}}
# 05 Functions {{{
# Cycle virtualedit local setting {{{2
def FcycleVirtualEdit()
  if &virtualedit == "all"
    set virtualedit=block
  elseif &virtualedit == "block"
    set virtualedit=insert
  elseif &virtualedit == "insert"
    set virtualedit=onemore
  elseif &virtualedit == "onemore"
    set virtualedit=
    # empty, none and NONE are synonymous in vim9
  else
    set virtualedit=all
  endif
enddef
# 2}}}
# Generate Unicode Characters Table {{{2
def FgenerateUnicode(first: number, last: number)
  var i = first
  while i <= last
    @c = printf('%04X ', i) .. '	'
    for j in range(16)
      @c = @c .. ' ' .. nr2char(i)
      i += 1
    endfor
    put c
  endwhile
enddef
# 2}}}
# Go to buffer number in any tab {{{2
def g:GoToBufferInTab(b: number): void
  var c = tabpagenr()
  for t in range(tabpagenr('$'))
    execute ':norm ' .. (t + 1) .. 'gt'
    for w in range(1, winnr('$'))
      if winbufnr(w) == b
        execute ':' .. w .. 'wincmd w'
        return
      endif
    endfor
  endfor
  execute ':norm ' .. c .. 'gt'
  echo "Buffer not found in any window."
enddef
# 2}}}
# Popup mode code {{{2
# Makes a popup notification with the current mode and state - for debugging
def Fpopupmode()
  popup_notification(mode(1) .. state(), {time: 555})
enddef
# 2}}}
# Set numberwidth option by the number of lines in the buffer {{{2
def FsetNumberWidth()
  var num_lines = line('$')
  var new_width = len(num_lines) + 2
  execute 'set numberwidth=' .. new_width
enddef
# 2}}}
# Toggle current window wrapping {{{2
def FwindowWrapToggle()
  if &wrap == v:false
    set wrap
  else
    set nowrap
  endif
enddef
# 2}}}
# Toggle code commenting of selected or current line {{{2
g:comment_map = {"python": '#', "sh": '#', "bat": 'REM', "vbs": "'",
\ "omnimark": ";", "vim": '#'}
def FtoggleComment()
  if has_key(g:comment_map, &filetype)
    var comment_leader = g:comment_map[&filetype]
    if getline('.') =~ "^\\s*" .. comment_leader .. " "
      # Uncomment the line
      execute "silent s/^\\(\\s*\\)" .. comment_leader .. " /\\1/"
    else
      if getline('.') =~ "^\\s*" .. comment_leader
        # Uncomment the line
        execute "silent s/^\\(\\s*\\)" .. comment_leader .. "/\\1/"
      else
        # Comment the line
        execute "silent s/^\\(\\s*\\)/\\1" .. comment_leader .. " /"
      endif
    endif
  else
    echo "No comment leader found for filetype."
  endif
enddef
# 2}}}
# Toggle line numbers - literal > relative > none {{{2
def FtoggleLineNumber()
  if !&number
    set number
    set norelativenumber
  elseif &number && !&relativenumber
    set relativenumber
  elseif &number && &relativenumber
    set nonumber
    set norelativenumber
  endif
enddef
# 2}}}
# Try and catch packadd! a plugin; echo a message if it fails {{{2
def Fpackadd(aplugin: string): void
  try
    # This must use execute, not just packadd! because of passing the arg
    execute "packadd! " .. aplugin
  catch
    echo "Could not load plugin " .. aplugin
  endtry
enddef
# 2}}}
# XFCE cursor shapes {{{2
def FcustomCursorBLOCK()
  if isdirectory('~/.config/xfce4')
    if filewritable('~/.config/xfce4/terminal/terminalrc')
        silent execute "!sed -i.bak -e 's/TERMINAL_CURSOR_SHAPE_IBEAM/TERMINAL_CURSOR_SHAPE_BLOCK/' ~/.config/xfce4/terminal/terminalrc"
    endif
  endif
enddef
def FcustomCursorIBEAM()
  if isdirectory('~/.config/xfce4')
    if filewritable('~/.config/xfce4/terminal/terminalrc')
      silent execute "!sed -i.bak -e 's/TERMINAL_CURSOR_SHAPE_BLOCK/TERMINAL_CURSOR_SHAPE_IBEAM/' ~/.config/xfce4/terminal/terminalrc"
    endif
  endif
enddef
# 2}}}
# }}}
# 06 Mappings {{{
#  <Space> to <Leader> - remapped in Normal mode {{{2
#  Must be set before the mappings that use <Leader>, otherwise <Space> will
#  be literal (i.e., [count] characters to the right)
nnoremap <Space> <Nop>
# Set the <Leader> to be <Space>.  Refer :h mapleader
g:mapleader = ' '
# 2}}}
#  [nore]map — Normal, Visual, Operator Pending modes mappings {{{2
noremap <Leader>v :call FcycleVirtualEdit()<CR>
noremap <Leader>w :call FwindowWrapToggle()<CR>
noremap <silent><Leader>i :exe "set colorcolumn=80 <bar> set textwidth=78"<CR>
noremap <silent><Leader>I :exe "set colorcolumn=0 <bar> set textwidth=0"<CR>
noremap <silent><Leader>l :call FtoggleLineNumber()<CR>
noremap <silent><Leader>c :call FtoggleComment()<CR>
# vim9-popped - noremap <silent><Leader>b :CpopupBuffersMenu buffers<CR>
# vim9-popped - noremap <silent><Leader>b :CpopupBuffersMenu buffers!<CR>
# 2}}}
# n[nore]map — Normal mode only mappings {{{2
# Make entering digraphs from Normal mode easier, using <C-k>
nnoremap <C-K> a<C-K>
# Redraw the screen AND turn search highlighting off with <C-L>
nnoremap <C-L> :nohl<CR><C-L>
# Use <C-S> for a su "template", with very no magic and _ delimiters.
#   (Using silent execute enables a | to add a # Comment, if wanted.)
silent execute 'nnoremap <C-S> :%s_\v__gc<Left><Left><Left>'
# <Tab> to go to the next tab page, <S-Tab> the previous tab page
nnoremap <silent> <Tab> :tabnext<CR>
nnoremap <silent> <S-Tab> :tabprevious<CR>
# <F12> to toggle showing the menu - F12 is Lower-M on my Planck keyboard!
nnoremap <F12> :let &go = &go =~# 'm' ?
\ substitute(&go, 'm', '', '') : &go .. 'm'<CR>
# Other:
# - Toggle 'rendereroptions' needs GUI, Win32/Win64, and DirectX so -> _gvimrc
# - vim-popped plugin mapping, gA, is an omnibus ga/g8/etc. command
# 2}}}
# i[nore]map — Insert mode only mappings {{{2
# Bram recommended undo atom
inoremap <C-U> <C-G>u<C-U>
# Enter a 	 with <S-Tab>
inoremap <S-Tab> <C-V><Tab>
# 2}}}
# x[nore]map — Visual mode only mappings {{{2
# Use <C-S> for a su "template", with very no magic and _ delimiters.
xnoremap <C-S> :%s_\v__gc<Left><Left><Left><Left>
# Add quotes around visual selection (w/in line) g@ obj.  (Modified help e.g.)
xnoremap <F8> <Cmd>let &operatorfunc='{t ->getline(".")
  \ ->split("\\zs") ->insert("\"", col("'']")) ->insert("\"", col("''[") - 1)
  \ ->join("") ->setline(".")}'<CR>g@
# 2}}}
# *[nore]map — <F9> "mongo" escape mapping - all modes {{{2
# These are grouped for common sense!
# <F9> for a mongo toggle between Cmdline and Normal mode from any mode.
# Remapping of the 'arrow' keys is a common practice, e.g., inoremap jk <Esc>
# but the delay is just annoying IMHO. A better approach is setting a specific
# mapping to <C-\><C-N>, the equivalent to escape, from a Function key. Since,
# F9 is a very comfortable key (on my Planck keyboard), being Lower with the
# left thumb and index finger on the V key, so that works perfectly.
#   (NB: Remapping <Esc> itself has unwanted side effects: don't do that!)
# So, <F9> is mapped in Normal, Insert, Visual, Op. Pending, and Terminal
# modes to go straight to Command mode.  But, then also Command mode with
# <F9> goes to Normal mode. The overall result is that <F9> works like a
# mongo toggle between Normal and Command modes, as well as going there
# from all the other modes, with the exception of Terminal-Normal, where it
# needs to be exited first. (refer :h map-table for all combinations)
# Combined with belloff (turning the bell off, refer above)
# the annoying bell when <Esc> is pressed in Normal mode is also deactivated.
nnoremap <F9> <Esc>:
inoremap <F9> <C-\><C-N>:
vnoremap <F9> <C-\><C-N>:
onoremap <F9> <C-\><C-N>:
cnoremap <F9> <Esc>
tnoremap <F9> <C-W>c:
# 2}}}
# *[nore]map — j/k and <Up>/<Down> "mongo" mapping - several modes {{{2
# Here, gk and gj are used for for <Up> and <Down> screenwise.
# Up-down motions default behaviour and comments:
#   Normal mode - j/k operate linewise
#               - <Up>/<Down> operate linewise
#   Insert mode - <Up>/<Down> operate linewise
# Mapping <C-Up> and <C-Down> in Normal mode makes sense because in Normal
# mode, e.g., j, <Down> and <C-Down> are synonyms and so that is inefficient.
# So, the 'solution' to enable screen-wise motion in Normal mode is to map:
nnoremap <C-Up> gk
nnoremap <C-Down> gj
# There is no 'clean' way for making Insert mode work in the same manner.
# That is because the means of moving a visual line is to use <C-O> to
# make one Normal mode command.  That has a few side effects when the
# statusline refreshes to account for the change in mode (i.e., from i
# to niI to i) as well as (oddly) creating a new buffer momentarily.
# Nonetheless, it is still worth providing the option for the times that there
# are wrapped lines.  It also pays to add it for Visual/Select mode too:
inoremap <C-Down> <C-O>gj
inoremap <C-Up> <C-O>gk
vnoremap <C-Down> gj
vnoremap <C-Up> gk
# 2}}}
# }}}
# 07 Autocommands {{{
# augroup MyColours is defined in 02 Highlights
# Normal mode forced when moving to an unmodifiable buffer {{{2
#	https://github.com/vim/vim/issues/12072
augroup forcenormal
  autocmd!
  autocmd BufEnter * execute (!&modifiable && !&insertmode)
        \ ? ':call feedkeys("\<Esc>")' : ''
  autocmd BufEnter * execute (!&modifiable && &insertmode)
        \ ? ':call feedkeys("\<C-L>")' : ''
augroup END
# 2}}}
#       FsetNumberWidth() on entering a buffer {{{2
augroup triggersetnumberwidth
  autocmd!
  autocmd BufEnter * FsetNumberWidth()
augroup END
# 2}}}
#       skeletons (templates) {{{2
augroup skeletons
  autocmd!
  if filereadable(expand('~/vimfiles/skeleton.asciidoc'))
    autocmd BufNewFile *.asciidoc 0r ~/vimfiles/skeleton.asciidoc
  endif
  if filereadable(expand('~/vimfiles/skeleton.txt'))
    autocmd BufNewFile *.txt 0r ~/vimfiles/skeleton.txt
  endif
augroup END # 2}}}
#       vimStartup {{{2
augroup vimStartup
  autocmd!
  # When editing a file, always jump to the last known cursor position.
  # Don't do it when the position is invalid, when inside an event handler
  # (happens when dropping a file on gvim) and for a commit message (it's
  # likely a different one than last time).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif
augroup END
# 2}}}
#       [Suppressed] colorschemes {{{2
# (This was added only to test my vim-tene statusline plugin with gruvbox)
#augroup colours
#  autocmd!
#  autocmd ColorScheme gruvbox {
#      g:tene_hi = exists("g:tene_hi") ? g:tene_hi : {}
#      g:tene_hi['o'] = 'DiffDelete'
#      g:tene_hi['i'] = 'IncSearch'
#      g:tene_hi['r'] = 'DiffText'
#      g:tene_hi['v'] = 'DiffChange'
#    }
#augroup END
# 2}}}
# }}}
# 08 Plugins {{{
# Using the native Vim plugin handling. :h packadd
# * Plugins path:  $HOME/.vim/pack/plugins  $HOME\vimfiles\pack\plugins
# * To determine the remote git repository: git remote show origin
# Plugins.  Currently in use indicated with "Y", orig unless "(specifics)":
# "Y" 	https://github.com/madox2/vim-ai
# "Y" 	https://github.com/kennypete/vim-asciidoctor (habamax fork +)
#     	https://github.com/kennypete/vim-combining2
# "Y" 	https://github.com/kennypete/vim-popped
# "Y" 	https://github.com/kennypete/vim-sents
# "Y" 	https://github.com/kennypete/vim-characterize (tpope fork +)
# "Y" 	https://github.com/kennypete/vim-tene
# vim-ai - only use where vim9 and Python3 alignment
if v:version >= 900
  Fpackadd('vim-ai')
endif
g:asciidoctor_allow_uri_read = " -a allow-uri-read"
Fpackadd("vim-asciidoctor")
Fpackadd("vim-characterize")
# Fpackadd("vim-combining2")
Fpackadd("vim-popped")
Fpackadd("vim-sents")
# vim-tene (my own highly configurable and flexible statusline)
try
  # Create the g:tene_ga dictionary, if necessary
  g:tene_ga = exists("g:tene_ga") ? g:tene_ga : {}
  # Use pilcrow for line numbers ASCII
  g:tene_ga["line()"] = ['¶', '']
  # Create the g:tene_hi dictionary, if necessary
  g:tene_hi = exists("g:tene_hi") ? g:tene_hi : {}
  # Override for Inactive statuslines
  g:tene_hi['x'] = 'Conceal'
  # Create the g:tene_modes dictionary, if necessary
  g:tene_modes = exists("g:tene_modes") ? g:tene_modes : {}
  # Override mode name for COMMAND-LINE
  g:tene_modes["c"] = "CMDLINE"
  # Always show the state(), not just the mode(1)
  g:tene_modestate = 1
  packadd! vim-tene
# But, if vim-tene is unavailable or fails, create a basic statusline
catch
  set statusline=\ %-6.(%{mode(1)..'\ '..state()}%)\ b%n%<\ %t\ %m\ %r\ %h%=%y
  set statusline+=\ %{&fileencoding}\ %{&fileformat}
  set statusline+=\ %{'¶'..line('.')..'/'..line('$')}\ \|
  set statusline+=%{virtcol('.')}\ U+%B\ 
endtry
# }}}
# 09 Syntax + filetype {{{
# syntax highlighting - could be 'on' and/or test for t_Co/has('syntax')
syntax enable
# Refer :h filetype-overview  -  Current status? Use :filetype
filetype plugin indent on
#}}}
# 88 Deleted / moved temporally, and commented out {{{
# }}}
# 99 Development {{{
# }}}
# vim: cc=+1 et fdm=marker ft=vim sta sts=0 sw=2 ts=8 tw=78
