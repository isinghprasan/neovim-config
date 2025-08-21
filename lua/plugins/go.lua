-- Go: Treesitter + gopls (LSP) + format-on-save
local on_attach = require("util.lsp").on_attach

return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      local function add(lang)
        if not vim.tbl_contains(opts.ensure_installed, lang) then
          table.insert(opts.ensure_installed, lang)
        end
      end
      add("go"); add("gomod"); add("gowork")
      opts.highlight = opts.highlight or { enable = true }
      opts.indent = opts.indent or { enable = true }
      return opts
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- LSP: gopls
  {
    "neovim/nvim-lspconfig",
    ft = { "go", "gomod", "gowork" },
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")
      local function root_fallback(fname)
        return util.root_pattern("go.work", "go.mod", ".git")(fname)
            or util.path.dirname(fname)
      end
      lspconfig.gopls.setup({
        on_attach = on_attach,
        root_dir = root_fallback,
        single_file_support = true,
        settings = {
          gopls = {
            usePlaceholders = true,
            completeUnimported = true,
            analyses = { unusedparams = true, shadow = true },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })

      -- format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function(args)
          pcall(vim.lsp.buf.format, { bufnr = args.buf, timeout_ms = 2000 })
        end,
      })
    end,
  },
}

