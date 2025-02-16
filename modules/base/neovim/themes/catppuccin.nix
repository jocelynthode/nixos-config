_: {
  programs.nixvim.colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = "latte";
      background = {
        light = "latte";
        dark = "mocha";
      };
      transparent_background = true;
      show_end_of_buffer = false;
      term_colors = false;
      dim_inactive = {
        enabled = false;
        shade = "dark";
        percentage = 0.15;
      };
      color_overrides = {};
      custom_highlights.__raw = ''
        function(colors)
          return {
            CursorLineNr = { fg = colors.pink },
            CursorLine = { bg = colors.none },

            CmpItemAbbrDeprecated = { bg = colors.none, strikethrough = true, fg = colors.overay1 },
            CmpItemAbbrMatch = { bg = colors.none, fg = colors.text },
            CmpItemAbbrMatchFuzzy = { link = 'CmpItemAbbrMatch' },
            CmpItemKindVariable = { bg = colors.none, fg = colors.pink },
            CmpItemKindInterface = { link = 'CmpItemKindVariable' },
            CmpItemKindText = { link = 'CmpItemKindVariable' },
            CmpItemKindFunction = { bg = colors.none, fg = colors.blue },
            CmpItemKindMethod = { link = 'CmpItemKindFunction' },
            CmpItemKindKeyword = { bg = colors.none, fg = colors.mauve },
            CmpItemKindProperty = { link = 'CmpItemKindKeyword' },
            CmpItemKindUnit = { link = 'CmpItemKindKeyword' },
          }
        end
      '';
      integrations = {
        alpha = false;
        cmp = true;
        blink_cmp = true;
        dap = {
          enabled = true;
          enable_ui = true;
        };
        fzf = true;
        gitsigns = true;
        grug_far = true;
        indent_blankline = {
          enabled = true;
          colored_indent_levels = false;
        };
        lsp_saga = true;
        mini = {
          enabled = true;
        };
        noice = true;
        notify = true;
        nvimtree = true;
        rainbow_delimiters = true;
        render_markdown = true;
        telescope = true;
        treesitter_context = true;
        which_key = true;
      };
    };
  };
}
