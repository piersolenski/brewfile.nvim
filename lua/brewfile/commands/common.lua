local config = require("brewfile.config")
local util = require("brewfile.util")

local M = {}

local command_map = {
  brew = {
    install = "brew install",
    upgrade = "brew upgrade",
    uninstall = "brew uninstall",
    force_uninstall = "brew uninstall --force",
    info = "brew info",
  },
  tap = {
    install = "brew tap",
    upgrade = nil, -- Not applicable
    uninstall = "brew untap",
    force_uninstall = nil, -- Not applicable
    info = "brew info",
  },
  cask = {
    install = "brew install --cask",
    upgrade = "brew upgrade --cask",
    uninstall = "brew uninstall --cask",
    force_uninstall = "brew uninstall --cask --force",
    info = "brew info --cask",
  },
  mas = {
    install = "mas install",
    upgrade = "mas upgrade",
    uninstall = "sudo mas uninstall",
    force_uninstall = "sudo mas uninstall", -- Not applicable
    info = nil, -- Not applicable
  },
  vscode = {
    install = "code --install-extension",
    upgrade = nil, -- Not applicable
    uninstall = "code --uninstall-extension",
    force_uninstall = nil, -- Not applicable
    info = nil, -- Not applicable
  },
}

function M.run_command(action, package)
  if not package then
    vim.notify("No valid package found", vim.log.levels.WARN)
    return
  end

  local package_name = package.displayName or package.name

  local choice = vim.fn.confirm(
    string.format("%s package: %s?", action:gsub("^%l", string.upper), package_name),
    "&Yes\n&No",
    2
  )

  if choice ~= 1 then
    return
  end

  local brewfile_bufnr = vim.api.nvim_get_current_buf()
  local brewfile_path = vim.api.nvim_buf_get_name(brewfile_bufnr)

  local cmd_template = command_map[package.type] and command_map[package.type][action]
  if cmd_template then
    local cmd = string.format("%s %s", cmd_template, package.name)
    vim.notify(string.format("Running: %s", cmd), vim.log.levels.INFO)

    vim.cmd.split()
    if vim.cmd.terminal then
      vim.cmd.terminal(cmd)
    else
      vim.cmd(string.format("terminal %s", cmd))
    end
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
  else
    vim.notify(
      string.format("Action '%s' not supported for package type '%s' (%s)", action, package.type, package.name),
      vim.log.levels.WARN
    )
  end
end

return M
