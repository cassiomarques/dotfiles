--~/personal/dotfiles/are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.snacks_animate = false

-- lua/config/options.lua

local opt = vim.opt

-- Shell
opt.shell = "/bin/zsh"

-- Path for finding files
opt.path = { vim.fn.getcwd() .. "/public/**", vim.fn.getcwd() .. "/**" }

-- Session options
opt.sessionoptions = "blank,buffers,curdir,help,resize,tabpages,winsize"

-- Wildmode / completion behavior
opt.wildmode = "list:longest"
opt.wildignore:append({ "*.o", "*.obj", "*~", "*.beam" })

-- Buffer switching behavior
opt.switchbuf = "usetab"

-- Scroll offsets
opt.scrolloff = 3
opt.sidescrolloff = 7
opt.sidescroll = 1

-- Clipboard (conditional on not being inside tmux)
if vim.env.TMUX == "" or vim.env.TMUX == nil then
  opt.clipboard:append("unnamed")
end

-- Autowrite on shell/make commands
opt.autowrite = true

-- Line wrapping off
opt.wrap = false

-- Timeout (LazyVim sets 300, adjust to taste)
opt.timeoutlen = 250

-- Case sensitivity
opt.ignorecase = true
opt.smartcase = true

-- Tab/indent width (LazyVim defaults to 4 in some cases, 2 is common preference)
opt.tabstop = 2
opt.shiftwidth = 2
opt.backspace = "indent,eol,start"

-- Error file jumping
opt.errorbells = false
opt.visualbell = false

-- Show matching brackets and blink duration
opt.showmatch = true
opt.matchtime = 5

-- List chars (shows tabs and line continuation)
opt.list = true
opt.listchars = { tab = "  ", extends = ">", precedes = "<" }

-- Hide mouse when typing
opt.mousehide = true

-- formatoptions (LazyVim touches this; override carefully)
opt.formatoptions = "tcqr"

-- Terminal cursor highlight
vim.api.nvim_set_hl(0, "TermCursorNC", { bg = "red", fg = "white" })
