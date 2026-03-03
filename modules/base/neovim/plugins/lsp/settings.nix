{ config, ... }:
{
  programs.nixvim = {
    diagnostic.settings = {
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
          nixd = {
            enable = true;
            settings =
              let
                nixpkgsPath = "<nixpkgs>";
                nixosConfigPath = "<nixos-config>";
              in
              {
                nixpkgs.expr = "import ${nixpkgsPath} { }";
                formatting.command = [ "nixfmt" ];
                options = rec {
                  nixos.expr = "(import ${nixosConfigPath} {}).nixosConfigurations.${config.networking.hostName}.options";
                  home-manager.expr = "${nixos.expr}.home-manager.users.type.getSubOptions [ ]";
                  nixvim.expr = "${nixos.expr}.programs.nixvim.type.getSubOptions [ ]";
                };
              };
          };
          jsonls = {
            enable = true;
          };
          helm_ls = {
            enable = true;
            filetypes = [ "helm" ];
          };
          yamlls = {
            enable = true;
            settings = {
              format = {
                enable = true;
                singleQuote = false;
              };
            };
            filetypes = [ "yaml" ];
          };
          lua_ls = {
            enable = true;
            settings = {
              Lua = {
                diagnostics = {
                  globals = [ "vim" ];
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
        settings = {
          lightbulb = {
            virtual_text = false;
          };
          ui = {
            kind.__raw = ''require("catppuccin.groups.integrations.lsp_saga").custom_kind()'';
          };
          finder = {
            default = "def+ref+imp";
            keys = {
              toggle_or_open = [
                "o"
                "l"
              ];
            };
          };
        };
      };
      lspkind = {
        enable = true;
        cmp.enable = false;
      };
      lsp-format.enable = true;
    };
  };
}
