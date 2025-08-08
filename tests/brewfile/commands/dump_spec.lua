local plugin = require("brewfile")
local util = require("brewfile.util")
local stub = require("luassert.stub")

describe("commands.dump", function()
  it("delegates to util.dump_brewfile_and_reload", function()
    stub(vim.api, "nvim_get_current_buf").returns(7)
    stub(vim.api, "nvim_buf_get_name").returns("/tmp/Brewfile")
    stub(util, "dump_brewfile_and_reload")

    plugin.dump()

    assert.stub(util.dump_brewfile_and_reload).was.called_with("/tmp/Brewfile", 7)

    vim.api.nvim_get_current_buf:revert()
    vim.api.nvim_buf_get_name:revert()
    util.dump_brewfile_and_reload:revert()
  end)
end)
