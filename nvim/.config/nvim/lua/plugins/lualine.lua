local colors = {
  bg = "#181723",
  fg = "#e0def4",
  yellow = "#edc381",
  cyan = "#ebbcba",
  darkblue = "#43728c",
  green = "#a6cdd6",
  orange = "#ebbcba",
  violet = "#a9a1e1",
  magenta = "#bfa8e2",
  blue = "#51afef",
  red = "#db7691",
}

-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
-- Color table for highlights
-- stylua: ignore


local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 10000000
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = "",
    section_separators = "",
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
    disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

local mode_color = {
  n = colors.cyan,         -- Normal
  no = colors.red,         -- Operator-pending
  nov = colors.red,        -- Operator-pending (visual)
  noV = colors.red,        -- Operator-pending (visual line)
  ["no\22"] = colors.red,  -- Operator-pending (visual block) (CTRL-V)
  i = colors.green,        -- Insert
  ic = colors.green,       -- Insert completion
  ix = colors.green,       -- Insert completion (non-interruptible)
  v = colors.magenta,      -- Visual
  V = colors.magenta,      -- Visual line
  ["\22"] = colors.magenta, -- Visual block (CTRL-V)
  s = colors.orange,       -- Select
  S = colors.orange,       -- Select line
  ["\19"] = colors.orange, -- Select block (CTRL-S, if mapped)
  R = colors.violet,       -- Replace
  Rv = colors.violet,      -- Virtual replace
  c = colors.red,          -- Command-line
  cv = colors.red,         -- Vim Ex mode
  ce = colors.red,         -- Ex mode
  r = colors.cyan,         -- Hit-enter prompt
  rm = colors.cyan,        -- Confirm prompt (e.g., :confirm quit)
  ["r?"] = colors.cyan,    -- Prompt mode (e.g., :promptfind)
  ["!"] = colors.red,      -- Shell or external command execution
  t = colors.red,          -- Terminal mode
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left({
  function()
    return "▊"
  end,
  color = function()
    -- Default to cyan if mode is unknown
    return { fg = mode_color[vim.fn.mode()] or colors.cyan, gui = "bold" }
  end,                              -- Sets highlighting of component
  padding = { left = 0, right = 1 }, -- We don't need space before this
})

ins_left({
  "mode",
  color = function()
    return { fg = mode_color[vim.fn.mode()] or colors.cyan, gui = "bold" }
  end,
  padding = { right = 1 },
})

ins_left({
  "filename",
  file_status = true,    -- Displays file status (readonly status, modified status)
  newfile_status = false, -- Display new file status (new file means no write after created)
  path = 1,              -- 0: Just the filename
  symbols = {
    modified = "[+]",    -- Text to show when the file is modified.
    readonly = "[-]",    -- Text to show when the file is non-modifiable or readonly.
    unnamed = "[No Name]", -- Text to show for unnamed buffers.
    newfile = "[New]",   -- Text to show for newly created file before first write
  },
  cond = conditions.buffer_not_empty,
  color = { fg = colors.green },
})

ins_left({
  "branch",
  icon = "",
  color = { fg = colors.green },
})

ins_left({
  "diff",
  symbols = { added = " ", modified = " ", removed = " " },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.cyan },
    removed = { fg = colors.red },
  },
})

ins_left({
  -- filesize component
  "filesize",
  cond = conditions.buffer_not_empty,
})

ins_left({
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " " },
  diagnostics_color = {
    error = { fg = colors.red },
    warn = { fg = colors.yellow },
    info = { fg = colors.cyan },
  },
})

-- Add components to right sections

--ins_right({
--  "o:encoding",
--  color = { fg = colors.fg, gui = "bold" },
--})

ins_right({
  "fileformat",
  icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
  color = { fg = colors.fg, gui = "bold" },
})

ins_right({
  "filetype",
  color = { fg = colors.fg, gui = "bold" },
})

ins_right({ "progress", color = { fg = colors.fg, gui = "bold" } })

ins_right({ "location" })

ins_right({
  function()
    return "▊"
  end,
  color = function()
    -- Default to cyan if mode is unknown
    return { fg = mode_color[vim.fn.mode()] or colors.cyan, gui = "bold" }
  end,
  padding = { left = 1 },
})

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional
  config = function()
    require("lualine").setup(config)
  end,
}
