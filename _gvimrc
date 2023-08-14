" .gvimrc / _gvimrc
" 01 Windows, WSL, GUI options {{{
" GUI toolbar
if has("toolbar")
  if len(split(execute('amenu ToolBar'), '\n')) > 0
    silent! aunmenu ToolBar
  endif
  anoremenu 1.10 ToolBar.Open :browse confirm e<CR>
  tmenu ToolBar.Open Open file
  anoremenu 1.20 ToolBar.Mks :execute "browse mksession! " .. strftime("%Y-%m-%d")<CR>
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
  anoremenu 1.120 ToolBar.Menu :execute "if &guioptions=~'m' \| set guioptions-=m \| else \| set guioptions+=m \| endif"<CR>
  tmenu ToolBar.Menu Toggle menu
endif

"}}}
" 02 Highlights {{{
" Screen column indicator
highlight ColorColumn guibg=LightGrey
" Just the current (cursor's) line number indicator - makes it more distinct
highlight CursorLineNr guifg=DarkGrey gui=bold
" The colour of the line numbers
highlight LineNr guifg=Grey
" The showmode message's colour (e.g., -- INSERT --)
highlight ModeMsg guifg=DarkGrey gui=bold
" Colour of 'showbreak' and other non-text characters
highlight NonText guifg=LightGrey guibg=White
" Colour of the 'list' characters like Tab
highlight SpecialKey guibg=LightGrey guifg=White
" }}}
" 03 Settings (global) {{{
"   columns  Set columns to 80 + 1 (colorcolumn) + 3 (number) + 1 (foldcolumn)
set columns=85
" Set gvim-specific font to ensure display of special characters.  For WSL the
" font can be set in WSL Properties dialog, but the font should be installed.
set guifont=FiraCode_NFM:h12 " https://www.nerdfonts.com/font-downloads
set guioptions+=!abceghLmrtT " extend default guioptions to...
set guioptions-=m " but then remove (use toolbar to toggle Menu)...
" !	External commands are executed in a terminal window
" a	Autoselect:  When VISUAL mode is started/or the Visual area extended,
"       Vim tries to become the owner of the system's global selection
" b	Bottom (horizontal) scrollbar is present
" c	Use console dialogs instead of popup dialogs for simple choices
" e	Add tab pages when indicated with 'showtabline'
" g	Grey menu items: Make menu items that are not active grey
" h	Limit horizontal scrollbar size to the length of the cursor line
" L	Left-hand scrollbar is present when there is a vertically split window
" m	Menu bar is present
" r	Right-hand scrollbar is always present.
" t	Include tearoff menu items.
" T	Include Toolbar.
if version > 899 " customise the tabline for when using vim9-tene
  set guitablabel=%{%join(tabpagebuflist('%'),'\ ˙\ ')..' %t'%}
endif
"   guitabtooltip  Consider using this.  Maybe a function; make it useful?
" set renderoptions - :h 'renderoptions'
"             "only available when compiled with GUI and DIRECTX on MS-Windows"
"             See 06 Mappings, below - it has a toggleable Leader option
"             The reason for this is that although certainly the
"             "drawn glyphs more beautiful than default GDI", meaning things
"             like coloured emoji are awesome, I hate ligatures in coding
"             fonts, so having the option to toggle this is the go.
"   # Keep cmd.exe default as that keeps gx working!
"   # set shell=bash.exe # Vim plays nicest with Linux/bash, so exploit that
"   # set shell=powershell.exe # system32\WindowsPowerShell\v1.0\powershell.exe
"   let $PYTHONPATH=#~/AppData/Local/Programs/Python/Python311# # needed?
" endif
" All of these are in the .vimrc / _vimrc.  There are none needed here
"   titlestring= This is also set in .vimrc, but it's overridden for gvim here
" All of these are in the .vimrc / _vimrc.  There are none needed here
"   titlestring= This is also set in .vimrc, but it's overridden for gvim here
" }}}
" 04 Commands (none yet for gvim specifically) {{{
" }}}
" 05 Functions (none yet for gvim specifically) {{{
" }}}
" 06 Mappings {{{
" Mapping to toggle renderer in Windows: needs Win32 and directx
if has ('Win32') && has('directx')
  nnoremap <Leader>r <Cmd>execute "let &rop = (len(&rop)==0) ? 'type:directx,gamma:1.0,geom:0,renmode:5,taamode:1' : ''"<CR>
endif
"}}}
" 07 Autocommands (none yet for gvim specifically) {{{
" }}}
" 08 Plugins (none yet for gvim specifically) {{{
" }}}
" 09 Syntax + filetype (n/a for gvim specifically?) {{{
" }}}
" vim: textwidth=79 foldmethod=marker filetype=vim expandtab
