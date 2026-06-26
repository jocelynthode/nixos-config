_: {
  programs.nixvim.keymaps = [
    {
      action.__raw = ''
        function()
          Snacks.notifier.show_history()
        end
      '';
      key = "<leader>n";
      mode = "n";
      options.desc = "Notification History";
    }
    {
      action.__raw = ''
        function()
          Snacks.notifier.hide()
        end
      '';
      key = "<leader>un";
      mode = "n";
      options.desc = "Dismiss Notifications";
    }
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
          Snacks.terminal(nil, { cwd = root })
        end
      '';
      key = "<leader>ft";
      mode = "n";
      options.desc = "Terminal (Root Dir)";
    }
    {
      action.__raw = ''
        function()
          Snacks.terminal()
        end
      '';
      key = "<leader>fT";
      mode = "n";
      options.desc = "Terminal (cwd)";
    }
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
          Snacks.terminal.focus(nil, { cwd = root })
        end
      '';
      key = "<C-/>";
      mode = [
        "n"
        "t"
      ];
      options.desc = "Terminal (Root Dir)";
    }
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
          Snacks.terminal.focus(nil, { cwd = root })
        end
      '';
      key = "<C-_>";
      mode = [
        "n"
        "t"
      ];
      options.desc = "which_key_ignore";
    }
  ];
}
