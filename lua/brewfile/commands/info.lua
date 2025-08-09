local util = require("brewfile.util")
local common = require("brewfile.commands.common")

return function()
  local line = util.get_current_line()
  if not line or line == "" then
    vim.notify("No line found", vim.log.levels.WARN)
    return
  end

  local package = util.extract_package(line)
  common.run_command("info", package, false)
end
