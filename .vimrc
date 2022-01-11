set nocompatible              " be iMproved, required

let g:python3_host_prog = '/Users/cassiomarquesdacruz/.asdf/shims/python'

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'vim-scripts/CSApprox'
Plug 'rking/ag.vim'
Plug 'vim-scripts/Align'
Plug 'jlanzarotta/bufexplorer'
Plug 'bkad/CamelCaseMotion'
Plug 'bling/vim-airline'
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-endwise'
Plug 'othree/yajs.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'lifepillar/pgsql.vim'
Plug 'tpope/vim-markdown'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-rails'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-fugitive'                                 " Git stuff
Plug 'tpope/vim-rhubarb'
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'gcmt/wildfire.vim'                                  " Select blocks of things
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'flazz/vim-colorschemes'                             " Lots of colorschemes
Plug 'rakr/vim-two-firewatch'
Plug 'vim-test/vim-test'
Plug 'thoughtbot/vim-rspec'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'
Plug 'elixir-editors/vim-elixir'
Plug 'c-brenn/phoenix.vim'
Plug 'slashmili/alchemist.vim'
Plug 'elmcast/elm-vim'
Plug 'thinca/vim-ref'
Plug 'jiangmiao/auto-pairs'
Plug 'leafgarland/typescript-vim'
Plug 'hashivim/vim-terraform'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-classpath'
Plug 'prabirshrestha/async.vim'
Plug 'tpope/vim-rbenv'
Plug 'kassio/neoterm'
Plug 'ekalinin/Dockerfile.vim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'onsails/lspkind-nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'kyazdani42/nvim-web-devicons'

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

"" Search for word under cursor using Ag
nmap <leader>f :Ag <C-R><C-W><CR>

"Remove trailing spaces with \rt
nmap <leader>rt :%s/\s\+$//<CR>

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

" Vim Airline Settings
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 1
let g:airline#extensions#ale#enabled = 1

" vim-rspec mappings
let test#strategy = "neoterm"
nmap <silent> <leader>t :TestNearest<CR> " t Ctrl+n
nmap <silent> <leader>b :TestFile<CR>    " t Ctrl+f
" nmap <silent> t<C-s> :TestSuite<CR>   " t Ctrl+s
" nmap <silent> t<C-l> :TestLast<CR>    " t Ctrl+l
" nmap <silent> t<C-g> :TestVisit<CR>   " t Ctrl+g

let g:neoterm_default_mod = "botright vertical"
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

"""""""""""""""""""
" Telescope Config
"""""""""""""""""""
nnoremap <Leader>p :lua require'telescope.builtin'.find_files{}<cr>
nnoremap <Leader>l :lua require'telescope.builtin'.live_grep{}<cr>

lua << EOF
require('telescope').setup {
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}
require('telescope').load_extension('fzy_native')
EOF

""""""""""""""""""""""""""""""""""""""""""""""""
" Neovim Language Server/autocomplete config
""""""""""""""""""""""""""""""""""""""""""""""""
lua << EOF
local lspconfig = require("lspconfig")

-- Neovim doesn't support snippets out of the box, so we need to mutate the
-- capabilities we send to the language server to let them know we want snippets.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require("cmp")

cmp.setup({
  completion = {
    autocomplete = false -- so we can trigger it manually
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
    i = cmp.mapping.abort(),
    c = cmp.mapping.close(),
    }),
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = 'vsnip' } -- For vsnip users.
  },
  formatting = {
    format = require("lspkind").cmp_format({
      with_text = true,
      menu = {
        nvim_lsp = "[LSP]",
        vsnip = "[S]"
      },
    }),
  },
})

-- A callback that will get called when a buffer connects to the language server.
-- Here we create any key maps that we want to have on that buffer.
local on_attach = function(_, bufnr)
  local function map(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local map_opts = {noremap = true, silent = true}

  map("n", "df", "<cmd>lua vim.lsp.buf.formatting()<cr>", map_opts)
  map("n", "gd", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", map_opts)
  map("n", "dt", "<cmd>lua vim.lsp.buf.definition()<cr>", map_opts)
  map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", map_opts)
  map("n", "gD", "<cmd>lua vim.lsp.buf.implementation()<cr>", map_opts)
  map("n", "<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", map_opts)
  map("n", "1gD", "<cmd>lua vim.lsp.buf.type_definition()<cr>", map_opts)

  -- DO I NEED THESE?
  vim.cmd [[imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']]
  vim.cmd [[smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']]

  vim.cmd [[imap <expr> <Tab> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>']]
  vim.cmd [[smap <expr> <Tab> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>']]
  vim.cmd [[imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>']]
  vim.cmd [[smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>']]

  -- vim.cmd [[inoremap <silent><expr> <C-Space> compe#complete()]]
  -- vim.cmd [[inoremap <silent><expr> <CR> compe#confirm('<CR>')]]
  -- vim.cmd [[inoremap <silent><expr> <C-e> compe#close('<C-e>')]]
  -- vim.cmd [[inoremap <silent><expr> <C-f> compe#scroll({ 'delta': +4 })]]
  -- vim.cmd [[inoremap <silent><expr> <C-d> compe#scroll({ 'delta': -4 })]]
  --
  -- tell nvim-cmp about our desired capabilities
  require("cmp_nvim_lsp").update_capabilities(capabilities)
end

-- Replace the following with the path to your installation
local path_to_elixirls = vim.fn.expand("~/personal/elixir-ls/release/language_server.sh")

lspconfig.elixirls.setup({
  cmd = {path_to_elixirls},
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    elixirLS = {
      -- I choose to disable dialyzer for personal reasons, but
      -- I would suggest you also disable it unless you are well
      -- aquainted with dialzyer and know how to use it.
      dialyzerEnabled = true,
      -- I also choose to turn off the auto dep fetching feature.
      -- It often get's into a weird state that requires deleting
      -- the .elixir_ls directory and restarting your editor.
      fetchDeps = false
    }
  }
})

-- Uses https://github.com/mattn/efm-langserver
-- to automatically format code via linters
lspconfig.efm.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {"elixir"},
  init_options = {documentFormatting = true},
    settings = {
        rootMarkers = {".git/"}
    }
})
EOF

" With this, triggering emmet auto generation of HTML markup becomes Ctrl-e,
let g:user_emmet_leader_key='<C-E>'

" Markdown composer config
let g:markdown_composer_autostart = 0

"=====================================================================
" Colorscheme, Tmux, etc
"=====================================================================
set background=dark
" set background=light
colorscheme Tomorrow-Night-Eighties
" colorscheme PaperColor

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
set number
set nowrap  " Line wrapping off
set timeoutlen=250  " Time to wait after ESC (default causes an annoying delay)
set ignorecase smartcase
set hlsearch
set hidden
set termguicolors

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

