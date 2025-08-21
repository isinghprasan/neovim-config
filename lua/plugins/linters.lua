-- Central nvim-lint config (avoids duplicate/early setups)
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" }, -- load early, after a file opens
  config = function()
    local lint = require("lint")
    local util = require("lspconfig.util")
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

    -- Register linters per filetype
    lint.linters_by_ft = {
      go = { "golangcilint" },
      terraform = { "tflint" },
      ["terraform-vars"] = { "tflint" },
      hcl = { "tflint" },
    }

    -- tflint: use Mason binary if present
    if lint.linters.tflint then
      lint.linters.tflint.cmd = mason_bin .. "/tflint"
    end

    -- golangci-lint: harden args & run from module root
    local gci = lint.linters.golangcilint
    if gci then
      gci.cmd = mason_bin .. "/golangci-lint"
      gci.stdin = false
      gci.ignore_exitcode = true
      gci.args = { "run", "--out-format", "json" }
      gci.cwd = function(bufnr)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        return util.root_pattern("go.work", "go.mod", ".git")(fname) or vim.fn.getcwd()
      end
    end

    -- Trigger linting
    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
      callback = function() require("lint").try_lint() end,
    })
  end,
}

