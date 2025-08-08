# 🍺 brewfile.nvim

A Neovim plugin for managing your [Homebrew](https://brew.sh/) [Brewfile](https://docs.brew.sh/Brew-Bundle-and-Brewfile) directly from the editor.

## ✨ Features

* **Package Actions**: Install, upgrade, uninstall, force uninstall, and view info for packages.
* **Tap Management**: Works with both regular packages and taps.
* **Interactive Confirmation**: Prompts before performing destructive actions.
* **Auto Brewfile Reload**: Dumps Brewfile and refreshes the buffer after changes.
* **Terminal Integration**: Briefly opens a split terminal for command output.
* **Visual Selection Support**: Manage multiple packages at once using visual mode.

## 🔩 Installation

```lua
-- Lazy
{
	"piersolenski/brewfile.nvim",
	opts = {
		-- Auto-dump Brewfile after brew commands finish
		dump_on_change = true,
	},
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
