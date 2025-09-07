vim.api.nvim_create_user_command("BrewfileInstall", function()
  require("brewfile").install()
end, { desc = "Brew install package" })

vim.api.nvim_create_user_command("BrewfileUpgrade", function()
  require("brewfile").upgrade()
end, { desc = "Brew upgrade package" })

vim.api.nvim_create_user_command("BrewfileUninstall", function()
  require("brewfile").uninstall()
end, { desc = "Brew uninstall package" })

vim.api.nvim_create_user_command("BrewfileForceUninstall", function()
  require("brewfile").force_uninstall()
end, { desc = "Brew force uninstall package" })

vim.api.nvim_create_user_command("BrewfileOpenHomepage", function()
  require("brewfile").open_homepage()
end, { desc = "Open package homepage" })

vim.api.nvim_create_user_command("BrewfileInfo", function()
  require("brewfile").info()
end, { desc = "Brew package info" })

vim.api.nvim_create_user_command("BrewfileDump", function()
  require("brewfile").dump()
end, { desc = "Dump Brewfile and refresh the buffer" })
