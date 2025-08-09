local plugin = require("brewfile")

describe("Info", function()
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

  it("shows brew info for brew package", function()
    with_line("brew 'wget'", function()
      plugin.info()
      assert.are.same({ 'brew info "wget"' }, recorded)
    end)
  end)

  it("shows cask info for cask", function()
    with_line("cask 'docker'", function()
      plugin.info()
      assert.are.same({ 'brew info --cask "docker"' }, recorded)
    end)
  end)

  it("shows tap info for tap", function()
    with_line("tap 'homebrew/cask'", function()
      plugin.info()
      assert.are.same({ 'brew info "homebrew/cask"' }, recorded)
    end)
  end)
end)
