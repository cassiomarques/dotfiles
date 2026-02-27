-- Plugins for github/github monolith development
return {
  -- GitHub Copilot
  { "github/copilot.vim" },

  -- Ruby/Rails enhancements
  { "tpope/vim-rails" },
  { "tpope/vim-bundler" },

  -- Configure ruby_lsp server (gem + wrapper installed by install.sh)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          mason = false,
          enabled = true,
          cmd = { "ruby-lsp" },
        },
      },
    },
  },
}
