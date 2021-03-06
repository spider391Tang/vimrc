" vgod's vimrc
" Tsung-Hsiang (Sean) Chang <vgod@vgod.tw>
" Fork me on GITHUB  https://github.com/vgod/vimrc

" read https://github.com/vgod/vimrc/blob/master/README.md for more info


" For pathogen.vim: auto load all plugins in .vim/bundle {{{
let g:pathogen_disabled = []
if !has('gui_running')
   call add(g:pathogen_disabled, 'powerline')
endif

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
" }}}

" General Settings {{{

set nocompatible	" not compatible with the old-fashion vi mode
set bs=2		" allow backspacing over everything in insert mode
set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set autoread		" auto read when file is changed from outside

filetype off          " necessary to make ftdetect work on Linux
syntax on
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

syntax on		" syntax highlight
set hlsearch		" search highlighting

" auto reload vimrc when editing it
autocmd! bufwritepost .vimrc source ~/.vimrc

if has("gui_running")	" GUI color and font settings
  if has("gui_mac") || has("gui_macvim")
    " set guifont=Anonymous\ Pro:h16
    set guifont=Consolas\ Bold:h16
  else
    set guifont=Consolas:h14, guifont=Osaka-Mono:h20
    set guifontwide=YaHei\ Consolas\ Hybrid:h9
  endif
  set background=dark 
  set t_Co=256          " 256 color mode
  set cursorline        " highlight current line
  colors moria
" Reference https://github.com/daylerees/colour-schemes/blob/master/vim/colors/peacock.vim
  highlight Normal guibg=#2b2a27
  highlight CursorLine guibg=#003853 ctermbg=24 gui=none cterm=none

  let $LANG="zh_TW.UTF-8"
  set langmenu=zh_tw.utf-8
  set encoding=utf-8
  
  source $VIMRUNTIME/delmenu.vim
  source $VIMRUNTIME/menu.vim

else
" terminal color settings
  colors vgod
endif

set clipboard=unnamed	" yank to the system register (*) by default
set showmatch		" Cursor shows matching ) and }
set showmode		" Show current mode
set wildchar=<TAB>	" start wild expansion in the command line using <TAB>
set wildmenu            " wild char completion menu

" ignore these files while expanding wild chars
set wildignore=*.o,*.class,*.pyc

set autoindent		" auto indentation
set incsearch		" incremental search
set nobackup		" no *~ backup files
set copyindent		" copy the previous indentation on autoindenting
set ignorecase		" ignore case when searching
set smartcase		" ignore case if search pattern is all lowercase,case-sensitive otherwise
set smarttab		" insert tabs on the start of a line according to context

" disable sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
" }}}

" TAB setting {{{
   set expandtab        "replace <TAB> with spaces
   set softtabstop=4 
   set shiftwidth=4 

   au FileType Makefile set noexpandtab
" }}}      							

" status line ---------------------------------- {{{
" See http://learnvimscriptthehardway.stevelosh.com/chapters/17.html  for reference
" 20141210 -- using air-line instead
" set laststatus=2
" set statusline=\ %{HasPaste()}%<%-15.25(%f%)%m%r%h\ %w\ \ 
" set statusline+=\ \ \ [%{&ff}/%Y] 
" set statusline+=\ \ \ %<%20.30(%{hostname()}:%{CurDir()}%)\ 
" set statusline+=%=%-10.(%l,%c%V%)\ %p%%/%L

function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return '[PASTE]'
    else
        return ''
    endif
endfunction

" }}}

" C/C++ specific settings -------------------------{{{
autocmd FileType c,cpp,cc  set cindent comments=sr:/*,mb:*,el:*/,:// cino=>s,e0,n0,f0,{0,}0,^-1s,:0,=s,g0,h1s,p2,t0,+2,(2,)20,*30
autocmd FileType c,cpp,cc  set nu
autocmd FileType c,cpp,cc,java  autocmd BufWritePre <buffer> :%s/\s\+$//e
" }}}

" Vimscript file settings ---------------------- {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

"--------------------------------------------------------------------------- 
" Tip #382: Search for <cword> and replace with input() in all open buffers 
"--------------------------------------------------------------------------- 

fun! Replace() 
    let s:word = input("Replace " . expand('<cword>') . " with:") 
    :exe 'bufdo! %s/\<' . expand('<cword>') . '\>/' . s:word . '/ge' 
    :unlet! s:word 
endfun 

"--------------------------------------------------------------------------- 
" USEFUL SHORTCUTS
"--------------------------------------------------------------------------- 
" set leader to ,
let mapleader=","
let g:mapleader=","

"replace the current word in all opened buffers
map <leader>r :call Replace()<CR>

" open the error console
map <leader>cc :botright cope<CR> 
" move to next error
map <leader>] :cn<CR>
" move to the prev error
map <leader>[ :cp<CR>

" --- move around splits {
" move to and maximize the below split 
map <C-J> <C-W>j<C-W>_
" move to and maximize the above split 
map <C-K> <C-W>k<C-W>_
" move to and maximize the left split 
nmap <c-h> <c-w>h<c-w><bar>
" move to and maximize the right split  
nmap <c-l> <c-w>l<c-w><bar>
set wmw=0                     " set the min width of a window to 0 so we can maximize others 
set wmh=0                     " set the min height of a window to 0 so we can maximize others
" }

" move around tabs. conflict with the original screen top/bottom
" comment them out if you want the original H/L
" go to prev tab 
map <S-H> gT
" go to next tab
map <S-L> gt

" new tab
map <C-t><C-t> :tabnew<CR>
" close tab
map <C-t><C-w> :tabclose<CR> 

" ,/ turn off search highlighting
nmap <leader>/ :nohl<CR>

" Bash like keys for the command line
cnoremap <C-A>      <Home>
cnoremap <C-E>      <End>
cnoremap <C-K>      <C-U>

" ,p toggles paste mode
nmap <leader>p :set paste!<BAR>set paste?<CR>

" allow multiple indentation/deindentation in visual mode
vnoremap < <gv
vnoremap > >gv

" :cd. change working directory to that of the current file
cmap cd. lcd %:p:h

" Writing Restructured Text (Sphinx Documentation) {
   " Ctrl-u 1:    underline Parts w/ #'s
   noremap  <C-u>1 yyPVr#yyjp
   inoremap <C-u>1 <esc>yyPVr#yyjpA
   " Ctrl-u 2:    underline Chapters w/ *'s
   noremap  <C-u>2 yyPVr*yyjp
   inoremap <C-u>2 <esc>yyPVr*yyjpA
   " Ctrl-u 3:    underline Section Level 1 w/ ='s
   noremap  <C-u>3 yypVr=
   inoremap <C-u>3 <esc>yypVr=A
   " Ctrl-u 4:    underline Section Level 2 w/ -'s
   noremap  <C-u>4 yypVr-
   inoremap <C-u>4 <esc>yypVr-A
   " Ctrl-u 5:    underline Section Level 3 w/ ^'s
   noremap  <C-u>5 yypVr^
   inoremap <C-u>5 <esc>yypVr^A
"}

" Quick edit and source vimrc
if has("gui_mac") || has("gui_macvim")
  nnoremap <leader>ev :vs $HOME/.vim/vimrc<CR>
  nnoremap <leader>sv :source $HOME/.vim/vimrc<CR>
else
  nnoremap <leader>ev :vs $HOME/.vim/vimrc<CR>
  nnoremap <leader>sv :source $HOME/.vim/vimrc<CR>
endif

" Prevent CTRL-V are Paste for windows 
if mapcheck("<C-V>") != ""
    unmap <C-V>
endif

" Training fingers
" Using jk is great because the keys are right under two of your strongest fingers and you don't have to perform a chord
inoremap jk <esc>

" Easy Expansion of the Active File Directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Open the folder containing the currently open file
nnoremap <silent> <C-F5> :if expand("%:p:h") != "" \| set noshellslash \| exec "!start explorer.exe" expand("%:p:h:S") \| set shellslash \|endif<CR>

" Fixing the & Command
nnoremap & :&&<CR>
xnoremap & :&&<CR>

"--------------------------------------------------------------------------- 
" PROGRAMMING SHORTCUTS
"--------------------------------------------------------------------------- 

" Ctrl-[ jump out of the tag stack (undo Ctrl-])
map <C-[> <ESC>:po<CR>

" ,h generates the header guard
map <leader>h :call IncludeGuard()<CR>
fun! IncludeGuard()
   let basename = substitute(bufname(""), '.*/', '', '')
   let guard = '_' . substitute(toupper(basename), '\.', '_', "H")
   call append(0, "#ifndef " . guard)
   call append(1, "#define " . guard)
   call append( line("$"), "#endif // for #ifndef " . guard)
endfun

" Enable omni completion. (Ctrl-X Ctrl-O)
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType java set omnifunc=javacomplete#Complete

" use syntax complete if nothing else available
if has("autocmd") && exists("+omnifunc")
  autocmd Filetype *
              \	if &omnifunc == "" |
              \		setlocal omnifunc=syntaxcomplete#Complete |
              \	endif
endif

set cot-=preview "disable doc preview in omnicomplete

" make CSS omnicompletion work for SASS and SCSS
autocmd BufNewFile,BufRead *.scss             set ft=scss.css
autocmd BufNewFile,BufRead *.sass             set ft=sass.css

"--------------------------------------------------------------------------- 
" ENCODING SETTINGS
"--------------------------------------------------------------------------- 
set encoding=utf-8                                  
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,big5,gb2312,latin1

fun! ViewUTF8()
	set encoding=utf-8                                  
	set termencoding=big5
endfun

fun! UTF8()
	set encoding=utf-8                                  
	set termencoding=big5
	set fileencoding=utf-8
	set fileencodings=ucs-bom,big5,utf-8,latin1
endfun

fun! Big5()
	set encoding=big5
	set fileencoding=big5
endfun

"--------------------------------------------------------------------------- 
" PLUGIN SETTINGS
"--------------------------------------------------------------------------- 

" ------- vim-textobj-clang {{{

" let g:textobj_clang_more_mappings = 1

" }}}

" ------- gundo {{{

nnoremap <F1> :GundoToggle<CR>

" }}}

" ------- ack.vim {{{

let g:ackprg = 'ag --vimgrep --smart-case'
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack

" }}}

" ------- vim-latex {{{
" many latex shortcuts and snippets

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash
set grepprg=grep\ -nH\ $*
" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" }}}

" --- AutoClose --------- {{{
" Inserts matching bracket, paren, brace or quote
" fixed the arrow key problems caused by AutoClose
if !has("gui_running")	
   set term=linux
   imap OA <ESC>ki
   imap OB <ESC>ji
   imap OC <ESC>li
   imap OD <ESC>hi

   nmap OA k
   nmap OB j
   nmap OC l
   nmap OD h
endif
" }}}

" --- Command-T {{{
let g:CommandTMaxHeight = 15
" }}}

" --- EasyMotion {{{
"let g:EasyMotion_leader_key = '<Leader>m' " default is <Leader>w
hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade  Comment
" }}}

" --- TagBar {{{
" toggle TagBar with F7
nnoremap <silent> <F7> :TagbarToggle<CR> 
" set focus to TagBar when opening it
let g:tagbar_autofocus = 1
" }}}

" --- SnipMate {{{
let g:snipMateAllowMatchingDot = 0
" }}}

" --- coffee-script {{{
au BufWritePost *.coffee silent CoffeeMake! -b | cwindow | redraw! " recompile coffee scripts on write
" }}}

" --- vim-gitgutter {{{
let g:gitgutter_enabled = 1
let g:gitgutter_grep_command = 'grep -e'
" }}}

" --- vim-airline {{{
" set status line
set laststatus=2
" enable powerline-fonts
" mark below powerline_fonts to resolve chinese can't be displayed
" let g:airline_powerline_fonts = 1

" enable tabline
let g:airline#extensions#tabline#enabled = 1
"   set left separator
let g:airline#extensions#tabline#left_sep = ' '
"   set left separator which are not editting
let g:airline#extensions#tabline#left_alt_sep = '|'
"   show buffer number
let g:airline#extensions#tabline#buffer_nr_show = 1
" }}}

" --- ctrlp.vim {{{
"  Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
"  f means fuzzy
let g:ctrlp_map = '<leader>f'
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>a :CtrlPMixed<cr>
" }}}

" --- syntastic {{{
" }}}

" --- jedi-vim {{{
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<S-Space>"
let g:jedi#rename_command = "<leader>r"
let g:jedi#show_call_signatures = "1"
" }}}
"
" --- nerdtree {{{
silent! nmap <F3> :NERDTreeFind<CR>
let g:NERDTreeMapActivateNode="<F3>"
" }}}
