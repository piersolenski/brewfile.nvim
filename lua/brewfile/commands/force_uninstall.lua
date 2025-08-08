local util = require("brewfile.util")
local common = require("brewfile.commands.common")

return function()
  local lines = util.get_target_lines()
  local regular_packages, taps = util.parse_packages_and_taps(lines)
  if #regular_packages > 0 then
    common.run_brew_command("uninstall --force", regular_packages)
  end
  if #taps > 0 then
    common.run_brew_command("untap", taps)
  end
  if #regular_packages == 0 and #taps == 0 then
    vim.notify("No valid packages found", vim.log.levels.WARN)
  end
end
