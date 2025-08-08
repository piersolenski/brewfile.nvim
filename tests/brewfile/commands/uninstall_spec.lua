local plugin = require("brewfile")
local stub = require("luassert.stub")
local match = require("luassert.match")

describe("commands.uninstall", function()
  before_each(function()
    plugin.setup({ dump_on_change = false })
  end)

  it("handles packages and taps", function()
    stub(vim.fn, "mode").returns("v")
    stub(vim.fn, "getpos").invokes(function(mark)
      if mark == "'<" then
        return { 0, 1, 0, 0 }
      end
      return { 0, 2, 0, 0 }
    end)
    stub(vim.fn, "getline").invokes(function(i)
      if i == 1 then
        return 'brew "fzf"'
      end
      return 'tap "homebrew/cask"'
    end)
    stub(vim.fn, "confirm").returns(1)
    stub(vim.cmd, "split")
    stub(vim.cmd, "startinsert")
    local original_cmd = vim.cmd
    vim.cmd = function() end
    stub(vim.api, "nvim_get_current_buf").returns(1)
    stub(vim.api, "nvim_buf_get_name").returns("/tmp/Brewfile")

    plugin.uninstall()

    assert.stub(vim.fn.confirm).was.called(2)

    vim.fn.mode:revert()
    vim.fn.getpos:revert()
    vim.fn.getline:revert()
    vim.fn.confirm:revert()
    vim.cmd.split:revert()
    vim.cmd.startinsert:revert()
    vim.api.nvim_get_current_buf:revert()
    vim.api.nvim_buf_get_name:revert()
    vim.cmd = original_cmd
  end)
end)
