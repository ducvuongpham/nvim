-- DiffFormat: Format only git hunks (changed lines)
local M = {}

-- Debug function
local function debug_print(msg)
  print("DiffFormat: " .. msg)
end

-- Get git hunks using git diff command
local function get_git_hunks()
  local hunks = {}
  local file_path = vim.api.nvim_buf_get_name(0)

  if file_path == "" then
    debug_print "No file path available"
    return hunks
  end

  debug_print("Getting hunks for: " .. file_path)

  -- Get git diff for current file (unstaged changes)
  local cmd = string.format("git diff -U0 --no-color %s", vim.fn.shellescape(file_path))
  local result = vim.fn.system(cmd)

  debug_print("Git diff command: " .. cmd)
  debug_print("Git diff exit code: " .. vim.v.shell_error)

  if vim.v.shell_error ~= 0 then
    debug_print "Git diff failed or no changes"
    return hunks
  end

  debug_print("Git diff output length: " .. #result)

  -- Parse diff output to find changed lines
  for line in result:gmatch "[^\r\n]+" do
    -- Look for hunk headers like: @@ -1,3 +1,4 @@
    local old_start, old_count, new_start, new_count = line:match "^@@%s+%-(%d+),?(%d*)%s+%+(%d+),?(%d*)%s+@@"

    if new_start then
      new_start = tonumber(new_start)
      new_count = new_count ~= "" and tonumber(new_count) or 1

      if new_count > 0 then -- Only include additions/modifications
        local end_line = new_start + new_count - 1
        table.insert(hunks, {
          start_line = new_start,
          end_line = end_line,
          type = "change",
        })
        debug_print(string.format("Found hunk: lines %d-%d", new_start, end_line))
      end
    end
  end

  debug_print("Total hunks found: " .. #hunks)
  return hunks
end

-- Simple test function
function M.test()
  debug_print "Testing DiffFormat..."
  local hunks = get_git_hunks()

  if #hunks == 0 then
    vim.notify("No git hunks found. Make sure you have unstaged changes.", vim.log.levels.WARN)
  else
    local info = {}
    for i, hunk in ipairs(hunks) do
      table.insert(info, string.format("Hunk %d: lines %d-%d", i, hunk.start_line, hunk.end_line))
    end
    vim.notify("Found hunks:\n" .. table.concat(info, "\n"), vim.log.levels.INFO)
  end
end

-- Format git hunks using LSP range formatting
function M.format_hunks()
  local hunks = get_git_hunks()

  if #hunks == 0 then
    vim.notify("No git hunks found in current buffer", vim.log.levels.INFO)
    return
  end

  debug_print("Starting to format " .. #hunks .. " hunks using LSP range formatting")

  -- Check if any LSP client supports range formatting
  local clients = vim.lsp.get_active_clients { bufnr = 0 }
  local range_client = nil

  for _, client in ipairs(clients) do
    if client.server_capabilities.documentRangeFormattingProvider then
      range_client = client
      debug_print("Found LSP client with range formatting: " .. client.name)
      break
    end
  end

  if not range_client then
    debug_print "No LSP client supports range formatting, falling back to simple method"
    M.format_hunks_simple()
    return
  end

  -- Format each hunk using LSP range formatting
  local formatted_count = 0
  for i, hunk in ipairs(hunks) do
    debug_print(string.format("Formatting hunk %d: lines %d-%d", i, hunk.start_line, hunk.end_line))

    local success, err = pcall(function()
      -- Use vim.lsp.buf.range_formatting
      local range = {
        start = {
          line = hunk.start_line - 1, -- 0-indexed line
          character = 0,
        },
        ["end"] = {
          line = hunk.end_line - 1, -- 0-indexed line
          character = 999, -- End of line
        },
      }

      debug_print(
        string.format(
          "LSP range: start=%d:%d, end=%d:%d",
          range.start.line,
          range.start.character,
          range["end"].line,
          range["end"].character
        )
      )

      -- Call LSP range formatting
      vim.lsp.buf.format {
        range = range,
        async = false,
      }
    end)

    if success then
      formatted_count = formatted_count + 1
      debug_print("Successfully formatted hunk " .. i)
    else
      debug_print("Failed to format hunk " .. i .. ": " .. tostring(err))
    end
  end

  vim.notify(string.format("Formatted %d/%d git hunks using LSP", formatted_count, #hunks), vim.log.levels.INFO)
end

-- Simple format hunks without range (fallback)
function M.format_hunks_simple()
  local hunks = get_git_hunks()

  if #hunks == 0 then
    vim.notify("No git hunks found in current buffer", vim.log.levels.INFO)
    return
  end

  -- Store original content
  local lines_before = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Format entire file
  require("conform").format { async = false, lsp_fallback = true }

  -- Get content after formatting
  local lines_after = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Restore non-hunk lines to original
  for line_num = 1, #lines_before do
    local is_in_hunk = false
    for _, hunk in ipairs(hunks) do
      if line_num >= hunk.start_line and line_num <= hunk.end_line then
        is_in_hunk = true
        break
      end
    end

    -- If line is not in any hunk, restore original
    if not is_in_hunk and line_num <= #lines_after then
      vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, { lines_before[line_num] })
    end
  end

  vim.notify("Formatted " .. #hunks .. " git hunks (using full-file method)", vim.log.levels.INFO)
end

-- Show git hunks info
function M.show_hunks()
  local hunks = get_git_hunks()

  if #hunks == 0 then
    vim.notify("No git hunks found in current buffer", vim.log.levels.INFO)
    return
  end

  local lines = { "Git hunks in current buffer:" }
  for i, hunk in ipairs(hunks) do
    table.insert(lines, string.format("  %d. Lines %d-%d (%s)", i, hunk.start_line, hunk.end_line, hunk.type))
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

-- Check git status
function M.git_status()
  local file_path = vim.api.nvim_buf_get_name(0)
  if file_path == "" then
    vim.notify("No file path", vim.log.levels.WARN)
    return
  end

  local cmd = "git status --porcelain " .. vim.fn.shellescape(file_path)
  local result = vim.fn.system(cmd)

  if vim.v.shell_error == 0 and result ~= "" then
    vim.notify("Git status: " .. vim.trim(result), vim.log.levels.INFO)
  else
    vim.notify("File not tracked by git or no changes", vim.log.levels.INFO)
  end
end

return M

