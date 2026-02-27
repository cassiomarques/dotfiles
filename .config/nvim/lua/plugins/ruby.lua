-- Plugins for github/github monolith development
return {
  -- GitHub Copilot
  { "github/copilot.vim" },

  -- Ruby/Rails enhancements
  { "tpope/vim-rails" },
  { "tpope/vim-bundler" },

  -- Configure ruby_lsp server (gem installed by install.sh with project Ruby)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          mason = false,
          enabled = true,
          cmd = function(dispatchers, config)
            -- Use project Ruby so ruby-lsp finds the correct gem
            local ruby_sha = vim.fn.system("cat /workspaces/github/config/ruby-version 2>/dev/null"):gsub("%s+", "")
            local ruby_bin = "/workspaces/github/vendor/ruby/" .. ruby_sha .. "/bin"
            local cmd_env = { PATH = ruby_bin .. ":" .. vim.env.PATH }
            return vim.lsp.rpc.start(
              { "ruby-lsp" },
              dispatchers,
              {
                cwd = config and config.root_dir or nil,
                env = cmd_env,
              }
            )
          end,
        },
      },
    },
  },
}
