local _, ibl = pcall(require, "ibl")

ibl.setup({
  indent = { char = "▏" },
  exclude = {
    filetypes = {
      "alpha",
      "help",
      "startify",
      "dashboard",
      "packer",
      "neogitstatus",
      "NvimTree",
      "Trouble",
    },
    buftypes = { "terminal", "nofile" },
  },
})
