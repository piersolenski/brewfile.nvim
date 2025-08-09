local plugin = require("brewfile")
local config = require("brewfile.config")
local util = require("brewfile.util")

describe("brewfile.nvim API", function()
  it("exposes expected functions", function()
    assert(type(plugin.install) == "function", "install should be a function")
    assert(type(plugin.upgrade) == "function", "upgrade should be a function")
    assert(type(plugin.uninstall) == "function", "uninstall should be a function")
    assert(type(plugin.force_uninstall) == "function", "force_uninstall should be a function")
    assert(type(plugin.info) == "function", "info should be a function")
    assert(type(plugin.dump) == "function", "dump should be a function")
  end)
end)

describe("parsing", function()
  it("extracts packages and taps from mixed lines", function()
    local lines = {
      'brew "fzf"',
      '  brew   "ripgrep"  ',
      'tap "homebrew/cask"',
      '  # brew "commented"',
      ' # tap "ignored/tap" ',
      'brew "homebrew/cask/iterm2"',
    }
    local packages = util.extract_package_names(lines)

    local brew_names, tap_names = {}, {}
    for _, pkg in ipairs(packages) do
      if pkg.type == "brew" then
        table.insert(brew_names, pkg.name)
      end
      if pkg.type == "tap" then
        table.insert(tap_names, pkg.name)
      end
    end

    assert.same({ "fzf", "ripgrep", "homebrew/cask/iterm2" }, brew_names)
    assert.same({ "homebrew/cask" }, tap_names)
  end)
end)

describe("config", function()
  it("resets to defaults on setup without opts", function()
    plugin.setup()
    -- ensure it doesn't error and retains table type
    plugin.setup({})
  end)
  it("toggles dump_on_change", function()
    plugin.setup({ dump_on_change = false })
    assert.is_false(config.config.dump_on_change)
    plugin.setup({ dump_on_change = true })
    assert.is_true(config.config.dump_on_change)
  end)
  it("rejects invalid value", function()
    assert.error_matches(function()
      plugin.setup({ dump_on_change = "bananas" })
    end, "dump_on_change: expected boolean, got string")
  end)
end)
