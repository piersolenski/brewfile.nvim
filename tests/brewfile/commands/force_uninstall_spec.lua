local plugin = require("brewfile")
local stub = require("luassert.stub")

describe("commands.force_uninstall", function()
  before_each(function()
    plugin.setup({ dump_on_change = false })
  end)

  it("confirms once for only packages", function()
    stub(vim.fn, "mode").returns("n")
    stub(vim.fn, "getline").returns('brew "ripgrep"')
    stub(vim.fn, "confirm").returns(1)
    -- avoid side effects from terminal
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

    plugin.force_uninstall()

    assert.stub(vim.fn.confirm).was.called(1)

    vim.fn.mode:revert()
    vim.fn.getline:revert()
    vim.fn.confirm:revert()
    vim.api.nvim_get_current_buf:revert()
    vim.api.nvim_buf_get_name:revert()
    vim.cmd = original_cmd
  end)
end)
