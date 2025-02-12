local _, lualine = pcall(require, "lualine")

local function lsp_name(msg)
  msg = msg or "Inactive"
  local buf_clients = vim.lsp.get_clients()
  if next(buf_clients) == nil then
    if type(msg) == "boolean" or #msg == 0 then
      return "Inactive"
    end
    return msg
  end
  local buf_client_names = {}

  for _, client in pairs(buf_clients) do
    if client.name ~= "null-ls" then
      table.insert(buf_client_names, client.name)
    end
  end

  return "  " .. table.concat(buf_client_names, ", ")
end

local code_companion = require("lualine.component"):extend()

code_companion.processing = false
code_companion.spinner_index = 1

local spinner_symbols = {
  "⠋",
  "⠙",
  "⠹",
  "⠸",
  "⠼",
  "⠴",
  "⠦",
  "⠧",
  "⠇",
  "⠏",
}
local spinner_symbols_len = 10

-- Initializer
function code_companion:init(options)
  code_companion.super.init(self, options)

  local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    group = group,
    callback = function(request)
      if request.match == "CodeCompanionRequestStarted" then
        self.processing = true
      elseif request.match == "CodeCompanionRequestFinished" then
        self.processing = false
      end
    end,
  })
end

-- Function that runs every time statusline is updated
function code_companion:update_status()
  if self.processing then
    self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
    return " " .. spinner_symbols[self.spinner_index]
  else
    return ""
  end
end


lualine.setup({
  options = {
    theme = "catppuccin",
    globalstatus = true,
    disabled_filetypes = { "alpha" },
  },
  extensions = {
    "fugitive",
    "nvim-tree",
    "toggleterm",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      "diff",
      "diagnostics",
    },
    lualine_c = { {"filename", path = 1} },
    lualine_x = {
      code_companion,
      lsp_name,
      {
        "lsp_progress",
        timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 600 },
      },
      "encoding",
      "fileformat",
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
})
