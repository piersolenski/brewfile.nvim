local plugin = require("brewfile")

describe("Force Uninstall", function()
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
    plugin.setup({ dump_on_change = false, confirmation_prompt = true })
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

  it("forces cask uninstall", function()
    with_line("cask 'docker'", function()
      plugin.force_uninstall()
      assert.are.same({ "brew uninstall --cask --force docker" }, recorded)
    end)
  end)

  it("forces brew uninstall", function()
    with_line("brew 'wget'", function()
      plugin.force_uninstall()
      assert.are.same({ "brew uninstall --force wget" }, recorded)
    end)
  end)

  it("skips confirm when confirm=false", function()
    plugin.setup({ dump_on_change = false, confirmation_prompt = false })
    local asked = false
    vim.fn.confirm = function()
      asked = true
      return 2
    end
    with_line("brew 'wget'", function()
      plugin.force_uninstall()
      assert.are.same({ "brew uninstall --force wget" }, recorded)
      assert.is_false(asked)
    end)
  end)
end)
