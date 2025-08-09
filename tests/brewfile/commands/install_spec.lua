local plugin = require("brewfile")

describe("Install", function()
  local original_confirm
  local recorded

  local function with_line(line, fn)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { line })
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    fn()
    vim.api.nvim_buf_delete(buf, { force = true })
  end

  before_each(function()
    plugin.setup({ dump_on_change = false })
    recorded = {}
    original_confirm = vim.fn.confirm
    vim.fn.confirm = function()
      return 1
    end
    vim.cmd.split = function() end
    vim.cmd.startinsert = function() end
    vim.cmd.terminal = function(cmd)
      table.insert(recorded, cmd)
    end
  end)

  after_each(function()
    vim.fn.confirm = original_confirm
  end)

  it("runs brew install for brew package", function()
    with_line("brew 'wget'", function()
      plugin.install()
      assert.are.same({ 'brew install "wget"' }, recorded)
    end)
  end)

  it("runs tap for tap", function()
    with_line("tap 'homebrew/cask'", function()
      plugin.install()
      assert.are.same({ 'brew tap "homebrew/cask"' }, recorded)
    end)
  end)

  it("runs cask install for cask", function()
    with_line("cask 'docker'", function()
      plugin.install()
      assert.are.same({ 'brew install --cask "docker"' }, recorded)
    end)
  end)

  it("runs mas install for mas", function()
    with_line("mas 'Xcode', id: 497799835", function()
      plugin.install()
      assert.are.same({ 'mas install "497799835"' }, recorded)
    end)
  end)

  it("runs code install for vscode", function()
    with_line("vscode 'ms-python.python'", function()
      plugin.install()
      assert.are.same({ 'code --install-extension "ms-python.python"' }, recorded)
    end)
  end)
end)
