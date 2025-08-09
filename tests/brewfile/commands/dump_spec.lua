local plugin = require("brewfile")

describe("Dump", function()
  it("runs brew bundle dump and reloads", function()
    -- Create a scratch buffer with a file path
    local tmpfile = vim.fn.tempname()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, tmpfile)
    vim.api.nvim_set_current_buf(buf)

    -- Spy on util.run_system by monkeypatching to instantly call on_exit(0)
    local util = require("brewfile.util")
    local original = util.run_system
    local called_args
    util.run_system = function(args, on_exit)
      called_args = args
      on_exit(0)
    end

    plugin.dump()

    -- Validate correct brew command was constructed
    assert.is_truthy(called_args)
    assert.are.same("brew", called_args[1])
    assert.are.same("bundle", called_args[2])
    assert.are.same("dump", called_args[3])

    -- Restore
    util.run_system = original

    -- Cleanup
    vim.api.nvim_buf_delete(buf, { force = true })
  end)
end)
