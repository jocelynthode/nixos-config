require("catppuccin").setup({
  flavour = "latte", -- latte, frappe, macchiato, mocha
  background = {
    light = "latte",
    dark = "mocha",
  },
  transparent_background = true,
  show_end_of_buffer = false, -- show the '~' characters after the end of buffers
  term_colors = false,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.15,
  },
  color_overrides = {},
  custom_highlights = function(colors)
    return {
      CursorLineNr = { fg = colors.pink },
      CursorLine = { bg = colors.none },

      CmpItemAbbrDeprecated = { bg = colors.none, strikethrough = true, fg = colors.overay1 },
      CmpItemAbbrMatch = { bg = colors.none, fg = colors.text },
      CmpItemAbbrMatchFuzzy = { link = 'CmpItemAbbrMatch' },
      CmpItemKindVariable = { bg = colors.none, fg = colors.pink },
      CmpItemKindInterface = { link = 'CmpItemKindVariable' },
      CmpItemKindText = { link = 'CmpItemKindVariable' },
      CmpItemKindFunction = { bg = colors.none, fg = colors.blue },
      CmpItemKindMethod = { link = 'CmpItemKindFunction' },
      CmpItemKindKeyword = { bg = colors.none, fg = colors.mauve },
      CmpItemKindProperty = { link = 'CmpItemKindKeyword' },
      CmpItemKindUnit = { link = 'CmpItemKindKeyword' },
    }
  end,
  integrations = {
    alpha = false,
    cmp = true,
    dap = {
      enabled = true,
      enable_ui = true,
    },
    gitsigns = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
    lsp_saga = true,
    mini = {
      enabled = true,
    },
    noice = true,
    notify = true,
    nvimtree = true,
    telescope = true,
    treesitter_context = true,
    which_key = true,
  },
})

vim.cmd.colorscheme "catppuccin"
