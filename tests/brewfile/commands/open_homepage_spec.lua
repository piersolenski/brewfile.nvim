local open_homepage = require("brewfile.commands.open_homepage")

describe("open_homepage", function()
  local original_notify = vim.notify
  local original_system = vim.fn.system
  local notifications = {}
  local system_calls = {}

  before_each(function()
    notifications = {}
    system_calls = {}

    vim.notify = function(msg, level)
      table.insert(notifications, { msg = msg, level = level })
    end

    vim.fn.system = function(cmd)
      table.insert(system_calls, cmd)
      return ""
    end
  end)

  after_each(function()
    vim.notify = original_notify
    vim.fn.system = original_system
  end)

  it("should generate correct URL for brew packages", function()
    vim.fn.getline = function()
      return 'brew "pango"'
    end

    open_homepage.open_homepage()

    assert.is_true(#system_calls > 0)
    local cmd = system_calls[1]
    assert.is_not_nil(string.find(cmd, "https://formulae.brew.sh/formula/pango"))
  end)

  it("should generate correct URL for cask packages", function()
    vim.fn.getline = function()
      return 'cask "firefox"'
    end

    open_homepage.open_homepage()

    assert.is_true(#system_calls > 0)
    local cmd = system_calls[1]
    assert.is_not_nil(string.find(cmd, "https://formulae.brew.sh/cask/firefox"))
  end)

  it("should generate correct URL for tap packages", function()
    vim.fn.getline = function()
      return 'tap "homebrew/cask-versions"'
    end

    open_homepage.open_homepage()

    assert.is_true(#system_calls > 0)
    local cmd = system_calls[1]
    assert.is_not_nil(string.find(cmd, "https://github.com/homebrew/homebrew%-cask%-versions"))
  end)

  it("should generate correct URL for mas packages", function()
    vim.fn.getline = function()
      return 'mas "Xcode", id: 497799835'
    end

    open_homepage.open_homepage()

    assert.is_true(#system_calls > 0)
    local cmd = system_calls[1]
    assert.is_not_nil(string.find(cmd, "https://apps.apple.com/app/id497799835"))
  end)

  it("should generate correct URL for vscode packages", function()
    vim.fn.getline = function()
      return 'vscode "ms-python.python"'
    end

    open_homepage.open_homepage()

    assert.is_true(#system_calls > 0)
    local cmd = system_calls[1]
    assert.is_not_nil(string.find(cmd, "https://marketplace.visualstudio.com/items"))
    assert.is_not_nil(string.find(cmd, "ms%-python%.python"))
  end)

  it("should show warning for invalid package", function()
    vim.fn.getline = function()
      return "# This is a comment"
    end

    open_homepage.open_homepage()

    assert.equals(1, #notifications)
    assert.equals("No valid package found on current line", notifications[1].msg)
    assert.equals(vim.log.levels.WARN, notifications[1].level)
  end)
end)
