_: {
  programs.nixvim.plugins.trouble = {
    enable = true;
    settings = {
      modes.lsp.win.position = "right";
    };
  };

  programs.nixvim.keymaps = [
    {
      action = "<cmd>Trouble diagnostics toggle<cr>";
      key = "<leader>xx";
      mode = "n";
      options.desc = "Diagnostics (Trouble)";
    }
    {
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      key = "<leader>xX";
      mode = "n";
      options.desc = "Buffer Diagnostics (Trouble)";
    }
    {
      action = "<cmd>Trouble loclist toggle<cr>";
      key = "<leader>xL";
      mode = "n";
      options.desc = "Location List";
    }
    {
      action = "<cmd>Trouble qflist toggle<cr>";
      key = "<leader>xQ";
      mode = "n";
      options.desc = "Quickfix List";
    }
    {
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
      key = "<leader>cs";
      mode = "n";
      options.desc = "Symbols (Trouble)";
    }
    {
      action = "<cmd>Trouble lsp toggle<cr>";
      key = "<leader>cS";
      mode = "n";
      options.desc = "LSP References/Definitions";
    }
  ];
}
