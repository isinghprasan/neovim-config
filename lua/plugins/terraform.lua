-- Terraform support: Treesitter + LSP (terraformls + tflint) + format-on-save.
-- Requires: ~/.config/nvim/lua/util/lsp.lua exporting M.on_attach

local on_attach = require("util.lsp").on_attach

return {
  -- Syntax & indent for HCL/Terraform
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "hcl") then
        table.insert(opts.ensure_installed, "hcl")
      end
      opts.highlight = opts.highlight or { enable = true }
      opts.indent = opts.indent or { enable = true }
      return opts
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- LSP: terraformls + tflint with robust root_dir
  {
    "neovim/nvim-lspconfig",
    ft = { "terraform", "terraform-vars", "hcl" }, -- load when these filetypes open
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      -- Ensure filetypes are recognized
      vim.filetype.add({
        extension = { tf = "terraform", tfvars = "terraform", hcl = "hcl" },
      })

      -- Root detection: prefer .terraform / .git / .tflint.hcl, else fallback to file's dir
      local function root_fallback(fname)
        return util.root_pattern(".terraform", ".git", ".tflint.hcl")(fname)
            or util.path.dirname(fname)
      end

      -- Main Terraform language server
      lspconfig.terraformls.setup({
        on_attach = on_attach,
        filetypes = { "terraform", "terraform-vars", "hcl" },
        root_dir = root_fallback,
        single_file_support = true,
      })

      -- TFLint as an LSP (diagnostics)
      lspconfig.tflint.setup({
        on_attach = on_attach,
        filetypes = { "terraform" },
        root_dir = root_fallback,
      })

      -- Format on save via LSP (gracefully no-ops if formatter unavailable)
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.tf", "*.tfvars", "*.hcl" },
        callback = function(args)
          pcall(vim.lsp.buf.format, { bufnr = args.buf, timeout_ms = 2000 })
        end,
      })
    end,
  },
}

