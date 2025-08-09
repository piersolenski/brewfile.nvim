local util = require("brewfile.util")
local common = require("brewfile.commands.common")

return function()
  local lines = util.get_target_lines()
  if not lines or #lines == 0 then
    vim.notify("No lines found", vim.log.levels.WARN)
    return
  end

  local packages = util.extract_package_names(lines)
  common.run_command("upgrade", packages)
end
