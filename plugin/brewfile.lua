vim.api.nvim_create_user_command("BrewfileInstall", function()
  require("brewfile").install()
end, { range = true, desc = "Brew install package(s) from current line/selection" })

vim.api.nvim_create_user_command("BrewfileUpgrade", function()
  require("brewfile").upgrade()
end, { range = true, desc = "Brew upgrade package(s) from current line/selection" })

vim.api.nvim_create_user_command("BrewfileUninstall", function()
  require("brewfile").uninstall()
end, { range = true, desc = "Brew uninstall package(s) from current line/selection" })

vim.api.nvim_create_user_command("BrewfileForceUninstall", function()
  require("brewfile").force_uninstall()
end, { range = true, desc = "Brew force uninstall package(s) from current line/selection" })

vim.api.nvim_create_user_command("BrewfileInfo", function()
  require("brewfile").info()
end, { range = true, desc = "Brew info for package(s) on current line/selection" })
