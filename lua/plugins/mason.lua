-- ~/.config/nvim/lua/plugins/mason.lua
return {
  -- Core Mason
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
      local bin = vim.fn.stdpath("data") .. "/mason/bin"
      if not (vim.env.PATH or ""):find(bin, 1, true) then
        vim.env.PATH = bin .. ":" .. (vim.env.PATH or "")
      end
    end,
  },

  -- LSP servers only
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "gopls",
        "terraformls",
        "tflint",      -- ok here: there is an lspconfig server named "tflint"
      },
      automatic_installation = true,
    },
  },

  -- CLI tools (non-LSP) like golangci-lint
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "golangci-lint",  -- ← belongs here, not in mason-lspconfig
        "tflint",         -- keep here too so the binary exists for its LSP / nvim-lint
      },
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 24,
    },
  },
}

