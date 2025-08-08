local M = {}

function M.extract_package_names(lines)
  local packages = {}
  for _, line in ipairs(lines) do
    local clean_line = line:gsub("^%s*#%s*", "")
    clean_line = clean_line:gsub("^%s+", "")
    clean_line = clean_line:gsub("%s+$", "")

    local package = clean_line:match('brew%s+"([^"]+)"')
    if package then
      table.insert(packages, package)
    end

    local tap = clean_line:match('tap%s+"([^"]+)"')
    if tap then
      table.insert(packages, tap)
    end
  end
  return packages
end

function M.parse_packages_and_taps(lines)
  local regular_packages, taps = {}, {}
  for _, line in ipairs(lines) do
    local clean_line = line:gsub("^%s*#%s*", "")
    clean_line = clean_line:gsub("^%s+", "")
    clean_line = clean_line:gsub("%s+$", "")

    local package = clean_line:match('brew%s+"([^"]+)"')
    if package then
      table.insert(regular_packages, package)
    end

    local tap = clean_line:match('tap%s+"([^"]+)"')
    if tap then
      table.insert(taps, tap)
    end
  end
  return regular_packages, taps
end

function M.get_target_lines()
  local mode = vim.fn.mode()
  local lines = {}
  if mode == "v" or mode == "V" then
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_row = start_pos[2]
    local end_row = end_pos[2]
    for i = start_row, end_row do
      table.insert(lines, vim.fn.getline(i))
    end
  else
    table.insert(lines, vim.fn.getline("."))
  end
  return lines
end

function M.run_system(args, on_exit)
  if vim.system then
    vim.system(args, { text = true }, function(obj)
      vim.schedule(function()
        on_exit(obj.code)
      end)
    end)
  else
    vim.fn.jobstart(args, {
      stdout_buffered = true,
      on_exit = function(_, code)
        vim.schedule(function()
          on_exit(code)
        end)
      end,
    })
  end
end

function M.dump_brewfile_and_reload(brewfile_path, target_bufnr)
  if not brewfile_path or brewfile_path == "" then
    return
  end

  local buffer_modified = false
  if target_bufnr and vim.api.nvim_buf_is_valid(target_bufnr) then
    buffer_modified = vim.api.nvim_get_option_value("modified", { buf = target_bufnr })
  end

  local args = {
    "brew",
    "bundle",
    "dump",
    "--force",
    string.format("--file=%s", brewfile_path),
    "--describe",
  }

  M.run_system(args, function(code)
    if code == 0 then
      if target_bufnr and vim.api.nvim_buf_is_valid(target_bufnr) then
        local wins = vim.fn.win_findbuf(target_bufnr)
        if #wins > 0 then
          vim.api.nvim_win_call(wins[1], function()
            local ok_ft, ft = pcall(function()
              return vim.filetype.match({ buf = target_bufnr }) or vim.filetype.match({ filename = brewfile_path })
            end)

            if not buffer_modified then
              pcall(function()
                vim.cmd("silent edit!")
              end)
              if ok_ft and ft and ft ~= "" then
                pcall(function()
                  vim.bo[target_bufnr].filetype = ft
                end)
                pcall(function()
                  if vim.treesitter and vim.treesitter.start then
                    vim.treesitter.start(target_bufnr, ft)
                  end
                end)
                pcall(function()
                  vim.cmd("silent! setlocal syntax=" .. ft)
                end)
              end
            else
              pcall(function()
                vim.cmd("checktime")
              end)
            end
          end)
        end
      end
    else
      vim.notify("brew bundle dump failed", vim.log.levels.ERROR)
    end
  end)
end

return M
