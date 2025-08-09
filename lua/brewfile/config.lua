local M = {}

M.defaults = {
  dump_on_change = true,
  confirmation_prompt = true,
}

M.config = vim.deepcopy(M.defaults)

function M.setup(opts)
  opts = opts or {}
  vim.validate({
    dump_on_change = { opts.dump_on_change, "boolean", true },
    confirmation_prompt = { opts.confirmation_prompt, "boolean", true },
  })
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts)
end

return M
