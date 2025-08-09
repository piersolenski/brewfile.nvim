local M = {}

M.defaults = {
  dump_on_change = true,
  confirm = true,
}

M.config = vim.deepcopy(M.defaults)

function M.setup(opts)
  opts = opts or {}
  vim.validate({
    dump_on_change = { opts.dump_on_change, "boolean", true },
    confirm = { opts.confirm, "boolean", true },
  })
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts)
end

return M
