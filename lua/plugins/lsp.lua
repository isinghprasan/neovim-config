-- ~/.config/nvim/lua/plugins/lsp.lua
-- Global diagnostic keymaps + diagnostic styling.
-- Buffer-local LSP maps live in: ~/.config/nvim/lua/util/lsp.lua

return {
  "neovim/nvim-lspconfig",

  -- Load on idle so styling applies early.
  event = "VeryLazy",

  -- Always-available diagnostic keymaps (lazy will load on first press if needed).
  keys = {
    {
      "gl",
      function()
        vim.diagnostic.open_float(nil, {
          scope = "line",
          source = "if_many",
          border = "rounded",
        })
      end,
      desc = "Line diagnostics",
    },
    { "[d", vim.diagnostic.goto_prev, desc = "Prev diagnostic" },
    { "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },
    {
      "<leader>ld",
      function()
        vim.diagnostic.setloclist({ open = true })
      end,
      desc = "List diagnostics (loclist)",
    },
  },

  config = function()
    -- Diagnostic appearance
    vim.diagnostic.config({
      virtual_text = { spacing = 2, prefix = "●" }, -- set to false to disable inline text
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- Sign column symbols (swap for icons if your font supports them)
    local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
    for type, text in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = text, texthl = hl, numhl = "" })
    end
  end
}

