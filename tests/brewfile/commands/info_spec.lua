local plugin = require("brewfile")
local stub = require("luassert.stub")
local match = require("luassert.match")

describe("commands.info", function()
  before_each(function()
    plugin.setup({ dump_on_change = false })
  end)

  it("notifies with brew info", function()
    stub(vim.fn, "mode").returns("n")
    stub(vim.fn, "getline").returns('brew "fd"')
    stub(vim, "notify")

    local original_cmd = vim.cmd
    vim.cmd = function() end

    plugin.info()

    assert.stub(vim.notify).was.called_with(match.matches("brew info"), vim.log.levels.INFO)

    vim.fn.mode:revert()
    vim.fn.getline:revert()
    vim.notify:revert()
    vim.cmd = original_cmd
  end)
end)
