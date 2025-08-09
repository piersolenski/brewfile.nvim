local plugin = require("brewfile")

describe("Setup", function()
  it("accepts valid config", function()
    plugin.setup({
      dump_on_change = false,
      confirmation_prompt = true,
    })
  end)

  it("rejects a broken config", function()
    assert.has_error(function()
      plugin.setup({ dump_on_change = "not-a-boolean" })
    end)
  end)

  it("accepts disabling confirm", function()
    plugin.setup({ confirmation_prompt = false })
  end)
end)
