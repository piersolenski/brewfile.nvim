local config = require("brewfile.config")

local M = {}

function M.setup(opts)
  config.setup(opts)
end

function M.install()
  require("brewfile.commands.install")()
end

function M.upgrade()
  require("brewfile.commands.upgrade")()
end

function M.uninstall()
  require("brewfile.commands.uninstall")()
end

function M.force_uninstall()
  require("brewfile.commands.force_uninstall")()
end

function M.info()
  require("brewfile.commands.info")()
end

function M.dump()
  require("brewfile.commands.dump")()
end

return M
