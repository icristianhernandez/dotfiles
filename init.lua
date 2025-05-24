-- PSeInt Formatter Integration
--
-- Ensure you have python3 installed and pseint_formatter.py is executable.
-- Replace '/path/to/pseint_formatter.py' with the actual absolute path
-- to your pseint_formatter.py script in the formatter_cmd variable below.
--
-- Alternatively, if pseint_formatter.py is in your system's PATH, you can use:
-- local formatter_cmd = 'python3 pseint_formatter.py'
--
-- Or, if pseint_formatter.py is in the same directory as the .psc file:
-- local formatter_cmd = 'python3 ' .. vim.fn.expand('%:p:h') .. '/pseint_formatter.py'

if vim.fn.executable('python3') == 1 then
  -- Define the command to call the PSeInt formatter script.
  -- Users should change this path to the correct location of their script.
  local formatter_cmd = 'python3 /path/to/pseint_formatter.py'

  local function format_pseint(range_start, range_end)
    local save_cursor = vim.fn.winsaveview()
    local cmd_prefix
    if range_start == 0 and range_end == 0 then -- Whole buffer
      cmd_prefix = '%'
    else -- Range
      cmd_prefix = string.format("'%d,'%d", range_start, range_end)
    end

    local full_cmd = cmd_prefix .. '!' .. formatter_cmd

    -- Using a pcall to catch errors during the external command execution
    local status, err = pcall(vim.cmd, full_cmd)

    if not status then
      vim.notify("PSeInt formatting failed: " .. err, vim.log.levels.ERROR)
    end
    vim.fn.winrestview(save_cursor)
  end

  -- Normal mode mapping: format entire buffer
  vim.keymap.set('n', '<leader>fp', function()
    format_pseint(0, 0)
  end, { noremap = true, silent = true, desc = "Format PSeInt Buffer" })

  -- Visual mode mapping: format selected range
  -- <C-U> is not needed here as vim.fn.line("'<") and vim.fn.line("'>") work directly.
  vim.keymap.set('v', '<leader>fp', function()
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    format_pseint(start_line, end_line)
  end, { noremap = true, silent = true, desc = "Format PSeInt Selection" })

  vim.notify("PSeInt Formatter integration loaded. Use <leader>fp to format.", vim.log.levels.INFO)
else
  vim.notify("python3 executable not found. PSeInt formatter disabled.", vim.log.levels.WARN)
end
