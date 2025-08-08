local M = {}

M.defaults = {
  dump_on_change = true,
}

M.config = vim.deepcopy(M.defaults)

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts or {})
end

return M
