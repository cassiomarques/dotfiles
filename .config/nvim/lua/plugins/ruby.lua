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
          init_options = {
            indexing = {
              -- Exclude heavy dirs from pattern-based indexing to speed up startup.
              -- Gems are still indexed via Bundler's gem resolution (only lib/ paths).
              excludedPatterns = {
                "**/vendor/gems/**/*",
                "**/vendor/ruby/**/*",
                "**/sorbet/**/*",
                "**/node_modules/**/*",
                "**/db/**/*",
              },
            },
          },
          -- Reset tagfunc so Ctrl+] uses ctags directly instead of trying
          -- LSP workspace/symbol (which ruby-lsp doesn't support).
          on_attach = function(client, bufnr)
            vim.bo[bufnr].tagfunc = ""
          end,
        },
        -- Disable solargraph — ruby-lsp is the primary Ruby LSP
        solargraph = { enabled = false },
      },
    },
  },
}
