local plugin = require("brewfile")

describe("Upgrade", function()
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

  it("runs brew upgrade for brew package", function()
    with_line("brew 'wget'", function()
      plugin.upgrade()
      assert.are.same({ "brew upgrade wget" }, recorded)
    end)
  end)

  it("runs cask upgrade for cask", function()
    with_line("cask 'docker'", function()
      plugin.upgrade()
      assert.are.same({ "brew upgrade --cask docker" }, recorded)
    end)
  end)
end)
