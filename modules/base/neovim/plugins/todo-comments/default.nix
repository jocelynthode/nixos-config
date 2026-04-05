_: {
  programs.nixvim.plugins.todo-comments.enable = true;

  programs.nixvim.keymaps = [
    {
      action.__raw = ''
        function()
          require("todo-comments").jump_next()
        end
      '';
      key = "]t";
      mode = "n";
      options.desc = "Next Todo Comment";
    }
    {
      action.__raw = ''
        function()
          require("todo-comments").jump_prev()
        end
      '';
      key = "[t";
      mode = "n";
      options.desc = "Previous Todo Comment";
    }
    {
      action = "<cmd>TodoTelescope<cr>";
      key = "<leader>st";
      mode = "n";
      options.desc = "Todo";
    }
    {
      action = "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>";
      key = "<leader>sT";
      mode = "n";
      options.desc = "Todo/Fix/Fixme";
    }
  ];
}
