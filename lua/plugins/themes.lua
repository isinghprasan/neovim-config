-- lua/plugins/themes.lua
-- Minimal theme manager + a few popular themes to try

-- Detect OS light/dark (macOS + GNOME); fallback = "dark"
local function detect_system_theme()
  local ok_mac, mac = pcall(function()
    return vim.fn.system({ "osascript", "-e",
      [[tell application "System Events" to tell appearance preferences to get dark mode]]
    })
  end)
  if ok_mac and type(mac) == "string" then
    mac = mac:lower()
    if mac:find("true") then return "dark" end
    if mac:find("false") then return "light" end
  end

  local ok_g, g = pcall(function()
    return vim.fn.system({ "gsettings", "get", "org.gnome.desktop.interface", "color-scheme" })
  end)
  if ok_g and type(g) == "string" then
    g = g:lower()
    if g:find("prefer%-dark") then return "dark" end
    return "light"
  end

  return "dark"
end

-- Apply a theme by name, respecting system light/dark
local function apply(name)
  local bg = detect_system_theme()
  vim.o.background = bg

  -- Per-theme optional tweaks
  if name == "catppuccin" then
    -- Pick flavor by background
    vim.g.catppuccin_flavour = (bg == "dark") and "mocha" or "latte"
  end

  vim.cmd.colorscheme(name)
  vim.g._theme_name = name
end

-- Commands to switch / toggle themes quickly
vim.api.nvim_create_user_command("SetTheme", function(opts)
  apply(opts.args)
end, {
  nargs = 1,
  complete = function()
    return { "gruvbox", "tokyonight", "catppuccin", "rose-pine", "kanagawa", "onedark", "everforest" }
  end,
})

vim.api.nvim_create_user_command("ThemeToggle", function()
  vim.o.background = (vim.o.background == "dark") and "light" or "dark"
  apply(vim.g._theme_name or "gruvbox")
end, {})

-- Re-apply on focus in case OS theme changed
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    local desired = detect_system_theme()
    if desired ~= vim.o.background then
      apply(vim.g._theme_name or "gruvbox")
      vim.notify("Theme updated to " .. desired)
    end
  end,
})

-- Pick your default startup theme here:
local default_theme = "gruvbox"

return {
  -- Load your default theme early so UI is colored from the start
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      apply(default_theme)
    end,
  },

  -- A few popular themes to try (loaded on demand)
  { "folke/tokyonight.nvim", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "navarasu/onedark.nvim", lazy = true },
  { "sainnhe/everforest", lazy = true },
}

