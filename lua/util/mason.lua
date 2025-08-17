local M = {}

function M.ensure_tools(tools)
  local ok, registry = pcall(require, "mason-registry")
  if not ok then return end
  for _, name in ipairs(tools) do
    local ok_pkg, pkg = pcall(registry.get_package, name)
    if ok_pkg and not pkg:is_installed() then
      pkg:install()
    end
  end
end

return M
