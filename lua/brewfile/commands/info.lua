local util = require("brewfile.util")

return function()
  local lines = util.get_target_lines()
  local packages = util.extract_package_names(lines)
  if #packages > 0 then
    local brew_cmd = string.format("brew info %s", table.concat(packages, " "))
    vim.cmd(string.format("split | terminal %s", brew_cmd))
    vim.notify(string.format("Running: %s", brew_cmd), vim.log.levels.INFO)
  else
    vim.notify("No valid packages found", vim.log.levels.WARN)
  end
end
