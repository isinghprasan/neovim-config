-- Show line numbers in the left column
vim.opt.number = true

-- Define a :Source command to reload your nvim config from an open nvim editor
vim.api.nvim_create_user_command("Source", function()
	dofile(vim.env.MYVIMRC)
	print("Config reloaded")
end, {})
