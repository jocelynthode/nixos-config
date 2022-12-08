local _, configs = pcall(require, "nvim-treesitter.configs")

configs.setup({
  ensure_installed = {},
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "" }, -- List of parsers to ignore installing
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "Select around the function" },
        ["if"] = { query = "@function.inner", desc = "Select the inner parts of the function" },
        ["ac"] = { query = "@class.outer", desc = "Select around the class" },
        ["ic"] = { query = "@class.inner", desc = "Select the inner parts of the class" },
        ["ab"] = { query = "@block.outer", desc = "Select around the block" },
        ["ib"] = { query = "@block.inner", desc = "Select the inner part of the block" },
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = { query = "@parameter.inner", desc = "Swap parameter with next" },
      },
      swap_previous = {
        ["<leader>A"] = { query = "@parameter.inner", desc = "Swap parameter with previous" },
      },
    },
  },
})
