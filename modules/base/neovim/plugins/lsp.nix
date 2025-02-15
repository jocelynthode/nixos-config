_: {
  programs.nixvim = {
    autoCmd = [
      {
        event = "FileType";
        pattern = "helm";
        command = "LspRestart";
      }
    ];

    diagnostics = {
      virtual_text = true;
      signs = {
        text = {
          "__rawKey__vim.diagnostic.severity.ERROR" = "";
          "__rawKey__vim.diagnostic.severity.WARN" = "";
          "__rawKey__vim.diagnostic.severity.INFO" = "";
          "__rawKey__vim.diagnostic.severity.HINT" = "";
        };
        numhl = {
          "__rawKey__vim.diagnostic.severity.ERROR" = "DiagnosticSignError";
          "__rawKey__vim.diagnostic.severity.WARN" = "DiagnosticSignWarn";
          "__rawKey__vim.diagnostic.severity.INFO" = "DiagnosticSignInfo";
          "__rawKey__vim.diagnostic.severity.HINT" = "DiagnosticSignHint";
        };
      };
      update_in_insert = true;
      underline = true;
      severity_sort = true;
      float = {
        focusable = false;
        style = "minimal";
        border = "rounded";
        source = "always";
        header = "";
        prefix = "";
      };
    };

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
    plugins = {
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          gopls.enable = true;
          dockerls.enable = true;
          basedpyright.enable = true;
          ruff.enable = true;
          terraformls.enable = true;
          vimls.enable = true;
          nil_ls = {
            enable = true;
            settings = {
              formatting.command = ["alejandra"];
            };
          };
          jsonls = {
            enable = true;
          };
          helm_ls = {
            enable = true;
            filetypes = ["helm"];
          };
          yamlls = {
            enable = true;
            filetypes = ["yaml"];
          };
          lua_ls = {
            enable = true;
            settings = {
              Lua = {
                diagnostics = {
                  globals = ["vim"];
                };
                workspace = {
                  library.__raw = ''
                    {
                      [vim.fn.expand("$VIMRUNTIME/lua")] = true;
                      [vim.fn.stdpath("config") .. "/lua"] = true;
                    }
                  '';
                };
              };
            };
          };
        };
      };
      schemastore = {
        enable = true;
        json.enable = true;
        yaml.enable = true;
      };
      lspsaga = {
        enable = true;
        lightbulb = {
          virtualText = false;
        };
        ui = {
          kind.__raw = ''require("catppuccin.groups.integrations.lsp_saga").custom_kind()'';
        };
        finder = {
          default = "def+ref+imp";
          keys = {
            toggleOrOpen = ["o" "l"];
          };
        };
      };
      lspkind = {
        enable = true;
        cmp.enable = true;
      };
      lsp-format.enable = true;
    };
  };
}
