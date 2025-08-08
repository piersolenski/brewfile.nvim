local plugin = require("brewfile")
local stub = require("luassert.stub")

describe("commands.upgrade", function()
  before_each(function()
    plugin.setup({ dump_on_change = false })
  end)

  it("confirms and opens terminal path", function()
    stub(vim.fn, "mode").returns("n")
    stub(vim.fn, "getline").returns('brew "fzf"')
    stub(vim.fn, "confirm").returns(1)
    stub(vim, "notify")
    stub(vim.cmd, "split")
    stub(vim.cmd, "startinsert")
    local original_cmd = vim.cmd
    vim.cmd = function() end
    stub(vim.api, "nvim_get_current_buf").returns(1)
    stub(vim.api, "nvim_buf_get_name").returns("/tmp/Brewfile")

    plugin.upgrade()

    vim.fn.mode:revert()
    vim.fn.getline:revert()
    vim.fn.confirm:revert()
    vim.notify:revert()
    vim.cmd.split:revert()
    vim.cmd.startinsert:revert()
    vim.api.nvim_get_current_buf:revert()
    vim.api.nvim_buf_get_name:revert()
    vim.cmd = original_cmd
  end)
end)
