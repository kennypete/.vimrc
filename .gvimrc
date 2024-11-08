" .gvimrc _gvimrc - vim9-mix - refer :h vim9mix
if (v:version < 802 || (v:version == 802 && !has('patch3434')))
  " If the version is before 8.2.3434 do nothing!  That is because
  " .vimrc/_vimrc uses :source for _vimrc8 and _gvimrc8 for where the version
  " is before 8.2.3434, so this vim9script should be "ignored".
  " echom "Ignored"
  finish
endif
vim9script
# .gvimrc / _gvimrc
# 01 Windows, WSL, GUI options {{{
# GUI toolbar
if has("toolbar")
  if len(split(execute('amenu ToolBar'), '\n')) > 0
    aunmenu ToolBar
  endif
  anoremenu 1.10 ToolBar.Open :browse confirm e<CR>
  tmenu ToolBar.Open Open file
  anoremenu 1.20 ToolBar.Mks :execute "browse mksession! " ..
        \ strftime("%Y-%m-%d")<CR>
  tmenu ToolBar.Mks Save current session
  anoremenu 1.30 ToolBar.Run :browse source<CR>
  tmenu ToolBar.Run Run a Vim Script / Load a session
  if has("printer") && !has("unix")
    anoremenu 1.40 ToolBar.Print :hardcopy<CR>
    vnoremenu ToolBar.Print :hardcopy<CR>
  elseif has("unix")
    anoremenu 1.40 ToolBar.Print :w !lpr<CR>
    vnoremenu ToolBar.Print :w !lpr<CR>
  endif
  tmenu ToolBar.Print Print
  anoremenu 1.45 ToolBar.-sep1- <Nop>
  anoremenu 1.50 ToolBar.Undo u
  tmenu ToolBar.Undo Undo
  anoremenu 1.60 ToolBar.Redo <C-R>
  tmenu ToolBar.Redo Redo
  anoremenu 1.65 ToolBar.-sep2- <Nop>
  vnoremenu 1.70 ToolBar.Cut "+x
  tmenu ToolBar.Cut Cut to clipboard
  vnoremenu 1.80 ToolBar.Copy "+y
  cnoremenu 1.80 ToolBar.Copy <C-Y>
  tmenu ToolBar.Copy Copy to clipboard
  nnoremenu 1.90 ToolBar.Paste "+gP
  cnoremenu 1.90 ToolBar.Paste <C-R>+
  silent! execute 'vnoremenu <script> ToolBar.Paste ' .. paste#paste_cmd['v']
  silent! execute 'inoremenu <script> ToolBar.Paste ' .. paste#paste_cmd['i']
  tmenu ToolBar.Paste Paste from Clipboard
  anoremenu 1.95 ToolBar.-sep3- <Nop>
  anoremenu <silent> 1.100 ToolBar.Spell :let &spell = &spell==0 ? 1 : 0<CR>
  tmenu ToolBar.Spell Toggle spell checking
  anoremenu <silent> 1.110 ToolBar.SpellNext ]s
  tmenu ToolBar.SpellNext Next misspelled word
  anoremenu 1.115 ToolBar.-sep4- <Nop>
  anoremenu 1.120 ToolBar.Menu :execute "if &guioptions=~'m' \| " ..
        \ "set guioptions-=m \| else \| set guioptions+=m \| endif"<CR>
  tmenu ToolBar.Menu Toggle menu
endif
#}}}
# 02 Highlights {{{
# Make sure that the default g:colors_name exists and is default (which it
# should be anyhow since that is the default rather than empty!)  NB: Actually
# calling colorscheme default does weird things here - AVOID doing that!
if !exists("g:colors_name")
  g:colors_name = 'default'
endif
# }}}
# 03 Settings (global) {{{
#   columns  Set columns to 80 + 1 (colorcolumn) + 3 (number) + 1 (foldcolumn)
set columns=85
#   guicursor=  Accept the defaults as they are pretty good
# Set gvim-specific font to ensure display of special characters.  For WSL the
# font can be set in WSL Properties dialog (and obviously the font installed).
# https://www.nerdfonts.com/font-downloads
if has('gui_gtk3')
  set guifont=FiraCode\ Nerd\ Font\ Mono\ Regular\ 12,FiraCode\ NFM\ 12
elseif has('gui_win32')
  set guifont=FiraCode_Nerd_Font_Mono:h12,FiraCode_NFM:h12
endif
g:FiraCode = &guifont
g:DejaVu = 'DejaVuSansM_Nerd_Font_Mono:h12'
# https://github.com/be5invis/Iosevka/blob/v31.7.1/doc/PACKAGE-LIST.md
# TTF zip: Regular, Bold; Extended, ExtendedBold
g:Iosevka = 'Iosevka_Fixed_SS05:h12'
g:IosevkaWide = 'Iosevka_Fixed_SS05_Extended:h12'
# [tried; v. narrow;] g:IosevkaNFM = 'Iosevka_NFM:h14:cANSI:qDRAFT'
command Fontd [&guifont, &guifontwide] = [g:DejaVu, '']
command Fontf [&guifont, &guifontwide] = [g:FiraCode, '']
command Fonti [&guifont, &guifontwide] = [g:Iosevka, g:IosevkaWide]
#   guifontset=  Not used, not needed
#   guiligatures=  Not used, and only applicable to GTK GUI
#   guioptions=  Extend guioptions to....  Refer :h 'guioptions'
set guioptions+=!abceghLmrtT
#   ...but then remove it (use toolbar to toggle Menu)...
set guioptions-=m
#   !	External commands are executed in a terminal window
#   a	Autoselect:  When VISUAL mode is started/or the Visual area extended,
#       Vim tries to become the owner of the system's global selection
#   b	Bottom (horizontal) scrollbar is present
#   c	Use console dialogs instead of popup dialogs for simple choices
#   e	Add tab pages when indicated with 'showtabline'
#   g	Grey menu items: Make menu items that are not active grey
#   h	Limit horizontal scrollbar size to the length of the cursor line
#   L	Left-hand scrollbar is present when there is a vertically split window
#   m	Menu bar is present
#   r	Right-hand scrollbar is always present
#   t	Include tearoff menu items
#   T	Include Toolbar
# customise, useful, tabline - best with vim-tene statusline combination
#   guipty  Default used
set guitablabel=%{%join(tabpagebuflist('%'),'\ ˙\ ')..'\ %t'%}
#   guitabtooltip  Consider using this.  Maybe a function; make it useful?
# set renderoptions - :h 'renderoptions'
#             "only available when compiled with GUI and DIRECTX on MS-Windows"
#             See 06 Mappings, below - it has a toggleable Leader option
#             The reason for this is that although certainly the
#             "drawn glyphs more beautiful than default GDI", meaning things
#             like coloured emoji are awesome, I hate ligatures in coding
#             fonts, so having the option to toggle this is the go.
#   # Keep cmd.exe default as that keeps gx working!
#   # set shell=bash.exe # Vim plays nicest with Linux/bash, so exploit that
#   # set shell=powershell.exe # system32\WindowsPowerShell\v1.0\powershell.exe
#   let $PYTHONPATH=#~/AppData/Local/Programs/Python/Python311# # needed?
# endif
# All of these are in the .vimrc / _vimrc.  There are none needed here
#   titlestring= This is also set in .vimrc, but it's overridden for gvim here
set titlestring=%{expand(\"%:p\")}\ %{&modified&&&buftype!='terminal'?'\ +':''}%{&readonly?'\ RO':''}%{(!&modifiable&&mode()!=#'t')?'\ -':''}%{&buftype=='help'?'\ HLP':''}
# }}}
# 04 Commands (none yet for gvim specifically) {{{
# }}}
# 05 Functions {{{
# 05.10 Font Size {{{2
#
#     Δ       FFFF   OOO   NNN  TTT     SSS III ZZZZ  EEEE
#    Δ Δ      F     O   O  N  N  T     S     I    ZZ  E
#   Δ   Δ     FFFF  O   O  N  N  T      SSS  I   ZZ   EEE
#  Δ     Δ    F     O   O  N  N  T        S  I  ZZ    E
# ΔΔΔΔΔΔΔΔΔ   F      OOO   N  N  T     SSS  III ZZZZ  EEEE
#
# Change font size
# including functions: broadly based on eggbean/resize-font.gvim, but taken
# further, e.g., handling multiple fonts listed in &guifont, for example.
#
# NB: Only enable when > v8.2 with patch 4807.  Don't bother with change font
#     size when using other versions because that's so rare for me it's not
#     worth it, and this really is only very nice to have (and is used).
if v:versionlong >= 8024807
  # initialisation of variables
  var gf_size_whole: number
  var gf_new_font_size: string
  var gf_weight: string
  var gf_bold: string
  var gf_cansi: string
  var gf_qdraft: string
  # Replace all font size digit(s).  For gtk, all with either ',' or $ following
  if has('gui_gtk')
    autocmd GUIEnter * g:gf_size_orig = matchstr(&guifont, '\( \)\@<=\d\+$')
    def g:FontSizePlus(): void
      gf_size_whole = str2nr(matchstr(&guifont, '\( \)\@<=\d\+$'))
      if gf_size_whole < 28
        gf_size_whole += 1
        gf_new_font_size = ' ' .. gf_size_whole
        &guifont = substitute(&guifont, ' \d\+\ze\($\|,\)', gf_new_font_size, 'g')
      endif
    enddef
    def g:FontSizeMinus(): void
      gf_size_whole = str2nr(matchstr(&guifont, '\( \)\@<=\d\+$'))
      if gf_size_whole > 1
        gf_size_whole -= 1
        gf_new_font_size = ' ' .. gf_size_whole
        &guifont = substitute(&guifont, ' \d\+\ze\($\|,\)', gf_new_font_size, 'g')
      endif
    enddef
    def g:FontSizeOriginal(): void
      &guifont = substitute(&guifont, '\d\+\ze\($\|,\)', g:gf_size_orig, 'g')
    enddef
  elseif has('gui_win32')
    # Replace all font size digit(s).  For win32, all instances of ':h' preceding
    autocmd GUIEnter * g:gf_size_orig = matchstr(&guifont, '\(:h\)\@<=\d\+\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?')
    def g:FontSizePlus(): void
      gf_size_whole = str2nr(matchstr(&guifont, '\(:h\)\@<=\d\+\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?'))
      gf_weight = matchstr(&guifont, '\(:W\d\+\)\?')
      gf_bold = matchstr(&guifont, '\(:b\)\?')
      gf_cansi = matchstr(&guifont, '\(:cANSI\)\?')
      gf_qdraft = matchstr(&guifont, '\(:qDRAFT\)\?')
      if gf_size_whole < 28
        gf_size_whole += 1
        gf_new_font_size = ':h' .. gf_size_whole
        &guifont = substitute(&guifont, '\(:h\d\+\)\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?', gf_new_font_size .. gf_weight .. gf_bold .. gf_cansi .. gf_qdraft, 'g')
      endif
    enddef
    def g:FontSizeMinus(): void
      gf_size_whole = str2nr(matchstr(&guifont, '\(:h\)\@<=\d\+\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?'))
      gf_weight = matchstr(&guifont, '\(:W\d\+\)\?')
      gf_bold = matchstr(&guifont, '\(:b\)\?')
      gf_cansi = matchstr(&guifont, '\(:cANSI\)\?')
      gf_qdraft = matchstr(&guifont, '\(:qDRAFT\)\?')
      if gf_size_whole > 1
        gf_size_whole -= 1
        gf_new_font_size = ':h' .. gf_size_whole
        &guifont = substitute(&guifont, '\(:h\d\+\)\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?', gf_new_font_size .. gf_weight .. gf_bold .. gf_cansi .. gf_qdraft, 'g')
      endif
    enddef
    def g:FontSizeOriginal(): void
      gf_weight = matchstr(&guifont, '\(:W\d\+\)\?')
      gf_bold = matchstr(&guifont, '\(:b\)\?')
      gf_cansi = matchstr(&guifont, '\(:cANSI\)\?')
      gf_qdraft = matchstr(&guifont, '\(:qDRAFT\)\?')
      &guifont = substitute(&guifont, '\(:h\d\+\)\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?', ':h' .. g:gf_size_orig .. gf_weight .. gf_bold .. gf_cansi .. gf_qdraft, 'g')
    enddef
  endif
endif
# }}}
# 05.20 Colorscheme overrides {{{2
def g:ColoursGUIreset(): void
  # default colorscheme overrides (they persist until the colorscheme changes)
  if g:colors_name == "default"
    # line numbers
    highlight LineNr guifg=Grey
    # the line number of the active cursor
    highlight CursorLineNr gui=bold guifg=DarkRed
    # Screen column indicator
    highlight ColorColumn guibg=LightGrey
    # 'showmode' message's colour (e.g., -- INSERT --)
    highlight ModeMsg guifg=DarkGrey
    # 'showbreak' and other non-text characters
    highlight NonText guifg=LightGrey
    # 'list' characters like Tab
    highlight SpecialKey guifg=LightGrey
    # Inactive statusline less prominent
    highlight StatusLineNC guifg=Black guibg=Grey gui=NONE
    #if has('Win32') # Windows Git Bash, Native Linux
    #  highlight Visual guibg=Grey
    #  highlight DiffAdd ctermbg=Blue
    #endif
  else
    # Do nothing special - only use default!
  endif
enddef
# }}}
# }}}
# 06 Mappings {{{
# Mapping to toggle renderer in Windows: needs Win32 and directx
if has('Win32') && has('directx')
  nnoremap <Leader>r <Cmd>execute "let &rop = (len(&rop)==0) ? 'type:directx,gamma:1.0,geom:0,renmode:5,taamode:1' : ''"<CR>
endif
# Font resize mappings --- **inactive before 8024807** --- gvim-only relevant.
# NB: 1. In Windows, the <C-Scroll*> mappings will not work with versions
#        before 8.2 with patch 5069 (they do nothing).  Refer the link, below.
# https://github.com/vim/vim/commit/ebb01bdb273216607f60faddf791a1b378cccfa8
#     2. In Windows, <C-{char}> mappings will not work before 8.2 with
#        patch 4807, and even then, it seems flakey!
#     3. Before v9.0 patch 1112 <C-_> will not work on Windows.  Refer:
# https://github.com/vim/vim/commit/7b0afc1d7698a79423c7b066a5d8d20dbb8a295a
if v:versionlong >= 8024807 && (has('gui_gtk') || has('gui_win32'))
  # Mappings generally with F10 - reliable in both gui_gtk and gui_win32
  nnoremap <C-F10> <Cmd>call g:FontSizeMinus()<CR>
  nnoremap <S-F10> <Cmd>call g:FontSizePlus()<CR>
  nnoremap <F10> <Cmd>call g:FontSizeOriginal()<CR>
  if has('gui_gtk') || (has('gui_win32') && v:versionlong >= 8025069)
    noremap <C-ScrollWheelUp> <Cmd>call g:FontSizePlus()<CR>
    noremap <C-ScrollWheelDown> <Cmd>call g:FontSizeMinus()<CR>
  endif
  if has('gui_gtk') || (has('gui_win32') && v:versionlong >= 9001112)
    nnoremap  <Cmd>call g:FontSizeMinus()<CR>
  endif
  if has('gui_gtk')
    nnoremap <C-=> <Cmd>call g:FontSizePlus()<CR>
    nnoremap <C-0> <Cmd>call g:FontSizeOriginal()<CR>
  endif
endif
#}}}
# 07 Autocommands {{{
augroup gvimrc-ColorScheme
  au!
  au ColorScheme * call g:ColoursGUIreset()
augroup END
# }}}
# 08 Plugins (none specifically for gvim currently) {{{
# Using the native Vim plugin handling. :h packadd
# * Plugins path:  $HOME/.vim/pack/plugins  $HOME\vimfiles\pack\plugins
# * To determine the remote git repository: git remote show origin
# Plugins.  Currently in use indicated with "Y", orig unless "(specifics)":
# }}}
# 09 Syntax + filetype (n/a for gvim specifically?) {{{
# }}}
# vim: textwidth=79 foldmethod=marker filetype=vim expandtab
