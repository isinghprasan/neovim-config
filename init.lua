-- Show line numbers in the left column
vim.opt.number = true

-- Define a :Source command to reload your nvim config from an open nvim editor
vim.api.nvim_create_user_command("Source", function()
	dofile(vim.env.MYVIMRC)
	print("Config reloaded")
end, {})

-- Use true colors (16M) if the terminal supports it
vim.opt.termguicolors = true


-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- load plugins from lua/plugins/*.lua
require("lazy").setup("plugins")
