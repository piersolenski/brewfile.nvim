vim.api.nvim_create_user_command("BrewfileInstall", function()
  require("brewfile").install()
end, { desc = "Brew install package(s) from current line" })

vim.api.nvim_create_user_command("BrewfileUpgrade", function()
  require("brewfile").upgrade()
end, { desc = "Brew upgrade package(s) from current line" })

vim.api.nvim_create_user_command("BrewfileUninstall", function()
  require("brewfile").uninstall()
end, { desc = "Brew uninstall package(s) from current line" })

vim.api.nvim_create_user_command("BrewfileForceUninstall", function()
  require("brewfile").force_uninstall()
end, { desc = "Brew force uninstall package(s) from current line" })

vim.api.nvim_create_user_command("BrewfileInfo", function()
  require("brewfile").info()
end, { desc = "Brew info for package(s) on current line" })

vim.api.nvim_create_user_command("BrewfileDump", function()
  require("brewfile").dump()
end, { desc = "Dump Brewfile and refresh buffer" })
