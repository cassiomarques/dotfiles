set nocompatible              " be iMproved, required

let g:python_host_prog = '/Users/cmarques/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/Users/cmarques/.pyenv/versions/neovim3/bin/python'

"Ale (linters, etc)
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_delay = 600


" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'vim-scripts/CSApprox'
Plug 'rking/ag.vim'
Plug 'vim-scripts/Align'
Plug 'jlanzarotta/bufexplorer'
Plug 'bkad/CamelCaseMotion'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'tpope/vim-endwise'
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'mxw/vim-jsx'
Plug 'tpope/vim-markdown'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-rails'
Plug 'tomtom/tcomment_vim'
Plug 'dgrnbrg/vim-redl'
Plug 'tpope/vim-fugitive'                                 " Git stuff
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-dispatch'
Plug 'radenling/vim-dispatch-neovim'
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'gcmt/wildfire.vim'                                  " Select blocks of things
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'flazz/vim-colorschemes'                             " Lots of colorschemes
Plug 'edkolev/tmuxline.vim'
Plug 'janko-m/vim-test'
Plug 'skywind3000/asyncrun.vim'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'
Plug 'elixir-editors/vim-elixir'
Plug 'c-brenn/phoenix.vim'
Plug 'slashmili/alchemist.vim'
Plug 'thinca/vim-ref'
Plug 'w0rp/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'kchmck/vim-coffee-script'
Plug 'leafgarland/typescript-vim'
Plug 'hashivim/vim-terraform'
" Clojure stuff
" Plug 'tpope/vim-salve'
" Plug 'tpope/vim-projectionist'
" Plug 'tpope/vim-dispatch'
" Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-classpath'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'guns/vim-sexp',    {'for': 'clojure'}
Plug 'liquidz/vim-iced', {'for': 'clojure'}

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

" Initialize plugin system
call plug#end()

syntax on                 " Enable syntax highlighting
filetype plugin indent on " Enable filetype-specific indenting and plugins

autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType ruby,perl,tex set shiftwidth=2
autocmd FileType c,cpp,java,javascript,python,xml,xhtml,html set shiftwidth=2
autocmd FileType javascript set shiftwidth=2

" Removes trailing spaces when saving the buffer
autocmd BufWritePre * :%s/\s\+$//e

augroup filetypedetect
  au! BufNewFile,BufRead *.ch setf cheat
  au BufNewFile,BufRead *.liquid setf liquid
  au! BufRead,BufNewFile *.haml setfiletype haml
  autocmd BufNewFile,BufRead *.yml setf eruby
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

"=====================================================================
" MAPPINGS
"=====================================================================
" Remove search highlighting with <ENTER>
:nnoremap <Space> :nohlsearch<cr>

" Changing tabs
nmap <Tab> :tabnext<CR>
nmap <S-Tab> :tabprevious<CR>

" Search for word under cursor using Ag
nmap <leader>f :Ag <C-R><C-W><CR>

"Remove trailing spaces with \rt
nmap <leader>rt :%s/\s\+$//<CR>

"Ctags search always lists all occurrences
"TODO: Change this so it's only mapped like that if the file is not Clojure
"If it's Clojure we want to use the C-] source code navigation provided by
" vim-iced
nmap <C-]> g<C-]>

"make Y consistent with C and D
nnoremap Y y$

" Align Ruby hashes
vmap ah :Align =><CR>
" Align by '='
vmap ae :Align =<CR>
" Align JavaScript objects with : (comma)
vmap ac :Align :<CR>
" Align blocks (or anything delimited by opening brackets)
vmap ab :Align {<CR>

" Save file as root
cnoremap sudow w !sudo tee % >/dev/null

" Clojure stuff (using vim-iced)
autocmd FileType clojure nmap <leader>b <Plug>(iced_barf)
autocmd FileType clojure nmap <leader>s <Plug>(iced_slurp)

" CamelCaseMotion mappings
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
map <silent> ge <Plug>CamelCaseMotion_ge
sunmap w
sunmap b
sunmap e
sunmap ge

if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-v><Esc> <Esc>
endif

"=====================================================================
" PLUGIN CONFIGURATIONS
"=====================================================================

" Load matchit (% to bounce from do to end, etc.)
runtime! plugin/matchit.vim
runtime! macros/matchit.vim

"Ctrl-P
let g:ctrlp_dotfiles = 0
let g:ctrlp_map = '<leader>p'
let g:ctrlp_max_files = 0

let g:ctrlp_custom_ignore = {'file': '\.git$\|\.hg$\|\.svn$\|\.beam$\|DS_Store', 'dir': '\v[\/](coverage|_build|node_modules)$', 'link': '',}
let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files']
let g:ctrlp_user_command = ['.hg/', 'hg --cwd %s locate -I .']
let g:ctrlp_open_new_file = 't'

" Vim Airline Settings
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 1
let g:airline#extensions#ale#enabled = 1

" vim-test settings
let test#strategy = "neovim"
nmap <silent> <leader>t :TestNearest<CR> " t Ctrl+n
" nmap <silent> <leader>b :TestFile<CR>    " t Ctrl+f
nmap <silent> t<C-s> :TestSuite<CR>   " t Ctrl+s
nmap <silent> t<C-l> :TestLast<CR>    " t Ctrl+l
nmap <silent> t<C-g> :TestVisit<CR>   " t Ctrl+g

" Open alternate files (uses the "alt" program)
" Run a given vim command on the results of alt from a given path.
" See usage below.
function! AltCommand(path, vim_command)
  let l:alternate = system("alt " . a:path)
  if empty(l:alternate)
    echo "No alternate file for " . a:path . " exists!"
  else
    exec a:vim_command . " " . l:alternate
  endif
endfunction

" Find the alternate file for the current path and open it
nnoremap <leader>. :w<cr>:call AltCommand(expand('%'), ':e')<cr>

" vim-iced configuration
let g:iced_enable_default_key_mappings = v:true

"=====================================================================
" Colorscheme, Tmux, etc
"=====================================================================
set background=dark
colorscheme Tomorrow-Night-Eighties

if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

"=====================================================================
" VIM SETTINGS
"=====================================================================
set encoding=utf-8 " Necessary to show unicode glyphs

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
set switchbuf=usetab
set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~,*.beam "stuff to ignore when tab completing

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
set nu  " Line numbers on
set nowrap  " Line wrapping off
set timeoutlen=250  " Time to wait after ESC (default causes an annoying delay)
set ignorecase smartcase
set hlsearch
set hidden

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
highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15

