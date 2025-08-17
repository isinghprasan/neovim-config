-- ~/.config/nvim/lua/util/lsp.lua
local M = {}

function M.on_attach(_, bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end
  map("n", "K",  vim.lsp.buf.hover,              "Hover")
  map("n", "gd", vim.lsp.buf.definition,         "Go to definition")
  map("n", "gr", vim.lsp.buf.references,         "References")
  map("n", "<leader>rn", vim.lsp.buf.rename,     "Rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action,"Code actions")
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
end

return M

