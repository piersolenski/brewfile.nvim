local plugin = require("brewfile")
local stub = require("luassert.stub")

describe("commands.uninstall", function()
  before_each(function()
    plugin.setup({ dump_on_change = false })
  end)

  it("handles packages and taps", function()
    stub(vim.api, "nvim_get_mode").returns({ mode = "v" })
    stub(vim.fn, "getpos").invokes(function(mark)
      if mark == "v" then
        return { 0, 1, 0, 0 }
      end
      return { 0, 0, 0, 0 }
    end)
    stub(vim.fn, "getcurpos").returns({ 0, 2, 0, 0 })
    stub(vim.fn, "getline").invokes(function(i)
      if i == 1 then
        return 'brew "fzf"'
      end
      return 'tap "homebrew/cask"'
    end)
    stub(vim.fn, "confirm").returns(1)
    local original_cmd = vim.cmd
    vim.cmd = setmetatable({
      split = function() end,
      startinsert = function() end,
    }, {
      __call = function(_, _)
        -- swallow terminal invocation
      end,
    })
    stub(vim.api, "nvim_get_current_buf").returns(1)
    stub(vim.api, "nvim_buf_get_name").returns("/tmp/Brewfile")

    plugin.uninstall()

    assert.stub(vim.fn.confirm).was.called(1)

    vim.api.nvim_get_mode:revert()
    vim.fn.getpos:revert()
    vim.fn.getcurpos:revert()
    vim.fn.getline:revert()
    vim.fn.confirm:revert()
    vim.api.nvim_get_current_buf:revert()
    vim.api.nvim_buf_get_name:revert()
    vim.cmd = original_cmd
  end)
end)
