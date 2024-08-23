local _, gitsigns = pcall(require, "gitsigns")

gitsigns.setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "󰍵" },
    topdelete = { text = "‾" },
    changedelete = { text = "▎" },
    untracked = { text = "┆" },
  },
  attach_to_untracked = true,
})
