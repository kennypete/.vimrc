" MY .vimrc SECTIONS
" ==================
" 01. The default vimrc file, copied verbatim + modified where commented
" 02. Various additions from different sources (as noted)
" 03. Functions
" 04. vimplug
" ...
" 11. Airline (i.e., airline plugin) settings/overrides
" 12. The python-mode (i.e., pymode plugin) additions


" =====================================================================
" ================================ 01 =================================
" =====================================================================
"
" >>> The default vimrc file (modified) <<
"
" Maintainer: Bram Moolenaar <Bram@vim.org>
" Last change: 2020 Sep 30
"
" This is loaded if no vimrc file was found.
" Except when Vim is run with "-u NONE" or "-C".
" Individual settings can be reverted with ":set option&".
" Other commands can be reverted as mentioned below.

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

" Do use Ex mode - commented out default .vimrc setting
" XX Don't use Ex mode, use Q for formatting.
" XX Revert with ":unmap Q".
" XX map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
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
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
    \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif


" =====================================================================
" ================================ 02 =================================
" =====================================================================
"
" >>> Miscellaneous customisations <<<
"
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
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left and set line number width to 3
" Change the color used for the line numbers
" https://vim.fandom.com/wiki/Display_line_numbers#Mapping_to_toggle_line_numbers
set number
set numberwidth=3
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" Function and <leader>l mapping for relative line number toggling (note
" <leader> default is the \ key
" Modified from https://tuckerchapman.com/2018/06/16/how-to-use-the-vim-leader-key/
function! ToggleLineNumber() abort
  if v:version > 703
    set relativenumber!
  endif
endfunction
map <leader>l :call ToggleLineNumber()<CR>

" Allow left and right arrow keys, as well as h and l, to wrap when used at beginning or end of lines. ( < > are the cursor keys used in normal and visual mode, and [ ] are the cursor keys in insert mode
" From: https://vim.fandom.com/wiki/Automatically_wrap_left_and_right
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
" when using plugins like Airline, but I prefer it always on
set showmode

" Map, without recursion, during Visual, Select and Insert modes
" <leader><leader> to escape to Normal. This helps provide
" another option on the right side of the keyboard
" key for Escape as well as ensuring, using a <right> to
" return to the same cursor position (i.e., like a, not i).
" The remapping of the 'arrow' keys is another common
" method, e.g., vnoremap jk <Esc><Esc>
" but the delay (which can be avoided, that said) and
" utility for a non-touch typist is not worth it IMHO.
" (NB: Remapping Esc itself has unwanted side effects: don't)
" Mapping to a control escaped chr is entered with control-v in Insert mode
inoremap <leader><leader> <C-\><C-n><right>
vnoremap <leader><leader> <C-\><C-n><right>
inoremap jk <C-\><C-n><right>
vnoremap jk <C-\><C-n><right>

" Common remapping of ; to : when in Normal mode to save having to Shift
nnoremap ; :

" Make the arrow keys work exclusively (down a wrapped text line) rather than
" linewise
nnoremap <Down> gj
nnoremap <Up> gk

" Use the Control-S to act like any other text editor (Windows) where it saves
" the file.
nnoremap <C-s> :w<CR>

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

" Highlight line when in Insert mode as a key way to show you are in the mode
set cursorlineopt=line
autocmd InsertEnter,InsertLeave * set cursorline!

" Highlight special characters, including nbsp and trailing spaces
"  < non-breaking space | trailing space > 
set list listchars=nbsp:°,trail:·
highlight SpecialKey ctermbg=Yellow guibg=Yellow

" =====================================================================
" ================================ 03 =================================
" =====================================================================
"
" >>> Functions <<<
" NB: the recommendation to add 'abort' after each so that
" if something goes wrong Vim will not try to run the whole function, as
" recommended by the Reddit vimrctips.
"
":call GenerateUnicode(0x9900,0x9fff)
function! GenerateUnicode(first, last) abort
  let i = a:first
  while i <= a:last
    if (i%256 == 0)
      $put ='----------------------------------------------------'
      $put ='     0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F '
      $put ='----------------------------------------------------'
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

nnoremap <leader><Space> :call ToggleComment()<cr>
vnoremap <leader><Space> :call ToggleComment()<cr>

" --------------------------------------------------------------------



" =====================================================================
" ================================ 04 =================================
" =====================================================================
"
call plug#begin()

Plug 'https://github.com/kennypete/vim-airline.git'
Plug 'https://github.com/kennypete/vim-airline-themes.git'
" Plug 'https://github.com/itchyny/lightline.vim'
" Consider migrating to lightline, however, check it handles as well/extend it
Plug 'https://github.com/python-mode/python-mode.git', { 'for': 'python' }

call plug#end()


" =====================================================================
" ================================ 11 =================================
" =====================================================================
"
" PLUGIN >>> airline <<<
"
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
let g:airline_left_sep='◤'

"
" Mode information
"
" -----------------------------------------------------------------------------------------------------
" Mode code | Mode displayed       | How to get there and other info
" -----------------------------------------------------------------------------------------------------
"     n     | {blank}              | <Esc> from other modes; operator pendings too (no, nov, noV, no^V))
"    no     | {blank}              | Operator-pending mode
"    nov    | {blank}              | Operator-pending (forced characterwise |o_v|)
"    noV    | {blank}              | Operator-pending (forced linewise |o_V|)
" no no^V | {blank}              | Operator-pending (forced blockwise |o_|)
"    niI    | (insert)             | <C-o> from Insert mode
"    niR    | (replace)            | <C-o> from Replace mode
"    niV    | (vreplace)           | <C-o> from Virtual Replace mode
"     v     | VISUAL               | v from Normal mode (or <C-g> to toggle from Select mode)
"     v     | (insert) VISUAL ...  | CTRL-O, v/V/<C-v>, or mouse select and drag from Insert mode
"     V     | VISUAL LINE          | V from Normal mode (or <C-g> to toggle from Select Line mode)
"    ^V   | VISUAL BLOCK         | <C-v> from Normal mode (or <C-g> to toggle from Select Block mode)
"     s     | SELECT               | gh from Normal mode  (or <C-g> to toggle from Visual mode)
"     S     | SELECT LINE          | gH from Normal mode (or <C-g> to toggle from Select Line mode)
"    ^S   | SELECT BLOCK         | g<C-h> from Normal mode (or <C-g> to toggle from Visual Block mode)
"     i     | INSERT               | i from Normal mode (or any of I a A o O c C s or S)
"    ic     | Keyword completi...  | <C-n> or <C-p> from Insert mode (:help compl-generic)
"    ix     | ^X mode (^]^D ...)   | <C-x> from Insert mode; this is 'Insert completion mode'
"     R     | REPLACE              | R from Normal mode
"    Rc     | Keyword completi...  | <C-n> or <C-p> from Replace mode (:help compl-generic)
"    Rv     | VREPLACE             | gR from Normal mode ['useful for editing <Tab> separated columns']
"    Rx     | ^X mode (^]^D ...)   | <C-x> from Replace mode; this is 'Replace completion mode'
"     c     | {n/a - Command mode} | : or / or ? ('Command' mode; can be a bit delayed appearing)
"    cv     | {n/a - Vim Ex mode}  | gQ to enter Vim Ex mode from Normal mode (or niI, niR, niV)
"    ce     | {n/a - Ex mode}      | Q to enter Ex mode (if not remapped to gq as is commonly done)
"     r     | {n/a - in a f/r}     | :%s/find/replace/gc - e.g., after enter is pressed, 'replace with'
"    rm     | {n/a - in a f/r}     |
"    r?     | [Y]es, [N]o, [C]a... | :confirm q (etc.)
"     t     | {n/a - Command mode} | :ter[minal] to open a new terminal (and <C-w><C-c> to exit it)
" -----------------------------------------------------------------------------------------------------
"
" =====================================================================
" ================================ 12 =================================
" =====================================================================
"
" >> PYMODE <<
"
" 2. Common functionality ~ https://github.com/python-mode/python-mode/blob/develop/doc/pymode.txt#L77
" Turn on the whole plugin. *'g:pymode'*
let g:pymode = 1

" Trim unused white spaces on save. *'g:pymode_trim_whitespaces'*
let g:pymode_trim_whitespaces = 1

" Setup default python options. *'g:pymode_options'*
let g:pymode_options = 1

" Enable colorcolumn display at max_line_length. *'g:pymode_options_colorcolumn'*
let g:pymode_options_colorcolumn = 1

" Setup pymode |quickfix| window. *'g:pymode_quickfix_maxheight'*  *'g:pymode_quickfix_minheight'*
let g:pymode_quickfix_minheight = 2
let g:pymode_quickfix_maxheight = 5

" Set pymode |preview| window height. *'g:pymode_preview_height'*
" Preview window is used to show documentation and ouput from |pymode-run|.
let g:pymode_preview_height = 4

" Set where pymode |preview| window will appear. *'g:pymode_preview_position'*
let g:pymode_preview_position = 'botright'

" Pymode supports PEP8-compatible python indent.
" Enable pymode indentation *'g:pymode_indent'*
let g:pymode_indent = 1

" Turn on the run code script *'g:pymode_run'*
" let g:pymode_run = 1

" Binds keys to run python code *'g:pymode_run_bind'*
" let g:pymode_run_bind = '<leader>r'

" 3. Code checking ~ https://github.com/python-mode/python-mode/blob/develop/doc/pymode.txt#L292
" Turn on code checking *'g:pymode_lint'*
let g:pymode_lint = 1

" Check code on every save (if file has been modified) *'g:pymode_lint_on_write'*
let g:pymode_lint_on_write = 1

" Check code when editing (on the fly) *'g:pymode_lint_on_fly'*
let g:pymode_lint_on_fly = 0

" Show error message if cursor placed at the error line *'g:pymode_lint_message'*
let g:pymode_lint_message = 1

" 4. Rope support ~ https://github.com/python-mode/python-mode/blob/develop/doc/pymode.txt#L407

" Turn on the rope script *'g:pymode_rope'*
let g:pymode_rope = 1

" Set the prefix for rope commands *'g:pymode_rope_prefix'*
let g:pymode_rope_refix = '<C-c>'

" Show documentation for object under cursor. *'g:pymode_rope_show_doc_bind'*
let g:pymode_rope_show_doc_bind = '<C-c>d'

" If there's only one complete item, vim may be inserting it automatically
" instead of using a popup menu. If the complete item which inserted is not
" your wanted, you can roll it back use '<c-w>' in |Insert| mode or setup
" 'completeopt' with `menuone` and `noinsert` in your vimrc. .e.g.
set completeopt=menuone,noinsert

" Turn on code completion support in the plugin *'g:pymode_rope_completion'*
let g:pymode_rope_completion = 1

" Turn on autocompletion when typing a period *'g:pymode_rope_complete_on_dot'*
let g:pymode_rope_complete_on_dot = 1

" Keymap for autocomplete *'g:pymode_rope_completion_bind'*
" let g:pymode_rope_completion_bind = '<C-Space>'

" Load modules to autoimport by default *'g:pymode_rope_autoimport_modules'*
let g:pymode_rope_autoimport_modules = ['os', 'shutil', 'datetime']

" 5. Syntax ~ https://github.com/python-mode/python-mode/blob/develop/doc/pymode.txt#L648

" Turn on pymode syntax *'g:pymode_syntax'*
let g:pymode_syntax = 1

" Enable all python highlights *'g:pymode_syntax_all'*
let g:pymode_syntax_all = 1

" Highlight "print" as a function *'g:pymode_syntax_print_as_function'*
let g:pymode_syntax_print_as_function = 0

" Highlight "async/await" keywords *'g:pymode_syntax_highlight_async_await'*
let g:pymode_syntax_highlight_async_await = g:pymode_syntax_all

" Highlight '=' operator *'g:pymode_syntax_highlight_equal_operator'*
let g:pymode_syntax_highlight_equal_operator = g:pymode_syntax_all

" Highlight ':=' operator *'g:pymode_syntax_highlight_walrus_operator'*
let g:pymode_syntax_highlight_walrus_operator = g:pymode_syntax_all

" Highlight '*' operator *'g:pymode_syntax_highlight_stars_operator'*
let g:pymode_syntax_highlight_stars_operator = g:pymode_syntax_all

" Highlight 'self' keyword *'g:pymode_syntax_highlight_self'*
let g:pymode_syntax_highlight_self = g:pymode_syntax_all

" Highlight indents errors *'g:pymode_syntax_indent_errors'*
let g:pymode_syntax_indent_errors = g:pymode_syntax_all

" Highlight spaces errors *'g:pymode_syntax_space_errors'*
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Highlight string formatting *'g:pymode_syntax_string_formatting'*
" *'g:pymode_syntax_string_format'*
" *'g:pymode_syntax_string_templates'*
" *'g:pymode_syntax_doctests'*
let g:pymode_syntax_string_formatting = g:pymode_syntax_all
let g:pymode_syntax_string_format = g:pymode_syntax_all
let g:pymode_syntax_string_templates = g:pymode_syntax_all
let g:pymode_syntax_doctests = g:pymode_syntax_all

" Highlight builtin objects (True, False, ...) *'g:pymode_syntax_builtin_objs'*
let g:pymode_syntax_builtin_objs = g:pymode_syntax_all

" Highlight builtin types (str, list, ...) *'g:pymode_syntax_builtin_types'*
let g:pymode_syntax_builtin_types = g:pymode_syntax_all

" Highlight exceptions (TypeError, ValueError, ...) *'g:pymode_syntax_highlight_exceptions'*
let g:pymode_syntax_highlight_exceptions = g:pymode_syntax_all

" Highlight docstrings as pythonDocstring (otherwise as pythonString) *'g:pymode_syntax_docstrings'*
let g:pymode_syntax_docstrings = g:pymode_syntax_all

