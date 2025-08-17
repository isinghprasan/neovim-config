return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
      -- Add Mason's bin dir to PATH so nvim can find installed tools
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      if not string.find(vim.env.PATH or "", mason_bin, 1, true) then
        vim.env.PATH = mason_bin .. ":" .. (vim.env.PATH or "")
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      -- Both are LSP servers via lspconfig:
      --   terraformls → full Terraform language server
      --   tflint     → runs TFLint as an LSP (diagnostics, etc.)
      ensure_installed = { "terraformls", "tflint" },
      automatic_installation = true,
    },
  },
}

