local _, lspconfig = pcall(require, "lspconfig")


local yamlls_config = {
  filetypes_exclude = { "helm" },
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
        kubernetes = "templates/**",
      },
      completion = true,
      hover = true,
      validate = true,
    }
  },
}

local servers = {
  bashls = {},
  gopls = {},
  dockerls = {},
  basedpyright = {},
  ruff = {},
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
  helm_ls = {
    settings = {
      ['helm-ls'] = {
        yamlls = yamlls_config,
      }
    }
  },
  yamlls = yamlls_config,
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

local severity = {
  "error",
  "warn",
  "info",
  "info", -- map both hint and info to info?
}
vim.lsp.handlers["window/showMessage"] = function(err, method, params, client_id)
  vim.notify(method.message, severity[params.type])
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
      vim.diagnostic.enable(false, bufnr)
    end
  end
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


local _, none_ls = pcall(require, "null-ls")

local formatting = none_ls.builtins.formatting
local diagnostics = none_ls.builtins.diagnostics
local code_actions = none_ls.builtins.code_actions

none_ls.setup({
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
    -- Docker
    diagnostics.hadolint,
  },
})

---@diagnostic disable-next-line: undefined-global
local extension_path = rust_vscode_extension_path -- defined in extraConfigLua
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

local opts = {
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(
      codelldb_path, liblldb_path)
  }
}
require('rust-tools').setup(opts)
require('crates').setup({
  null_ls = {
    enabled = true,
    name = "crates.nvim",
  },
})

-- require('llm').setup({
--   backend = "ollama",
--   model = "codellama:7b",
--   -- model = "starcoder2:15b-instruct",
--   url = "http://localhost:11434/api/generate",
--   lsp = {
-- ---@diagnostic disable-next-line: undefined-global
--     bin_path = llm_ls_bin_path, -- defined in extraConfigLua
--   },
-- })


-- require('lsp-notify').setup({})
