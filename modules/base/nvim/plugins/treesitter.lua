local _, configs = pcall(require, "nvim-treesitter.configs")

require('nvim-dap-repl-highlights').setup()
configs.setup({
  ensure_installed = {},
  sync_install = false,    -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "" }, -- List of parsers to ignore installing
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true,    -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },
})
require('ts_context_commentstring').setup {
  enable_autocmd = false,
}
-- skip backwards compatibility routines and speed up loading.
vim.g.skip_ts_context_commentstring_module = true
