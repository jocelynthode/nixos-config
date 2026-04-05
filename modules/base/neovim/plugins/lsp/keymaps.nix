_: {
  programs.nixvim = {
    keymaps = [
      {
        action.__raw = "vim.lsp.buf.code_action";
        key = "<leader>ca";
        mode = [
          "n"
          "x"
        ];
        options.desc = "Code Action";
      }
      {
        action.__raw = ''
          function()
            require("conform").format({ async = true, lsp_format = "fallback" })
          end
        '';
        key = "<leader>cf";
        mode = "n";
        options.desc = "Format";
      }
      {
        action = "<cmd>checkhealth vim.lsp<cr>";
        key = "<leader>cl";
        mode = "n";
        options.desc = "Info";
      }
      {
        action.__raw = "vim.diagnostic.open_float";
        key = "<leader>cd";
        mode = "n";
        options.desc = "Line Diagnostics";
      }
      {
        action.__raw = "vim.lsp.buf.rename";
        key = "<leader>cr";
        mode = "n";
        options.desc = "Rename";
      }
      {
        action = "<cmd>Telescope lsp_document_symbols<cr>";
        key = "<leader>ss";
        mode = "n";
        options.desc = "Document Symbols";
      }
      {
        action = "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>";
        key = "<leader>sS";
        mode = "n";
        options.desc = "Workspace Symbols";
      }
      {
        action.__raw = ''
          function()
            vim.diagnostic.jump({ count = -1, float = true })
          end
        '';
        key = "[d";
        mode = "n";
        options.desc = "Prev Diagnostic";
      }
      {
        action.__raw = ''
          function()
            vim.diagnostic.jump({ count = 1, float = true })
          end
        '';
        key = "]d";
        mode = "n";
        options.desc = "Next Diagnostic";
      }
      {
        action.__raw = ''
          function()
            vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
          end
        '';
        key = "[e";
        mode = "n";
        options.desc = "Prev Error";
      }
      {
        action.__raw = ''
          function()
            vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
          end
        '';
        key = "]e";
        mode = "n";
        options.desc = "Next Error";
      }
    ];

    keymapsOnEvents = {
      LspAttach = [
        {
          action.__raw = "vim.lsp.buf.declaration";
          key = "gD";
        }
        {
          action.__raw = "vim.lsp.buf.definition";
          key = "gd";
        }
        {
          action.__raw = "vim.lsp.buf.references";
          key = "gr";
        }
        {
          action.__raw = "vim.lsp.buf.implementation";
          key = "gI";
        }
        {
          action.__raw = "vim.lsp.buf.type_definition";
          key = "gy";
        }
        {
          action.__raw = "vim.lsp.buf.hover";
          key = "K";
        }
        {
          action.__raw = "vim.lsp.buf.signature_help";
          key = "gK";
        }
        {
          action.__raw = "vim.lsp.buf.signature_help";
          key = "<C-k>";
          mode = "i";
        }
      ];
    };
  };
}
