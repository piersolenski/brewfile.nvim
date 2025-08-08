-- Homebrew Brewfile Management
local M = {}

-- configuration
M._defaults = {
  -- when true, after a brew action completes, run `brew bundle dump` and reload buffer
  dump_on_change = true,
}
M._config = vim.deepcopy(M._defaults)

-- setup for lazy.nvim and others
function M.setup(opts)
  M._config = vim.tbl_deep_extend("force", vim.deepcopy(M._defaults), opts or {})
end

-- Function to extract package names from brew lines
local function extract_package_names(lines)
  local packages = {}
  for _, line in ipairs(lines) do
    -- Remove leading/trailing whitespace and handle commented lines
    local clean_line = line:gsub("^%s*#%s*", "")
    clean_line = clean_line:gsub("^%s+", "")
    clean_line = clean_line:gsub("%s+$", "")

    -- Match brew "package" or brew "tap/package"
    local package = clean_line:match('brew%s+"([^"]+)"')
    if package then
      table.insert(packages, package)
    end

    -- Match tap "tap-name"
    local tap = clean_line:match('tap%s+"([^"]+)"')
    if tap then
      table.insert(packages, tap)
    end
  end
  return packages
end

-- Run `brew bundle dump` for the current Brewfile and reload buffer
local function run_system(args, on_exit)
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

local function dump_brewfile_and_reload(brewfile_path, target_bufnr)
    if not brewfile_path or brewfile_path == "" then
        return
    end

    -- Detect if buffer has unsaved changes; used to decide reload vs prompt
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

    run_system(args, function(code)
            if code == 0 then
                if target_bufnr and vim.api.nvim_buf_is_valid(target_bufnr) then
                    local wins = vim.fn.win_findbuf(target_bufnr)
                    if #wins > 0 then
                        vim.api.nvim_win_call(wins[1], function()
                            -- Determine filetype once
                            local ok_ft, ft = pcall(function()
                                return vim.filetype.match({ buf = target_bufnr })
                                    or vim.filetype.match({ filename = brewfile_path })
                            end)

                            if not buffer_modified then
                                -- Buffer unmodified: reload from disk and reapply ft/syntax
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
                                -- Buffer has local edits: trigger timestamp check to let user decide (W12)
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

-- Function to get the current line or visual selection
local function get_target_lines()
  local mode = vim.fn.mode()
  local lines = {}

  if mode == "v" or mode == "V" then
    -- Visual mode - get selected lines
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_row = start_pos[2]
    local end_row = end_pos[2]

    for i = start_row, end_row do
      table.insert(lines, vim.fn.getline(i))
    end
  else
    -- Normal mode - get current line
    table.insert(lines, vim.fn.getline("."))
  end

  return lines
end

-- Function to run brew command with confirmation
local function run_brew_command(command, packages)
  if #packages == 0 then
    vim.notify("No valid packages found", vim.log.levels.WARN)
    return
  end

  local package_list = table.concat(packages, ", ")
  local action = command

  -- Show confirmation dialog
  local choice = vim.fn.confirm(
    string.format("%s %d package(s): %s?", action:gsub("^%l", string.upper), #packages, package_list),
    "&Yes\n&No",
    2
  )

    if choice == 1 then
        -- Build the brew command
        local brew_cmd = string.format("brew %s %s", command, table.concat(packages, " "))
        vim.notify(string.format("Running: %s", brew_cmd), vim.log.levels.INFO)

        -- Capture the originating buffer (the Brewfile) before opening terminal
        local brewfile_bufnr = vim.api.nvim_get_current_buf()
        local brewfile_path = vim.api.nvim_buf_get_name(brewfile_bufnr)

        -- Open a split terminal and optionally hook into TermClose
        vim.cmd.split()
        vim.cmd(string.format("terminal %s", brew_cmd))
        vim.cmd.startinsert()
        if M._config.dump_on_change then
          vim.api.nvim_create_autocmd("TermClose", {
              buffer = 0, -- current (terminal) buffer
              once = true,
              callback = function()
                  dump_brewfile_and_reload(brewfile_path, brewfile_bufnr)
              end,
          })
        end
    end
end

function M.upgrade()
  local lines = get_target_lines()
  local packages = extract_package_names(lines)
  run_brew_command("upgrade", packages)
end

function M.uninstall()
  local lines = get_target_lines()

  -- For uninstall, use 'uninstall' for regular packages and 'untap' for taps
  local regular_packages = {}
  local taps = {}

  for _, line in ipairs(lines) do
    -- Remove leading/trailing whitespace and handle commented lines
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

  -- Handle regular packages
  if #regular_packages > 0 then
    run_brew_command("uninstall", regular_packages)
  end

  -- Handle taps separately
  if #taps > 0 then
    run_brew_command("untap", taps)
  end

  if #regular_packages == 0 and #taps == 0 then
    vim.notify("No valid packages found", vim.log.levels.WARN)
  end
end

function M.force_uninstall()
  local lines = get_target_lines()

  -- For uninstall, use 'uninstall --force' for regular packages and 'untap' for taps
  local regular_packages = {}
  local taps = {}

  for _, line in ipairs(lines) do
    -- Remove leading/trailing whitespace and handle commented lines
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

  -- Handle regular packages
  if #regular_packages > 0 then
    run_brew_command("uninstall --force", regular_packages)
  end

  -- Handle taps separately
  if #taps > 0 then
    run_brew_command("untap", taps)
  end

  if #regular_packages == 0 and #taps == 0 then
    vim.notify("No valid packages found", vim.log.levels.WARN)
  end
end

function M.install()
  local lines = get_target_lines()
  local taps = {}
  local regular_packages = {}

  for _, line in ipairs(lines) do
    -- Remove leading/trailing whitespace and handle commented lines
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

  -- Install taps first
  if #taps > 0 then
    run_brew_command("tap", taps)
  end

  -- Then install regular packages
  if #regular_packages > 0 then
    run_brew_command("install", regular_packages)
  end

  if #regular_packages == 0 and #taps == 0 then
    vim.notify("No valid packages found", vim.log.levels.WARN)
  end
end

function M.info()
  local lines = get_target_lines()
  local packages = extract_package_names(lines)
  if #packages > 0 then
    local brew_cmd = string.format("brew info %s", table.concat(packages, " "))
    vim.cmd(string.format("split | terminal %s", brew_cmd))
    vim.notify(string.format("Running: %s", brew_cmd), vim.log.levels.INFO)
  else
    vim.notify("No valid packages found", vim.log.levels.WARN)
  end
end

--- Dump Brewfile and refresh the buffer
function M.dump()
  local brewfile_bufnr = vim.api.nvim_get_current_buf()
  local brewfile_path = vim.api.nvim_buf_get_name(brewfile_bufnr)
  if not brewfile_path or brewfile_path == "" then
    vim.notify("Current buffer has no file path", vim.log.levels.WARN)
    return
  end
  dump_brewfile_and_reload(brewfile_path, brewfile_bufnr)
end

return M
