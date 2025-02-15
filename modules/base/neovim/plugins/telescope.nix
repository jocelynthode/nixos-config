_: {
  programs.nixvim = {
    keymaps = [
      {
        action = "<cmd>Telescope live_grep_args<cr>";
        key = "<leader>F";
        mode = "n";
        options = {
          desc = "Find text";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>Telescope find_files<cr>";
        key = "<leader>f";
        mode = "n";
        options = {
          desc = "Find files";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>Telescope buffers<cr>";
        key = "<leader>b";
        mode = "n";
        options = {
          desc = "Buffers";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>Telescope keymaps<cr>";
        key = "<leader>k";
        mode = "n";
        options = {
          desc = "Keymaps";
          nowait = true;
          remap = false;
        };
      }

      {
        action = "<cmd>Telescope commands<cr>";
        key = "<leader>sC";
        mode = "n";
        options = {
          desc = "Commands";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>Telescope man_pages<cr>";
        key = "<leader>sM";
        mode = "n";
        options = {
          desc = "Man Pages";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>Telescope registers<cr>";
        key = "<leader>sR";
        mode = "n";
        options = {
          desc = "Registers";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>Telescope git_branches<cr>";
        key = "<leader>sb";
        mode = "n";
        options = {
          desc = "Checkout branch";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>Telescope help_tags<cr>";
        key = "<leader>sh";
        mode = "n";
        options = {
          desc = "Find Help";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>Telescope oldfiles<cr>";
        key = "<leader>sr";
        mode = "n";
        options = {
          desc = "Open Recent File";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>Telescope grep_string theme=ivy<cr>";
        key = "<leader>ss";
        mode = "n";
        options = {
          desc = "Search Text";
          nowait = true;
          remap = false;
        };
      }
    ];
    plugins.telescope = {
      enable = true;
      extensions = {
        ui-select.enable = true;
        live-grep-args = {
          enable = true;
          settings = {
            theme = "ivy";
          };
        };
        fzf-native.enable = true;
      };
      settings = {
        defaults = {
          vimgrep_arguments = [
            "rg"
            "--vimgrep"
            "--smart-case"
            "--hidden"
          ];
          file_ignore_patterns = [
            "^node_modules/"
            "^.work/"
            "^.cache/"
            "^.idea/"
            "^.git/"
            "^.devenv/"
            "%.lock"
          ];
          prompt_prefix = " ";
          selection_caret = "❯ ";
          path_display = ["smart"];
          selection_strategy = "reset";
          sorting_strategy = "ascending";
          layout_strategy = "horizontal";
          layout_config = {
            horizontal = {
              prompt_position = "top";
              preview_width = 0.55;
              results_width = 0.8;
            };
            vertical = {
              mirror = false;
            };
            width = 0.87;
            height = 0.80;
            preview_cutoff = 120;
          };
        };
        pickers = {
          find_files = {
            theme = "dropdown";
            previewer = false;
            find_command = [
              "fd"
              "--type"
              "f"
              "--exclude"
              ".git"
              "--hidden"
            ];
          };
          live_grep = {
            theme = "ivy";
          };
          buffers = {
            theme = "dropdown";
            previewer = false;
          };
          keymaps = {
            show_plug = false;
          };
        };
      };
    };
  };
}
