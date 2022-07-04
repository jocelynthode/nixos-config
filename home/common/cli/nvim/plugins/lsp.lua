local _, lspconfig = pcall(require, "lspconfig")

local servers = {
  bashls = {},
  gopls = {},
  dockerls = {},
  pyright = {},
  rnix = {},
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
          kubernetes = "/*.yaml"
        },
        schemaDownload = { enable = true },
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
  sumneko_lua = {
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
  -- disable virtual text
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

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
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
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
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
  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
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
    client.resolved_capabilities.document_formatting = false
  end
  -- force enable yamlls formatting feature
  -- see https://github.com/redhat-developer/yaml-language-server/issues/486#issuecomment-1046792026
  if client.name == "yamlls" then
    client.resolved_capabilities.document_formatting = true
  end

  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
  lsp_format_on_save(client, bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

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


local null_ls_status_ok, null_ls = pcall(require, "null-ls")

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
  debug = false,
  sources = {
    formatting.prettier.with({
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "css", "scss", "less", "html", "markdown", "graphql", "handlebars" }
    }),
    code_actions.gitsigns,
    diagnostics.gitlint,
    -- Shell
    formatting.shfmt,
    diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
  },
  on_attach = lsp_format_on_save,
})
