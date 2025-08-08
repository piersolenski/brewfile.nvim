local util = require("brewfile.util")
local common = require("brewfile.commands.common")

return function()
  local lines = util.get_target_lines()
  local packages = util.extract_package_names(lines)
  common.run_brew_command("upgrade", packages)
end
