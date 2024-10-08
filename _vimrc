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
    echom "There was an error while sourcing _vimrc8 / _gvimrc8"
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
# Non-GUI cursors.  (GUI is simple and handled in .gvimrc/_gvimrc)
# NB: This does not work in the way outlined in the Vim help, i.e., with
# guicursor supposedly partly used in Win32 console partly - no, it doesn't!
# This too much trial and error...
# Ultimately, the three commands below work for ALL of these, for me anyhow:
# - WSL Debian running non-GUI vim (&term == xterm-256color)
# - Git Bash MINGW64 running non-GUI vim (&term == xterm)
# - Win32 Console vim.exe run from File Explorer
# - Win32 Console vim.exe run from PowerShell (7.4.0) or Windows PowerShell
#  %SystemRoot%\syswow64\WindowsPowerShell\v1.0\powershell.exe
#  C:\Program Files\PowerShell\7\pwsh.exe" -WorkingDirectory ~
#if !has("gui_running")
&t_EI = "\<esc>[1 q"   # blinking block - 0 in iSH - TODO
&t_SI = "\<esc>[5 q"   # blinking I-beam in insert mode
&t_SR = "\<esc>[3 q"   # blinking _underline in replace mode
#endif
# # set lines=28  # Commented out (for PowerShell) - it makes things go awry
# # There is no clean way of determining whether you are in PowerShell or
# # the Win32 Console run from File Explorer.
# # Keep cmd.exe as the default terminal in Windows (noting you can
# # use pwsh from the terminal to start PowerShell anyhow)
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
# things.  I used to set these up here, but now use a function and a
# combination of autocommand groups and a one-off setup at the end of either
# this vimrc or gvimrc (for the GUI).
# ----------------------------------------------------------------------------
# NB: This is set for my setup in Windows Vim (non-GUI).  It needs to be
#     optimised for Debian 12, WSL, and Vim from PowerShell?
# First, set the colorscheme to default, which I toyed with changing, but
# settled with default EVERYWHERE, so this is kind of redundant...
if !has("gui_running")
  if has("unix")
    colorscheme default
  else
    colorscheme default
  endif
else
  # Set things in _gvimrc since this is specific to the GUI
endif
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
if v:versionlong >= 8023780
  set cdhome
endif
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
#   fileencodings  Handles anything w/ BOM, [utf-32]ucs-4, utf-8, latin1
#                  Doesn't handle utf-16 be/le w/o BOM or ucs-4 be/le w/o BOM
#                  To handle these, temporarily change fencs to include them
#                  So, to handle utf-16 be  :set fencs^=utf-16
#                                utf-16 le  :set fencs^=utf-16le
#                                ucs-4 be   :set fencs^=ucs-4
#                                ucs-4 le   :set fencs^=ucs-4le
#                  ...noting this will **break** other fenc, so opening a
#                  utf-8 after applying one of the above will cause those
#                  files to 'fail'.  So, make such a change temporarily!
set fileencodings=ucs-bom,utf-8,default,latin1
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
#   numberwidth  Default to 3, but use g:VimrcSetNumberWidth() and au to alt
set numberwidth=3
# set operatorfunc  This defined in xnoremap <F8>, below
#   printfont  This prints optimally on my HP LaserJet Pro M148
set printfont=FiraCode_Nerd_Font_Mono:h9
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
#   scrolloff  Keep 0 lines above/below cursor; 999 stays in window's middle
set scrolloff=0
#   sessionoptions  Self-evident things that get saved with :mksession
set sessionoptions=buffers,curdir,globals,folds,help,options,tabpages,winsize
# set shell=pwsh
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
if v:versionlong >= 8024325
  set wildoptions=pum
endif
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
# fileignorecase; fkmap (r); foldopen; formatprg; fsync;
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
# B (Goes to first instance of a window of {buffer number} in _any_ tab {{{2
command! -nargs=1 -complete=command B
      \ silent execute ':call g:VimrcGoToBufferInTab(' .. <f-args> .. ')'
# 2}}}
# Bod {num}? (Deletes all buffers bar %/{num}) {{{2
command! -nargs=? -complete=command Bod
      \ silent execute ':call g:VimrcBufferOnlyDelete(' .. <q-args> .. ')'
# 2}}}
# Bow {num}? (Wipes out all buffers bar %/{num}) {{{2
command! -nargs=? -complete=command Bow
      \ silent execute ':call g:VimrcBufferOnlyWipeout(' .. <q-args> .. ')'
# 2}}}
# DiffOrig (Displays a diff between the buffer and the file loaded) {{{2
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit #
  \ | 0d_ | diffthis | wincmd p | diffthis
endif
# 2}}}
# LL [and Global] (Location list for {word}) {{{2
# Using LL as a mnemonic for Location List {word}
command! -bang -nargs=1 -range=% Global
      \ g:VimrcGlobal(<line1>, <line2>, <q-args>, expand('<bang>'))
command! -bang -nargs=1 -range=% LL
      \ g:VimrcGlobal(<line1>, <line2>, <q-args>, expand('<bang>'))
# 2}}}
# GenerateUnicode (Generate a Unicode table between two nnnn of U+nnnn) {{{2
# Usage example:
# :GenerateUnicode 161, 199
command! -nargs=+ -complete=command GenerateUnicode
      \ silent execute ':call g:VimrcGenerateUnicode(' .. <q-args> .. ')'
# 2}}}
# Mb and Gb (Mark/Goto a buffer that's been 'marked') {{{2
# Mark a buffer and go to a buffer (uses :B command, above)
g:mbuf = {}
command! -nargs=1 -complete=command Mb g:mbuf[<q-args>] = bufnr('%')
command! -nargs=1 -complete=command Gb execute ':B ' .. g:mbuf[<q-args>]
# 2}}}
# Redirr (Redirect output of a command to register p) {{{2
# Redirects outputs of a command to the @p register
# This means, for example, :Redirr filter /S[duh]/ command
# will put the output of that command to the p register.
# Then all you need to do is "pp to put the contents of that
# register p to the buffer in Normal mode
command! -nargs=+ -complete=command Redirr redir @p
      \ | silent execute <q-args>
      \ | redir END
# 2}}}
# }}}
# 05 Functions {{{
# g:VimrcBufferOnlyDelete (Deletes all bar % or {num} if specified) {{{2
def! g:VimrcBufferOnlyDelete(keepbuffer: number = -1): void
  var k = (keepbuffer == -1 ? bufnr() : keepbuffer)
  var n = bufnr('$')
  silent! execute 'b' k
  for b in range(n, 1, -1)
    if bufnr(b) != -1
      if bufnr(b) != k
        silent! execute 'bdelete!' b
      endif
    endif
  endfor
enddef
# 2}}}
# g:VimrcBufferOnlyWipeout (Wipes out all buffers bar % or {num}) {{{2
def! g:VimrcBufferOnlyWipeout(keepbuffer: number = -1): void
  var k = (keepbuffer == -1 ? bufnr() : keepbuffer)
  var n = bufnr('$')
  # Ensure the buffer is not hidden, otherwise the buffer list is buggered
  silent! execute 'b' k
  for b in range(n, 1, -1)
    if bufnr(b) != -1
      if bufnr(b) != k
        silent! execute 'bwipeout!' b
      endif
    endif
  endfor
enddef
# 2}}}
# g:VimrcColoursConsoleReset (Resets colours when back to Default) {{{2
# NB: 1. Console only (for GUI refer _gvimrc)
#     2. Presumes using defaults for terminal (e.g., PowerShell = Campbell)
# The colours here are for just a few distinct key highlights like the line
# numbers and the current line number, non-printing wrap characters, and
# non-printing special characters, which are highlighted so that they are
# more obvious when editing documents.  These are in an autocmd group too,
# so that they re-set if a colorscheme is called, and early in the .vimrc
# to ensure it is called if a colorscheme is.  It is kept intentionally
# low impact (using default colorscheme only, and tweaking from there in all
# variants) PLUS considering vim-tene, which re-uses some of the in-built
# highlight groups, so some need slight tweaking.
def! g:VimrcColoursConsoleReset(): void
  # default colorscheme overrides (they persist until the colorscheme changes)
  if !has("gui_running")
    if g:colors_name == "default"
      # line numbers
      highlight LineNr ctermfg=DarkGrey
      # the line number of the active cursor
      highlight CursorLineNr cterm=bold ctermfg=Yellow
      # 'showmode' message's colour (e.g., -- INSERT --)
      highlight ModeMsg ctermfg=LightGrey
      # 'showbreak' and other non-text characters
      highlight NonText ctermfg=DarkGrey
      # 'list' characters like Tab
      highlight SpecialKey ctermfg=Grey
      # The inactive statusline, etc.
      highlight ColorColumn ctermbg=DarkGrey
      if has('Win32') # Windows: Powershell, Console Vim
        highlight StatusLine ctermbg=White
        highlight StatusLineNC ctermbg=DarkGrey
      else # Windows Git Bash, Native Linux
        highlight Visual cterm=reverse ctermbg=Black
        highlight DiffAdd ctermbg=Blue
      endif
    else
      # Do nothing special - only use default!
    endif
  else # GUI ...
    # Handled in _gvimrc
  endif
enddef
# }}}
# g:VimrcCycleVirtualEdit (Cycle virtualedit local setting) {{{2
def! g:VimrcCycleVirtualEdit()
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
# g:VimrcGenerateUnicode (Generate Unicode Characters Table) {{{2
# NB: first and last are decimal values so, e.g, 162 is hexadecimal A2
def! g:VimrcGenerateUnicode(first: number, last: number): void
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
# g:VimrcGlobal (Global command to populate location list) {{{2
def! g:VimrcGlobal(line1: number, line2: number, pat: string,
    bang: string): void
  var operator = bang == '!' ? '!~' : '=~'
  var padding_top = line1 > 1 ? line1 - 1 : 0
  var bufnr = bufnr()
  var loc_title_range = (line1 == 1 && line2 == line('$')) ? '%' :
    (line1 .. ',' .. line2)
  # Directly iterating over the line numbers - an idiomatic, simple, approach
  var loc_list = []
  for dot in range(line1, line2 + 1)
    var line = getline(dot)
    if line =~# '.*' .. pat .. '.*'
      loc_list->add({'bufnr': bufnr, 'lnum': dot, 'text': line, 'valid': 1})
    endif
  endfor
  # Load the location list, presuming it is not empty, of course
  if !empty(loc_list)
    setloclist(win_getid(), [], ' ', { 'title': ':' .. loc_title_range ..
      'Global ' .. pat, 'items': loc_list })
    lwindow
    lfirst
    wincmd p
  endif
  # Create a global mapping for <S-Enter>, conditional on the previous
  # window being a quickfix or location list
  nnoremap <expr> <S-Enter> getwinvar(winnr(), '&buftype') ==# 'quickfix' ?
        \ "\<Enter>\<C-w>p" : "\<Enter>"
enddef
# 2}}}
# g:VimrcGoToBufferInTab (Go to buffer number in _any_ tab) {{{2
def! g:VimrcGoToBufferInTab(b: number): void
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
# g:VimrcPackadd (try & catch packadd! a plugin; echo a msg if it fails) {{{2
def! g:VimrcPackAdd(aplugin: string): void
  try
    # This must use execute, not just packadd! because of passing the arg
    execute "packadd! " .. aplugin
  catch
    echo "Could not load plugin " .. aplugin
  endtry
enddef
# 2}}}
# g:VimrcPopupModeCode (Generate a popup notification with the mode code) {{{2
# Makes a popup notification with the current mode and state - for debugging
def! g:VimrcPopupModeCode(): void
  popup_notification(mode(1) .. state(), {time: 555})
enddef
# 2}}}
# g:VimrcSetNumberWidth (Set numberwidth in line with lines in the buffer {{{2
def! g:VimrcSetNumberWidth(): void
  var num_lines = line('$')
  var new_width = len(num_lines) + 2
  execute 'set numberwidth=' .. new_width
enddef
# 2}}}
# g:VimrcToggleComment (Toggle code commenting of selected/current line) {{{2
g:comment_map = {"python": '#', "sh": '#', "bat": 'REM', "vbs": "'",
\ "omnimark": ";", "vim": '#'}
def! g:VimrcToggleComment(): void
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
# g:VimrcToggleLineNumber (line numbers: literal > relative > none) {{{2
def! g:VimrcToggleLineNumber(): void
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
# g:VimrcWindowWrapToggle (Toggle current window wrapping) {{{2
def! g:VimrcWindowWrapToggle(): void
  if &wrap == v:false
    set wrap
  else
    set nowrap
  endif
enddef
# 2}}}
# g:VimrcXfceCustomCursorBlock (XFCE cursor shapes BLOCK) {{{2
def! g:VimrcXfceCustomCursorBlock(): void
  if isdirectory('~/.config/xfce4')
    if filewritable('~/.config/xfce4/terminal/terminalrc')
        silent execute "!sed -i.bak -e 's/TERMINAL_CURSOR_SHAPE_IBEAM/TERMINAL_CURSOR_SHAPE_BLOCK/' ~/.config/xfce4/terminal/terminalrc"
    endif
  endif
enddef
# 2}}}
# g:VimrcXfceCustomCursorIbeam (XFCE cursor shapes IBEAM) {{{2
def! g:VimrcXfceCustomCursorIbeam(): void
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
noremap <Leader>v :call g:VimrcCycleVirtualEdit()<CR>
noremap <Leader>w :call g:VimrcWindowWrapToggle()<CR>
noremap <silent><Leader>i :exe "set colorcolumn=80 <bar> set textwidth=78"<CR>
noremap <silent><Leader>I :exe "set colorcolumn=0 <bar> set textwidth=0"<CR>
noremap <silent><Leader>l :call g:VimrcToggleLineNumber()<CR>
noremap <silent><Leader>c :call g:VimrcToggleComment()<CR>
# vim9-popped - noremap <silent><Leader>b :CpopupBuffersMenu buffers<CR>
# vim9-popped - noremap <silent><Leader>b :CpopupBuffersMenu buffers!<CR>
# 2}}}
# c[nore]map - Command-line mode only mappings {{{2
cnoremap <C-L> :exe "redrawstatus"<CR>
# 2}}}
# i[nore]map — Insert mode only mappings {{{2
# Bram recommended undo atom
inoremap <C-U> <C-G>u<C-U>
# Enter a 	 with <S-Tab>
inoremap <S-Tab> <C-V><Tab>
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
# 07.10 Normal mode forced when moving to an unmodifiable buffer {{{2
#	https://github.com/vim/vim/issues/12072
# [I suspect that this is causing the terminal to pause for ages when
# not Windows or GUI, so added, _only_ when "builtin_gui" or "win32"]
if &term =~ '[bw]'
  augroup forcenormal
    autocmd!
    autocmd BufEnter * execute (!&modifiable && !&insertmode)
          \ ? ':call feedkeys("\<Esc>")' : ''
    autocmd BufEnter * execute (!&modifiable && &insertmode)
          \ ? ':call feedkeys("\<C-L>")' : ''
  augroup END
endif
# 2}}}
# 07.20 VimrcSetNumberWidth() on entering a buffer {{{2
augroup triggersetnumberwidth
  autocmd!
  autocmd BufEnter * g:VimrcSetNumberWidth()
augroup END
# 2}}}
# 07.30 skeletons (templates) {{{2
augroup skeletons
  autocmd!
  if filereadable(expand('~/vimfiles/skeleton.asciidoc'))
    autocmd BufNewFile *.asciidoc 0r ~/vimfiles/skeleton.asciidoc
  endif
  if filereadable(expand('~/vimfiles/skeleton.txt'))
    autocmd BufNewFile *.txt 0r ~/vimfiles/skeleton.txt
  endif
augroup END # 2}}}
# 07.40 vimStartup {{{2
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
# 07.50 colorschemes {{{2
# Define the autocmd for when a colorscheme is changed
augroup vimrc-ColorScheme
  autocmd!
  autocmd ColorScheme * call g:VimrcColoursConsoleReset()
augroup END
# 2}}}
# 09.60 [Suppressed] colorschemes {{{2
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
#     	https://github.com/madox2/vim-ai
# "Y" 	https://github.com/kennypete/vim-asciidoctor (habamax fork +)
#     	https://github.com/kennypete/vim-combining2
# "Y" 	https://github.com/kennypete/vim-popped
# "Y" 	https://github.com/kennypete/vim-sents
# "Y" 	https://github.com/kennypete/vim9-cpr
#     	https://github.com/kennypete/vim-characterize (tpope fork +)
# "Y" 	https://github.com/kennypete/vim-tene
# vim-ai - only use where vim9 and Python3 align - not using - commented out
#if v:versionlong >= 9001499
#  g:VimrcPackAdd('vim-ai')
#endif
g:asciidoctor_allow_uri_read = " -a allow-uri-read"
g:VimrcPackAdd("vim-asciidoctor")
# g:champ_percent = false
# g:champ_pairs = false
# g:champ_html5 = false
# g:champ_digraphs = false
# g:champ_octal = false
# g:champ_Ugc = false
# g:champ_Uccc = false
# g:champ_Ubc = false
# g:champ_Udm = false
# g:champ_Unv = false
# g:champ_emojis = false
# g:champ_nmap_ga = false
g:VimrcPackAdd("vim9-champ")
#nnoremap <Leader>ga <Nop>
#nnoremap <Leader>d <Plug>ChampPopup;
#nnoremap <Leader>m <Plug>Champ;
#nmap <Leader>gp <Plug>ChampPopup;
# g:VimrcPackAdd("vim-characterize") TEMP COMMENTED OUT
# g:VimrcPackAdd("vim-combining2")
g:borderchars = ['', ' ', '', ' ', '', '', '', '']
g:VimrcPackAdd("vim-popped")
g:VimrcPackAdd("vim-sents")
# vim-tene (my own highly configurable and flexible statusline)
try
  # Create the g:tene_ga dictionary, if necessary
  g:tene_ga = exists("g:tene_ga") ? g:tene_ga : {}
  # Use pilcrow for line numbers ASCII and non-GUI (e.g., PowerShell)
  # Commenting these out because FiraCode Mono should be everywhere
  # if has("gui_running")
     # testing g:tene_ga["line()"] = ['_', '☺️'] # 
  # else
  #   g:tene_ga["line()"] = ['¶', '¶']
  # endif
  # if !has("gui_running")
    # Use c with caron rather than Nerd font character when PowerShell, et al.
    # Commenting these out because FiraCode Mono should be everywhere
    # g:tene_ga["virtcol()"] = ['|', 'č']
    # g:tene_ga["mod"] = ['[+]', 'м']
    # g:tene_ga["noma"] = ['[-]', 'ӿ']
    # g:tene_ga["pvw"] = ['[Preview]', '[Preview]']
    # g:tene_ga["spell"] = ['S', 'ѕ']
    # g:tene_ga["key"] = ['E', 'ю']
    # g:tene_ga["paste"] = ['P', 'р']
    # g:tene_ga["recording"] = ['@', '@']
    # g:tene_ga["ro"] = ['[RO]', 'ф]']
  # endif
  # Create the g:tene_hi dictionary, if necessary
  g:tene_hi = exists("g:tene_hi") ? g:tene_hi : {}
  # Override for Inactive statuslines
  # g:tene_hi['x'] = 'Conceal'
  # Create the g:tene_modes dictionary, if necessary
  g:tene_modes = exists("g:tene_modes") ? g:tene_modes : {}
  # Override mode name for COMMAND-LINE
  g:tene_modes["c"] = "CMDLINE"
  # Always show the state(), not just the mode(1)
  g:tene_modestate = 1
  # Always show the window number (after the buffer number)
  g:tene_window_num = 1
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
# Set tabs to two spaces in Go and noexpandtab like my default
autocmd FileType go setlocal noexpandtab tabstop=2 shiftwidth=2
#}}}
# 88 Deleted / moved temporally, and commented out {{{
# }}}
# 98 Development {{{
digraphs :) 128512
# }}}
# vim: cc=+1 et fdm=marker ft=vim sta sts=0 sw=2 ts=8 tw=79
