_: {
  programs.nixvim.plugins.neo-tree = {
    enable = true;
    settings = {
      close_if_last_window = true;
      sources = [
        "filesystem"
        "buffers"
        "git_status"
      ];
      open_files_do_not_replace_types = [
        "terminal"
        "Trouble"
        "trouble"
        "qf"
      ];
      filesystem = {
        bind_to_cwd = false;
        follow_current_file.enabled = true;
        use_libuv_file_watcher = true;
      };
      window.mappings = {
        l = "open";
        h = "close_node";
        "<space>" = "none";
        P = {
          __unkeyed-1 = "toggle_preview";
          config.use_float = false;
        };
      };
      default_component_configs = {
        indent = {
          with_expanders = true;
          expander_collapsed = "";
          expander_expanded = "";
          expander_highlight = "NeoTreeExpander";
        };
        git_status.symbols = {
          unstaged = "󰄱";
          staged = "󰱒";
        };
      };
    };
  };

  programs.nixvim.keymaps = [
    {
      action.__raw = ''
        function()
          local root = vim.fs.root(0, {
            ".git",
            "flake.nix",
            "package.json",
            "go.mod",
            "Cargo.toml",
            "pyproject.toml",
            "Makefile"
          }) or vim.uv.cwd()
          require("neo-tree.command").execute({ toggle = true, dir = root })
        end
      '';
      key = "<leader>e";
      mode = "n";
      options.desc = "Explorer (Root Dir)";
    }
    {
      action.__raw = ''
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end
      '';
      key = "<leader>E";
      mode = "n";
      options.desc = "Explorer (cwd)";
    }
  ];
}
