-- Plugins for github/github monolith development
return {
  -- GitHub Copilot
  { "github/copilot.vim" },

  -- Ruby/Rails enhancements
  { "tpope/vim-rails" },
  { "tpope/vim-bundler" },

  -- Auto-install ruby-lsp via mason
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "ruby-lsp",
      },
    },
  },
}
