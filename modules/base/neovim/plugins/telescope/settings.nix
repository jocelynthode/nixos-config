_: {
  programs.nixvim.plugins.telescope = {
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
        path_display = [ "smart" ];
        selection_strategy = "reset";
        sorting_strategy = "ascending";
        layout_strategy = "horizontal";
        layout_config = {
          horizontal = {
            prompt_position = "top";
          };
          vertical = {
            mirror = false;
          };
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
}
