-- lua/plugins/gruvbox.lua
local function detect_system_theme()
  -- macOS: true/false from Appearance (Dark/Light)
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

  -- GNOME 42+: 'prefer-dark' or 'default'
  local ok_g, g = pcall(function()
    return vim.fn.system({ "gsettings", "get", "org.gnome.desktop.interface", "color-scheme" })
  end)
  if ok_g and type(g) == "string" then
    g = g:lower()
    if g:find("prefer%-dark") then return "dark" end
    return "light"
  end

  return "dark" -- fallback
end

local function apply_gruvbox()
  vim.o.background = detect_system_theme() -- "dark" or "light"
  vim.cmd.colorscheme("gruvbox")
end

return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      -- require("gruvbox").setup({}) -- optional tweaks
      apply_gruvbox()
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          local desired = detect_system_theme()
          if vim.o.background ~= desired then
            apply_gruvbox()
            vim.notify("Theme updated to " .. desired .. " (Gruvbox)")
          end
        end,
      })
    end,
  },
}

