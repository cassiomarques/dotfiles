return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.completion = opts.completion or {}
    opts.completion.trigger = {
      show_on_insert = false,
      show_on_keyword = false,
      show_on_trigger_character = false,
      show_on_insert_on_trigger_character = false,
      show_on_accept_on_trigger_character = false,
      show_on_backspace = false,
      show_on_backspace_after_accept = false,
      show_on_backspace_after_insert_enter = false,
      show_on_backspace_in_keyword = false,
      show_in_snippet = false,
    }

    opts.keymap = {
      preset = "none",
      ["<Tab>"] = { "show", "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
    }

    return opts
  end,
}
