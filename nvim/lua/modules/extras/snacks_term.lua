-- Lightweight wrapper around folke/snacks.nvim to: track last terminal,
-- toggle the last terminal, and present a `vim.ui.select` picker for all
-- snacks terminals.

local Snacks = require("snacks")
local M = { last = nil, seq = 0 }

local function shallow_copy(t)
  if type(t) ~= "table" then
    return t
  end
  local out = {}
  for k, v in pairs(t) do
    out[k] = v
  end
  return out
end

local function save_last(cmd, opts)
  -- store copies to avoid accidental external mutation
  M.last = M.last or {}
  M.last.cmd = shallow_copy(cmd)
  M.last.opts = shallow_copy(opts or {})
  -- clear any cached instance when opts change
  M.last.win = nil
end

local function save_last_from_win(win, meta)
  M.last = M.last or {}
  M.last.win = win
  if meta then
    M.last.cmd = shallow_copy(meta.cmd)
    M.last.opts = shallow_copy({ count = meta.id, cwd = meta.cwd, env = meta.env })
  else
    M.last.cmd = shallow_copy(win.cmd)
    M.last.opts = shallow_copy(win.opts or {})
  end
end

-- helper to ensure module is available during early startup
local function safe_require()
  if not Snacks then
    pcall(function() Snacks = require("snacks") end)
  end
end

-- Open a terminal and mark it as last
function M.open(cmd, opts)
  opts = opts or {}
  -- if caller requests a brand new terminal, give it a unique `count`
  if opts.new then
    M.seq = M.seq + 1
    opts.count = M.seq
    -- don't leak the `new` flag into snacks
    opts.new = nil
  end

  -- open and keep the instance reference when possible
  local term = Snacks.terminal.open(cmd, opts)
  -- terminal.open returns the terminal instance; save it as last
  if term then
    save_last_from_win(term, vim.b[term.buf] and vim.b[term.buf].snacks_terminal)
  else
    save_last(cmd, opts)
  end
  return term
end

-- Toggle the last opened terminal. If none exists, open a default interactive one.
function M.toggle_last()
  if not M.last then
    -- create a fresh terminal if none exists
    M.open(nil, { interactive = true, new = true })
    return
  end

  -- prefer toggling the actual instance reference when available
  if M.last and M.last.win and type(M.last.win.toggle) == "function" and M.last.win:buf_valid() then
    pcall(function() M.last.win:toggle() end)
    return
  end

  -- try to resolve via Snacks API using saved cmd/opts
  if M.last and M.last.cmd then
    local ok, term = pcall(function()
      return Snacks.terminal.get(M.last.cmd, M.last.opts)
    end)
    if ok and term then
      pcall(function() term:toggle() end)
      return
    end
  end

  -- fallback: create a new terminal
  M.open(nil, { interactive = true, new = true })
end

-- Present a vim.ui.select listing all snacks terminals and show/toggle the selected one
function M.pick()
  local ok, list = pcall(function() return Snacks.terminal.list() end)
  if not ok or not list or #list == 0 then
    vim.notify("No snacks terminals found", vim.log.levels.INFO)
    return
  end

  local items = {}
  for i, win in ipairs(list) do
    -- prefer buffer metadata for id/cwd/cmd (authoritative)
    local meta_ok, meta = pcall(vim.api.nvim_buf_get_var, win.buf, "snacks_terminal")
    local id = (meta and meta.id) and tostring(meta.id) or ((win.id and tostring(win.id)) or (win.opts and win.opts.id) or ("#" .. tostring(i)))
    local cwd = (meta and meta.cwd) and tostring(meta.cwd) or (win.opts and win.opts.cwd) or ""
    local title = nil
    if meta and meta.cmd then
      if type(meta.cmd) == "table" then
        title = table.concat(meta.cmd, " ")
      else
        title = tostring(meta.cmd)
      end
    elseif win.opts and win.opts.title then
      title = win.opts.title
    elseif win.term_title then
      title = win.term_title
    elseif win.cmd then
      if type(win.cmd) == "table" then
        title = table.concat(win.cmd, " ")
      else
        title = tostring(win.cmd)
      end
    else
      title = "terminal"
    end

    local short_cwd = cwd ~= "" and (" — " .. vim.fn.fnamemodify(cwd, ":~")) or ""
    local label = string.format("%s — %s%s", id, title, short_cwd)
    table.insert(items, { label = label, win = win, meta = meta })
  end

  vim.ui.select(items, {
    prompt = "Select terminal",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then
      return
    end

    local w = choice.win
    local meta = choice.meta

    -- Show/toggle the concrete terminal instance if possible
    if type(w.show) == "function" then
      pcall(function() w:show() end)
    elseif type(w.toggle) == "function" then
      pcall(function() w:toggle() end)
    else
      pcall(function() Snacks.terminal.toggle(w.cmd, w.opts) end)
    end

    -- remember selected terminal as last using authoritative metadata when available
    save_last_from_win(w, meta)
  end)
end

function M.setup_mappings(opts)
  opts = opts or {}
  local leader = opts.leader or "<leader>"
  local map = vim.keymap.set

  map("n", leader .. "tT", function() M.pick() end, { desc = "Select snacks terminal" })
  map("n", leader .. "tn", function() M.open(nil, { interactive = true, new = true }) end, { desc = "New snacks terminal" })
end

return M
