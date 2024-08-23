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
    mini = {
      enabled = true,
    },
    notify = true,
    nvimtree = true,
    telescope = true,
    treesitter_context = true,
    which_key = true,
  },
})

vim.cmd.colorscheme "catppuccin"
