local plugin = require("brewfile")
local stub = require("luassert.stub")
local util = require("brewfile.util")

describe("commands.install", function()
  before_each(function()
    plugin.setup({ dump_on_change = false })
    stub(vim.fn, "confirm").returns(1)
    stub(vim.api, "nvim_get_current_buf").returns(1)
    stub(vim.api, "nvim_buf_get_name").returns("/tmp/Brewfile")
    stub(vim.cmd, "split")
    stub(vim.cmd, "terminal")
    stub(vim.cmd, "startinsert")
    stub(vim.api, "nvim_create_autocmd")
  end)

  after_each(function()
    vim.fn.confirm:revert()
    vim.api.nvim_get_current_buf:revert()
    vim.api.nvim_buf_get_name:revert()
    vim.cmd.split:revert()
    vim.cmd.terminal:revert()
    vim.cmd.startinsert:revert()
    vim.api.nvim_create_autocmd:revert()
    if type(util.extract_package_names) == "table" and util.extract_package_names.is_stub then
      util.extract_package_names:revert()
    end
    if vim.fn.mode.is_stub then
      vim.fn.mode:revert()
    end
    if vim.fn.getline.is_stub then
      vim.fn.getline:revert()
    end
  end)

  it("notifies when no packages", function()
    stub(vim.fn, "mode").returns("n")
    stub(vim.fn, "getline").returns("# comment only")
    stub(vim, "notify")
    stub(vim.fn, "confirm").returns(2)

    plugin.install()

    assert.stub(vim.notify).was.called()
  end)

  it("should generate the correct install commands", function()
    stub(util, "extract_package_names").returns({
      { name = "wget", type = "brew" },
      { name = "iterm2", type = "cask" },
      { name = "497799835", type = "mas", displayName = "Xcode" },
      { name = "dbaeumer.vscode-eslint", type = "vscode" },
    })
    stub(vim.fn, "mode").returns("n")
    stub(vim.fn, "getline").returns('brew "wget"')

    plugin.install()

    assert.stub(vim.cmd.terminal).was.called_with("brew install wget")
    assert.stub(vim.cmd.terminal).was.called_with("brew install --cask iterm2")
    assert.stub(vim.cmd.terminal).was.called_with("mas install 497799835")
    assert.stub(vim.cmd.terminal).was.called_with("code --install-extension dbaeumer.vscode-eslint")
  end)
end)
