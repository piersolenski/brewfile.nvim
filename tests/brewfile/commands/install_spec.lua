local plugin = require("brewfile")
local stub = require("luassert.stub")

describe("commands.install", function()
  before_each(function()
    plugin.setup({ dump_on_change = false })
  end)

  it("notifies when no packages", function()
    stub(vim.fn, "mode").returns("n")
    stub(vim.fn, "getline").returns("# comment only")
    stub(vim, "notify")
    stub(vim.fn, "confirm").returns(2)

    plugin.install()

    assert.stub(vim.notify).was.called()

    vim.fn.mode:revert()
    vim.fn.getline:revert()
    vim.notify:revert()
    vim.fn.confirm:revert()
  end)
end)
