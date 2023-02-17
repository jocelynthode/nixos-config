local _, lspconfig = pcall(require, "lspconfig")
local _, glance = pcall(require, "glance")
local glance_actions = glance.actions

local servers = {
  bashls = {},
  gopls = {},
  dockerls = {},
  pylsp = {
    cmd = { vim.g.python3_host_prog, '-m', 'pylsp' },
  },
  nil_ls = {
    settings = {
      ['nil'] = {
        formatting = { command = { "alejandra" } }
      },
    },
  },
  rust_analyzer = {},
  terraformls = {},
  vimls = {},
  yamlls = {
    settings = {
      redhat = {
        telemetry = {
          enabled = false,
        },
      },
      yaml = {
        format = {
          enable = true,
          bracketSpacing = false,
          singleQuote = true,
        },
        schemas = {
          ["https://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
          ["https://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
          ["https://json.schemastore.org/chart.json"] = "/Chart.{yml,yaml}",
          kubernetes = "/*.yaml",
        },
        validate = true,
      }
    },
  },
  jsonls = {
    cmd = { "vscode-json-languageserver", "--stdio" },
    settings = {
      json = { schemas = require('schemastore').json.schemas() },
    },
    setup = {
      commands = {
        Format = {
          function()
            vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
          end,
        },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
      },
    },
  },
}

local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config {
  virtual_text = true,
  -- show signs
  signs = {
    active = signs,
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})

vim.lsp.handlers["$/progress"] = function(_, result, ctx)
  local client_id = ctx.client_id

  local val = result.value

  if not val.kind then
    return
  end

  local notif_data = get_notif_data(client_id, result.token)

  if val.kind == "begin" then
    local message = format_message(val.message, val.percentage)

    notif_data.notification = vim.notify(message, "info", {
      title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
      icon = spinner_frames[1],
      timeout = false,
      hide_from_history = false,
    })

    notif_data.spinner = 1
    update_spinner(client_id, result.token)
  elseif val.kind == "report" and notif_data then
    notif_data.notification = vim.notify(format_message(val.message, val.percentage), "info", {
      replace = notif_data.notification,
      hide_from_history = false,
    })
  elseif val.kind == "end" and notif_data then
    notif_data.notification = vim.notify(val.message and format_message(val.message) or "Complete", "info", {
      icon = "",
      replace = notif_data.notification,
      timeout = 3000,
    })

    notif_data.spinner = nil
  end
end

local severity = {
  "error",
  "warn",
  "info",
  "info", -- map both hint and info to info?
}
vim.lsp.handlers["window/showMessage"] = function(err, method, params, client_id)
  vim.notify(method.message, severity[params.type])
end

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    local lsp_document_highlight = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })

    vim.api.nvim_create_autocmd({ "CursorHold" }, {
      buffer = 0, -- Current Buffer
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
      group = lsp_document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      buffer = 0, -- Current Buffer
      callback = function()
        vim.lsp.buf.clear_references()
      end,
      group = lsp_document_highlight,
    })
  end
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>Glance definitions<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>Glance implementations<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gy", "<cmd>Glance type_definitions<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>Glance references<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "gl",
    '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "rounded" })<CR>',
    opts
  )
  vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format { async = true }' ]])
end

local function lsp_format_on_save(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    local LspFormatting = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
    vim.api.nvim_clear_autocmds({ group = LspFormatting, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = LspFormatting,
      buffer = bufnr,
      callback = vim.lsp.buf.formatting_sync,
    })
  end
end

local on_attach = function(client, bufnr)
  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
  end
  -- force enable yamlls formatting feature
  -- see https://github.com/redhat-developer/yaml-language-server/issues/486#issuecomment-1046792026
  if client.name == "yamlls" then
    client.server_capabilities.documentFormattingProvider = true
    if vim.bo[bufnr].filetype == "helm" then
      vim.diagnostic.disable(bufnr)
    end
  end

  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
  --[[ lsp_format_on_save(client, bufnr) ]]
end

local _, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

for lsp, cfg in pairs(servers) do
  local config = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 128,
    }
  }

  config = vim.tbl_extend('error', config, cfg)
  lspconfig[lsp].setup(config)
end


local _, null_ls = pcall(require, "null-ls")

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
  debug = false,
  sources = {
    formatting.prettier.with({
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "css", "scss", "less",
        "html", "markdown", "graphql", "handlebars" }
    }),
    code_actions.gitsigns,
    diagnostics.gitlint,
    -- Shell
    formatting.shfmt,
    diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
    -- Docker
    diagnostics.hadolint,
  },
  --[[ on_attach = lsp_format_on_save, ]]
})

glance.setup({
  mappings = {
    list = {
      ['l'] = glance_actions.jump,
    },
    preview = {
      ['q'] = glance_actions.close,
      ['<Esc>'] = glance_actions.close,
    },
  },
})
