_: {
  programs.nixvim = {
    keymaps = [
      {
        action = "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>";
        key = "<leader>lS";
        mode = "n";
        options = {
          desc = "Workspace Symbols";
        };
      }
      {
        action = "<cmd>Lspsaga code_action<cr>";
        key = "<leader>la";
        mode = "n";
        options = {
          desc = "Code Action";
        };
      }
      {
        action = "<cmd>Lspsaga show_buf_diagnostics<cr>";
        key = "<leader>ld";
        mode = "n";
        options = {
          desc = "Document Diagnostics";
        };
      }
      {
        action = "<cmd>lua vim.lsp.buf.format { async = true }<cr>";
        key = "<leader>lf";
        mode = "n";
        options = {
          desc = "Format";
        };
      }
      {
        action = "<cmd>LspInfo<cr>";
        key = "<leader>li";
        mode = "n";
        options = {
          desc = "Info";
        };
      }
      {
        action = "<cmd>Lspsaga diagnostic_jump_next<cr>";
        key = "<leader>lj";
        mode = "n";
        options = {
          desc = "Next Diagnostic";
        };
      }
      {
        action = "<cmd>Lspsaga diagnostic_jump_prev<cr>";
        key = "<leader>lk";
        mode = "n";
        options = {
          desc = "Prev Diagnostic";
        };
      }
      {
        action = "<cmd>Lspsaga rename ++project<cr>";
        key = "<leader>lr";
        mode = "n";
        options = {
          desc = "Rename";
        };
      }
      {
        action = "<cmd>Telescope lsp_document_symbols<cr>";
        key = "<leader>ls";
        mode = "n";
        options = {
          desc = "Document Symbols";
        };
      }
      {
        action = "<cmd>Lspsaga show_workspace_diagnostics<cr>";
        key = "<leader>lw";
        mode = "n";
        options = {
          desc = "Workspace Diagnostics";
        };
      }
    ];
    keymapsOnEvents = {
      LspAttach = [
        {
          action = "<cmd>Lspsaga finder<CR>";
          key = "gh";
        }
        {
          action = "<cmd>Lspsaga finder def<CR>";
          key = "gd";
        }
        {
          action = "<cmd>Lspsaga finder ref<CR>";
          key = "gr";
        }
        {
          action = "<cmd>Lspsaga hover_doc<CR>";
          key = "K";
        }
        {
          action.__raw = "vim.lsp.buf.signature_help";
          key = "<C-k>";
        }
        {
          action = "<cmd>Lspsaga peek_type_definition<CR>";
          key = "gy";
        }
        {
          action.__raw = ''
            function()
              require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
            end
          '';
          key = "[E";
        }
        {
          action.__raw = ''
            function()
              require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
            end
          '';
          key = "]E";
        }
      ];
    };
  };
}
