local _, bufferline = pcall(require, "bufferline")

bufferline.setup({
  options = {
    separator_style = "thin",   -- | "thick" | "thin" | { 'any', 'any' },
  },
  highlights = require("catppuccin.groups.integrations.bufferline").get(),
})
