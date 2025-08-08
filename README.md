# 🍺 brewfile.nvim

A Neovim plugin for managing your [Homebrew](https://brew.sh/) [Brewfile](https://docs.brew.sh/Brew-Bundle-and-Brewfile) directly from the editor.

## ✨ Features

- **Install, Upgrade, Uninstall, Force Uninstall**: Run Homebrew commands on selected lines or the current line in your Brewfile.
- **Tap Management**: Handles both regular packages and taps.
- **Interactive Confirmation**: Prompts before running destructive actions.
- **Automatic Brewfile Reload**: Updates the buffer after changes.
- **Terminal Integration**: Opens a split terminal for command output.
- **Visual Selection Support**: Works with visual mode selections.

## 🔩 Installation

```lua
-- Lazy
{
	"piersolenski/brewfile.nvim",
	opts = {},
	keys = {
		{
			"<leader>bi",
			function()
				require("brewfile").install()
			end,
			desc = "Brew install package(s)",
			mode = { "n", "v" },
		},
		{
			"<leader>bu",
			function()
				require("brewfile").upgrade()
			end,
			desc = "Brew upgrade package(s)",
			mode = { "n", "v" },
		},
		{
			"<leader>bd",
			function()
				require("brewfile").uninstall()
			end,
			desc = "Brew uninstall package(s)",
			mode = { "n", "v" },
		},
		{
			"<leader>bD",
			function()
				require("brewfile").force_uninstall()
			end,
			desc = "Brew force uninstall package(s)",
			mode = { "n", "v" },
		},
		{
			"<leader>bI",
			function()
				require("brewfile").info()
			end,
			desc = "Brew info for latest package",
			mode = { "n", "v" },
		},
	},
}
```

## 👨‍👩‍👧‍👦 Related projects

- **[gx.nvim](https://github.com/chrishrb/gx.nvim)** - Open Brewfile links in browser
- **[package-info.nvim](https://github.com/vuki656/package-info.nvim)** - Similar functionality for npm packages
