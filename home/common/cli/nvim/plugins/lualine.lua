local _, lualine = pcall(require, "lualine")

local function lsp_name(msg)
  msg = msg or "Inactive"
  local buf_clients = vim.lsp.buf_get_clients()
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

  return " " .. table.concat(buf_client_names, ", ")
end

lualine.setup({
  options = {
    theme = "auto",
    globalstatus = true,
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
    lualine_c = { "filename" },
    lualine_x = {
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
