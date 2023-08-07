local _text = vim.api.nvim_create_augroup("_text", { clear = true })

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "text", "markdown", "gitcommit", "taxi" },
  callback = function()
    vim.api.nvim_command("setlocal spell")
    vim.api.nvim_command("setlocal wrap")
  end,
  group = _text,
})
-------------------

local _general_settings = vim.api.nvim_create_augroup("_general_settings", { clear = true })

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "fugitive" },
  command = "nnoremap <silent> <buffer> q :close<CR>",
  group = _general_settings,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = { "*" },
  callback = function()
    require("vim.highlight").on_yank({ higroup = "Visual", timeout = 200 })
  end,
  group = _general_settings,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = { "*" },
  command = "set formatoptions-=cro",
  group = _general_settings,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf" },
  command = "set nobuflisted",
  group = _general_settings,
})
-------------------

local _auto_resize = vim.api.nvim_create_augroup("_auto_resize", { clear = true })

vim.api.nvim_create_autocmd({ "VimResized" }, {
  pattern = { "*" },
  command = "tabdo wincmd =",
  group = _auto_resize,
})
-------------------

local _custom_ft = vim.api.nvim_create_augroup("_custom_ft", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.hcl", ".terraformrc" },
  command = "set filetype=hcl",
  group = _custom_ft,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.tf", "*.tfvars" },
  command = "set filetype=terraform",
  group = _custom_ft,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.tfstate", "*.tfstate.backup" },
  command = "set filetype=json",
  group = _custom_ft,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    require("lspsaga").setup({
      finder = {
        default = 'def+ref+imp',
        keys = {
          toggle_or_open = { 'o', 'l' },
        }
      },
    })
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gh', "<cmd>Lspsaga finder<CR>", opts)
    vim.keymap.set('n', 'gd', "<cmd>Lspsaga finder def<CR>", opts)
    vim.keymap.set('n', 'gr', "<cmd>Lspsaga finder ref<CR>", opts)
    vim.keymap.set('n', 'K', "<cmd>Lspsaga hover_doc<CR>", opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', 'gy', "<cmd>Lspsaga peek_type_definition<CR>", opts)
    vim.keymap.set("n", "[E", function()
      require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end)
    vim.keymap.set("n", "]E", function()
      require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
    end)
  end,
})
