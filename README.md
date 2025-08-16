# 🍺 brewfile.nvim

Manage your [Homebrew](https://brew.sh/) [Brewfile](https://docs.brew.sh/Brew-Bundle-and-Brewfile) directly from Neovim!  

If you're on macOS and use [Homebrew](https://brew.sh/) (and let's be honest, who doesn't?), you probably have a [Brewfile](https://docs.brew.sh/Brew-Bundle-and-Brewfile) to manage your packages declaratively. `brewfile.nvim` lets you manage your Brewfile without ever leaving the editor!

## ✨ Features

- **Install/uninstall packages** - Just position your cursor on any line in your Brewfile and hit your keybind  
- **Auto-dumps Brewfile after changes** - Keeps your Brewfile in sync automatically  
- **Package info** - Get detailed package information
- **Safety first** - Optional confirmation prompts for destructive actions  

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

## 🚀 Usage

```sh
# Position cursor on any line in your Brewfile
brew "neovim"     -- <leader>bi to upgrade, <leader>bd to uninstall
cask "firefox"    -- Works with casks too!
mas "Xcode", id: 497799835  -- Even Mac App Store apps!
```

## 👨‍👩‍👧‍👦 Related projects

- **[gx.nvim](https://github.com/chrishrb/gx.nvim)** - Open Brewfile links in browser
- **[package-info.nvim](https://github.com/vuki656/package-info.nvim)** - Similar functionality for npm packages
