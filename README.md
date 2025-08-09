# 🍺 brewfile.nvim

A Neovim plugin for managing your [Homebrew](https://brew.sh/) [Brewfile](https://docs.brew.sh/Brew-Bundle-and-Brewfile) directly from the editor.

## ✨ Features

Manage your packages with ease — install, upgrade, uninstall, force uninstall, or view info without leaving Neovim. After changes are made, the Brewfile is automatically dumped to keep it up-to-date.

## 📦 Package Support

This plugin supports managing packages from a variety of sources:

- **Homebrew**: Standard `brew` packages.
- **Cask**: `cask` packages for GUI applications.
- **Mac App Store**: `mas` packages for App Store applications (Requires [mas-cli](https://github.com/mas-cli/mas)).
- **VSCode**: `vscode` extensions (Requires [Visual Studio Code](https://code.visualstudio.com/)).

## 🔩 Installation

```lua
-- Lazy
{
	"piersolenski/brewfile.nvim",
    opts = {
        -- Auto-dump Brewfile after brew commands finish
        dump_on_change = true,
        -- Show confirmation prompts for uninstall actions
        confirmation_prompt = true,
    },
	keys = {
		{
			"<leader>bi",
			function()
				require("brewfile").install()
			end,
            desc = "Brew install package",
            mode = { "n" },
		},
        {
            "<leader>bb",
            function()
                require("brewfile").dump()
            end,
            desc = "Dump Brewfile and update the buffer",
            mode = { "n" },
        },
		{
			"<leader>bd",
			function()
				require("brewfile").uninstall()
			end,
            desc = "Brew uninstall package",
            mode = { "n" },
		},
		{
			"<leader>bD",
			function()
				require("brewfile").force_uninstall()
			end,
            desc = "Brew force uninstall package",
            mode = { "n" },
		},
		{
			"<leader>bI",
			function()
				require("brewfile").info()
			end,
            desc = "Brew info for package",
            mode = { "n" },
		},
	},
}
```

## 👨‍👩‍👧‍👦 Related projects

- **[gx.nvim](https://github.com/chrishrb/gx.nvim)** - Open Brewfile links in browser
- **[package-info.nvim](https://github.com/vuki656/package-info.nvim)** - Similar functionality for npm packages
