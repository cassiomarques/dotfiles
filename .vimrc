syntax on                 " Enable syntax highlighting
" syntax sync minlines=256
filetype plugin indent on " Enable filetype-specific indenting and plugins
" let maplocallneader = ','

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType ruby,perl,tex set shiftwidth=2
autocmd FileType c,cpp,java,javascript,python,xml,xhtml,html set shiftwidth=2
autocmd FileType javascript set shiftwidth=2

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
" autocmd BufReadPost * call SetCursorPosition()
" function! SetCursorPosition()
"   if &filetype !~ 'commit\c'
"     if line("'\"") > 0 && line("'\"") <= line("$")
"       exe "normal g`\""
"     endif
"   end
" endfunction

" Removes trailing spaces when saving the buffer
autocmd BufWritePre * :%s/\s\+$//e

augroup filetypedetect
  au! BufNewFile,BufRead *.ch setf cheat
  au BufNewFile,BufRead *.liquid setf liquid
  au! BufRead,BufNewFile *.haml setfiletype haml
  autocmd BufNewFile,BufRead *.yml setf eruby
  autocmd BufRead,BufNewFile *.prawn set filetype=ruby
  autocmd BufRead,BufNewFile Guardfile set filetype=ruby
  autocmd BufNewFile,BufRead *.clj set filetype=clojure
  autocmd BufNewFile,BufRead *.coffee set filetype=coffee
augroup END

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 et
augroup END

"Load plugins using pathogen.vim
call pathogen#runtime_append_all_bundles()

au! BufNewFile,BufRead *.haml set filetype=haml

"=====================================================================
" MAPPINGS
"=====================================================================
" Build tags for the current directory
nmap <F2> :!/usr/local/Cellar/ctags/5.8/bin/ctags -R .<CR>

" Clears CtrlP cache
nmap <F3> :CtrlPClearCache<CR>

" Remove search highlighting with <ENTER>
:nnoremap <Space> :nohlsearch<cr>

" Runs the current spec file using Zeus
nmap <leader>t :!zeus rspec %<CR>

" No arrow keys
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" Redraw the screen (dealing with annoying redraw issues on MacVim)
nmap <leader>r :redraw!<cr>

" Changing tabs
nmap <Tab> :tabnext<CR>
nmap <S-Tab> :tabprevious<CR>

map <C-q> :mksession! ~/.vim/.session <cr>
map <C-//> map ,# :s/^/#/<CR>
" Uses rdiscount and Bcat to open the current markdown file in the browser
map ,pm :!rdiscount % <Bar>bcat<CR>
" Uses Pygments and Bcat to open the code in the browser, with syntax
" highlighting
map ,pp :!pygmentize -Ofull,encoding=utf8,style=monokai -f html % <Bar>bcat<CR>

" Opens Syntastic Errors window and jumps to it.
map <M-e> :Errors<CR><C-w>j

"Remove trailing spaces with \rt
nmap <leader>rt :%s/\s\+$//<CR>

"Ctags search always lists all occurrences
nmap <C-]> g<C-]>

"map to bufexplorer
nnoremap <C-B> :BufExplorer<cr>

"make Y consistent with C and D
nnoremap Y y$

nmap <F13> :call ReloadSnippets(&filetype)<CR>

" Align Ruby hashes
vmap ah :Align =><CR>
" Align by '='
vmap ae :Align =<CR>
" Align JavaScript objects with : (comma)
vmap ac :Align :<CR>
" Align blocks (or anything delimited by opening brackets)
vmap ab :Align {<CR>

" Run current test
map <Leader>t :call RunCurrentTest()<CR>
map <Leader>o :call RunCurrentLineInTest()<CR>

" Save file as root
cnoremap sudow w !sudo tee % >/dev/null

"=====================================================================
" PLUGIN CONFIGURATIONS
"=====================================================================
" Load matchit (% to bounce from do to end, etc.)
runtime! plugin/matchit.vim
runtime! macros/matchit.vim

" Rainbow
let g:rainbow_active = 1
au Syntax * RainbowToggle

let g:rainbow_conf = {
\   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\   'ctermfgs': ['darkgray', 'darkgreen', 'darkmagenta', 'darkcyan', 'darkred', '97'],
\   'operators': '_,_',
\   'parentheses': [['(',')'], ['\[','\]'], ['{','}']],
\   'separately': {
\       '*': {},
\       'lisp': {
\           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\           'ctermfgs': ['darkgray', 'darkblue', 'darkmagenta', 'darkcyan', 'darkred', 'darkgreen'],
\       },
\       'clojure': {
\           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\           'ctermfgs': ['darkgray', 'darkgreen', 'darkmagenta', 'darkcyan', 'darkred', '97'],
\       },
\       'html': {
\           'parentheses': [['(',')'], ['\[','\]'], ['{','}'], ['<\a[^>]*[^/]>\|<\a>','</[^>]*>']],
\       },
\       'tex': {
\           'operators': '',
\           'parentheses': [['(',')'], ['\[','\]']],
\       },
\   }
\}

"Ctrl-P
let g:ctrlp_dotfiles = 0
let g:ctrlp_map = '<leader>p'
let g:ctrlp_max_files = 0

" let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$\|coverage\|DS_Store'
let g:ctrlp_custom_ignore = {'file': '\.git$\|\.hg$\|\.svn$\|DS_Store', 'dir': 'coverage', 'link': '',}
let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files']
let g:ctrlp_user_command = ['.hg/', 'hg --cwd %s locate -I .']
let g:ctrlp_open_new_file = 't'

"Powerline.vim
let g:Powerline_symbols = 'fancy'

" Syntastic settings
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=0

" Snipmate setup
source ~/.vim/snippets/support_functions.vim

" Clojure-Vim
let g:vimclojure#HighlightBuiltins = 1
let g:vimclojure#ParenRainbow = 1

" Ack.vim
" let g:ackprg = 'ag --nogroup --nocolor --column'

"=====================================================================
" Colorscheme, fonts, etc
"=====================================================================
colorscheme lanai
" colorscheme Tomorrow-Night-Eighties
" set background=dark
" colorscheme solarized

" autocmd! BufEnter,BufNewFile *.clj colorscheme elrodeo

if has("gui_running")
  if has("gui_gnome")
      set term=gnome-256color
      set guifont=Inconsolata\ Medium\ 10
  else
      set guitablabel=%M%t
      set lines=200
      set columns=280
  endif
  if has("gui_mac") || has("gui_macvim")
      set guifont=Monaco:h10
      " make Mac's Option key behave as the Meta key
      set invmmta
  endif
else
  " tmux will only forward escape sequences to the terminal if surrounded by a DCS sequence
  " http://sourceforge.net/mailarchive/forum.php?thread_name=AANLkTinkbdoZ8eNR1X2UobLTeww1jFrvfJxTMfKSq-L%2B%40mail.gmail.com&forum_name=tmux-users
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
  "dont load csapprox if there is no gui support - silences an annoying warning
  " let g:CSApprox_loaded = 1
endif

"==================================================================================
" Test-running stuff
"==================================================================================
function! RunCurrentTest()
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call SetTestFile()

    if match(expand('%'), '\.feature$') != -1
      call SetTestRunner("!cucumber")
      exec g:bjo_test_runner g:bjo_test_file
    elseif match(expand('%'), '_spec\.rb$') != -1
      call SetTestRunner("!rspec")
      exec g:bjo_test_runner g:bjo_test_file
    else
      call SetTestRunner("!ruby -Itest")
      exec g:bjo_test_runner g:bjo_test_file
    endif
  else
    exec g:bjo_test_runner g:bjo_test_file
  endif
endfunction

function! SetTestRunner(runner)
  let g:bjo_test_runner=a:runner
endfunction

function! RunCurrentLineInTest()
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call SetTestFileWithLine()
  end

  exec "!rspec" g:bjo_test_file . ":" . g:bjo_test_file_line
endfunction

function! SetTestFile()
  let g:bjo_test_file=@%
endfunction

function! SetTestFileWithLine()
  let g:bjo_test_file=@%
  let g:bjo_test_file_line=line(".")
endfunction

function! CorrectTestRunner()
  if match(expand('%'), '\.feature$') != -1
    return "cucumber"
  elseif match(expand('%'), '_spec\.rb$') != -1
    return "rspec"
  else
    return "ruby"
  endif
endfunction

"=====================================================================

"=====================================================================
" VIM SETTINGS
"=====================================================================
set nocompatible          " We're running Vim, not Vi!
set encoding=utf-8 " Necessary to show unicode glyphs

" It looks like the new regular expression engine on newer versions of Vim
" does not play well with some syntax files (Ruby, for instance). The below
" setting will force Vim to use the older regexp engine.
set re=1
set nobackup
set noswapfile
set shell=/bin/zsh
set nowritebackup
set path=$PWD/public/**,$PWD/**
set sessionoptions=blank,buffers,curdir,help,resize,tabpages,winsize
set laststatus=2
"tell the term has 256 colors
set t_Co=256
set guioptions-=T
set guioptions-=m
" set cursorline
"folding settings
" set foldmethod=indent   "fold based on indent
set switchbuf=usetab
" set foldnestmax=10       "deepest fold is 3 levels
" set nofoldenable        "dont fold by default
" set foldlevel=1
set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1
set cf  " Enable error files & error jumping.
if $TMUX == ''
  set clipboard+=unnamed  " Yanks go on clipboard instead.
endif
set history=256  " Number of things to remember in history.
set autowrite  " Writes on make/shell commands
"set ruler  " Ruler on
set nu  " Line numbers on
set nowrap  " Line wrapping off
set timeoutlen=250  " Time to wait after ESC (default causes an annoying delay)
set ignorecase smartcase
set hlsearch
" Formatting (some of these are for coding in C and C++)
set ts=2  " Tabs are 2 spaces
set bs=2  " Backspace over everything in insert mode
set shiftwidth=2  " Tabs under smart indent
set nocp incsearch
set cinoptions=:0,p0,t0
set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr
set cindent
set autoindent
set smarttab
set expandtab
" Visual
set showmatch  " Show matching brackets.
set mat=5  " Bracket blinking.
set list
set lcs=tab:\ \ ,extends:>,precedes:<
set novisualbell  " No blinking .
set noerrorbells  " No noise.
set laststatus=2  " Always show status line.
set mousehide  " Hide mouse after chars typed
set mouse=a  " Mouse in all modes

