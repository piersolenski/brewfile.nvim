local plugin = require("brewfile")

describe("Setup", function()
  it("accepts valid config", function()
    plugin.setup({
      dump_on_change = false,
    })
  end)

  it("rejects a broken config", function()
    assert.has_error(function()
      plugin.setup({ dump_on_change = "not-a-boolean" })
    end)
  end)
end)
