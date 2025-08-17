return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "lua", "hcl", "json", "yaml" }, -- add "go", "gomod" later
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
}
