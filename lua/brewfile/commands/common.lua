local config = require("brewfile.config")
local util = require("brewfile.util")

local M = {}

function M.run_brew_command(command, packages)
  if #packages == 0 then
    vim.notify("No valid packages found", vim.log.levels.WARN)
    return
  end

  local package_list = table.concat(packages, ", ")
  local action = command
  local choice = vim.fn.confirm(
    string.format("%s %d package(s): %s?", action:gsub("^%l", string.upper), #packages, package_list),
    "&Yes\n&No",
    2
  )

  if choice ~= 1 then
    return
  end

  local brew_cmd = string.format("brew %s %s", command, table.concat(packages, " "))
  vim.notify(string.format("Running: %s", brew_cmd), vim.log.levels.INFO)

  local brewfile_bufnr = vim.api.nvim_get_current_buf()
  local brewfile_path = vim.api.nvim_buf_get_name(brewfile_bufnr)

  vim.cmd.split()
  vim.cmd(string.format("terminal %s", brew_cmd))
  vim.cmd.startinsert()

  if config.config.dump_on_change then
    vim.api.nvim_create_autocmd("TermClose", {
      buffer = 0,
      once = true,
      callback = function()
        util.dump_brewfile_and_reload(brewfile_path, brewfile_bufnr)
      end,
    })
  end
end

return M
