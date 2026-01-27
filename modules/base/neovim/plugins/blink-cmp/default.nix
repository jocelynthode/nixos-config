_: {
  programs.nixvim.plugins = {
    blink-compat = {
      enable = true;
    };
    blink-cmp = {
      enable = true;
      settings = {
        appearance = {
          nerd_font_variant = "mono";
          use_nvim_cmp_as_default = true;
        };
        completion = {
          accept = {
            auto_brackets = {
              enabled = true;
              semantic_token_resolution = {
                enabled = false;
              };
            };
          };
          menu = {
            # auto_show.__raw = ''function(ctx) return ctx.mode ~= 'cmdline' end'';
            draw = {
              components = {
                kind_icon = {
                  ellipsis = false;
                  text.__raw = ''
                    function(ctx)
                      local lspkind = require("lspkind")
                      local icon = ctx.kind_icon
                      if vim.tbl_contains({ "Path" }, ctx.source_name) then
                          local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                          if dev_icon then
                              icon = dev_icon
                          end
                      else
                          icon = require("lspkind").symbolic(ctx.kind, {
                              mode = "symbol",
                          })
                      end

                      return icon .. ctx.icon_gap
                    end
                  '';
                  highlight.__raw = ''
                    function(ctx)
                      local hl = "BlinkCmpKind" .. ctx.kind
                        or require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)
                      if vim.tbl_contains({ "Path" }, ctx.source_name) then
                        local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                        if dev_icon then
                          hl = dev_hl
                        end
                      end
                      return hl
                    end
                  '';
                };
              };
            };
          };
          documentation = {
            auto_show = true;
          };
          list = {
            selection = {
              preselect.__raw = "function(ctx) return ctx.mode ~= 'cmdline' end";
              auto_insert.__raw = "function(ctx) return ctx.mode ~= 'cmdline' end";
            };
          };
        };
        keymap = {
          preset = "enter";
          "<Tab>" = [
            "select_next"
            "fallback"
          ];
          "<S-Tab>" = [
            "select_prev"
            "fallback"
          ];
        };
        signature = {
          enabled = true;
        };
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "render-markdown"
          ];
          providers = {
            render-markdown = {
              name = "render-markdown";
              module = "blink.compat.source";
            };
          };
        };
      };
    };
  };
}
