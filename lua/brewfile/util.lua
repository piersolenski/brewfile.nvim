local M = {}

function M.extract_package(line)
  if not line or line == "" then
    return nil
  end
  if line:match("^%s*#") then
    return nil
  end
  local clean_line = line:gsub("^%s+", ""):gsub("%s+$", "")

  local brew_pkg = clean_line:match("^brew%s+[\"']([^\"']+)[\"']")
  if brew_pkg then
    return { name = brew_pkg, type = "brew" }
  end

  local tap_pkg = clean_line:match("^tap%s+[\"']([^\"']+)[\"']")
  if tap_pkg then
    return { name = tap_pkg, type = "tap" }
  end

  local cask_pkg = clean_line:match("^cask%s+[\"']([^\"']+)[\"']")
  if cask_pkg then
    return { name = cask_pkg, type = "cask" }
  end

  local mas_pkg_id = clean_line:match("^mas%s+.-id:%s*(%d+)")
  if mas_pkg_id then
    local mas_pkg_name = clean_line:match("^mas%s+[\"']([^\"']+)[\"']")
    return { name = mas_pkg_id, type = "mas", displayName = mas_pkg_name or mas_pkg_id }
  end

  local vscode_pkg = clean_line:match("^vscode%s+[\"']([^\"']+)[\"']")
  if vscode_pkg then
    return { name = vscode_pkg, type = "vscode" }
  end

  return nil
end

function M.get_current_line()
  return vim.fn.getline(".")
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
