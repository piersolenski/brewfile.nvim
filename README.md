# 🍺 brewfile.nvim

If you're on macOS and use [Homebrew](https://brew.sh/), you probably have a [Brewfile](https://docs.brew.sh/Brew-Bundle-and-Brewfile) to manage your packages declaratively. `brewfile.nvim` lets you manage your that Brewfile from within your favourite editor, giving you even less reasons to leave Vim or go outside. Why get Vitamin D when you can be installing and uninstalling apps, casks, and extensions at blazingly fast speeds?

## ✨ Features

- **Install/uninstall packages** - Just position your cursor on any line in your Brewfile and hit your keybind  
- **Auto-dumps Brewfile after changes** - Keeps your Brewfile in sync automatically  
- **Package info** - Get detailed package information
- **Safety first** - Optional confirmation prompts for destructive actions

https://github.com/user-attachments/assets/2426cb0b-2fe3-465c-a44d-5234f260028e

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
			"<leader>b",
			desc = "Brewfile",
		},
		{
			"<leader>bi",
			function()
				require("brewfile").install()
			end,
            desc = "Brew install package",
            mode = { "n" },
		},
        {
            "<leader>br",
            function()
                require("brewfile").dump()
            end,
            desc = "Dump Brewfile and refresh the buffer",
            mode = { "n" },
        },
        {
            "<leader>bo",
            function()
                require("brewfile").open_homepage()
            end,
            desc = "Open package homepage",
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
            desc = "Brew package info",
            mode = { "n" },
        },
        {
            "<leader>bu",
            function()
                require("brewfile").upgrade()
            end,
            desc = "Brew upgrade package",
            mode = { "n" },
        }
	}
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

## 🤓 About the author

As well as a passionate Vim enthusiast, I am a Full Stack Developer and Technical Lead from London, UK.

Whether it's to discuss a project, talk shop or just say hi, I'd love to hear from you!

- [Website](https://www.piersolenski.com/)
- [CodePen](https://codepen.io/piers)
- [LinkedIn](https://www.linkedin.com/in/piersolenski/)

<a href='https://ko-fi.com/piersolenski' target='_blank'>
  <img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' />
</a>
