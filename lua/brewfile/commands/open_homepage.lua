local util = require("brewfile.util")

local M = {}

local url_map = {
  brew = function(name)
    return string.format("https://formulae.brew.sh/formula/%s", name)
  end,
  tap = function(name)
    local user, repo = name:match("^([^/]+)/([^/]+)$")
    if user and repo then
      return string.format("https://github.com/%s/homebrew-%s", user, repo)
    end
    return nil
  end,
  cask = function(name)
    return string.format("https://formulae.brew.sh/cask/%s", name)
  end,
  mas = function(_, package)
    local id = package.name
    return string.format("https://apps.apple.com/app/id%s", id)
  end,
  vscode = function(name)
    return string.format("https://marketplace.visualstudio.com/items?itemName=%s", name)
  end,
}

function M.open_homepage()
  local line = util.get_current_line()
  local package = util.extract_package(line)

  if not package then
    vim.notify("No valid package found on current line", vim.log.levels.WARN)
    return
  end

  local get_url = url_map[package.type]
  if not get_url then
    vim.notify(string.format("Opening homepage not supported for package type '%s'", package.type), vim.log.levels.WARN)
    return
  end

  local url = get_url(package.name, package)
  if not url then
    vim.notify(string.format("Could not generate URL for package '%s'", package.name), vim.log.levels.WARN)
    return
  end

  local open_cmd
  if vim.fn.has("mac") == 1 then
    open_cmd = "open"
  elseif vim.fn.has("unix") == 1 then
    open_cmd = "xdg-open"
  elseif vim.fn.has("win32") == 1 then
    open_cmd = "start"
  else
    vim.notify("Unable to detect system for opening URLs", vim.log.levels.ERROR)
    return
  end

  local cmd = string.format("%s %q", open_cmd, url)
  vim.fn.system(cmd)
  vim.notify(string.format("Opening %s", url), vim.log.levels.INFO)
end

return M
