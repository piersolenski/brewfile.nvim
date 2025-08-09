local util = require("brewfile.util")

describe("util.extract_package_names", function()
  it("should correctly parse various package types", function()
    local lines = {
      'brew "wget"',
      'cask "iterm2"',
      'mas "Xcode", id: 497799835',
      'vscode "dbaeumer.vscode-eslint"',
      'tap "homebrew/bundle"',
    }
    local packages = util.extract_package_names(lines)
    assert.are.same(packages[1], { name = "wget", type = "brew" })
    assert.are.same(packages[2], { name = "iterm2", type = "cask" })
    assert.are.same(packages[3], { name = "497799835", type = "mas", displayName = "Xcode" })
    assert.are.same(packages[4], { name = "dbaeumer.vscode-eslint", type = "vscode" })
    assert.are.same(packages[5], { name = "homebrew/bundle", type = "tap" })
  end)
end)
