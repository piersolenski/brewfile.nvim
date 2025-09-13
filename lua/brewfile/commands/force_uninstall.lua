local util = require("brewfile.util")
local common = require("brewfile.commands.common")

return function()
  local line = util.get_current_line_or_warn()
  if not line then
    return
  end

  local package = util.extract_package(line)
  common.run_command("force_uninstall", package, true)
end
