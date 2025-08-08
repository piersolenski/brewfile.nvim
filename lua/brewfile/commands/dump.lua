local util = require("brewfile.util")

return function()
  local brewfile_bufnr = vim.api.nvim_get_current_buf()
  local brewfile_path = vim.api.nvim_buf_get_name(brewfile_bufnr)
  if not brewfile_path or brewfile_path == "" then
    vim.notify("Current buffer has no file path", vim.log.levels.WARN)
    return
  end
  util.dump_brewfile_and_reload(brewfile_path, brewfile_bufnr)
end
