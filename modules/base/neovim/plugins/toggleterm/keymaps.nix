_: {
  programs.nixvim = {
    keymaps = [
      {
        action = "<cmd>ToggleTerm direction=float<cr>";
        key = "<leader>tf";
        mode = "n";
        options = {
          desc = "Float";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>ToggleTerm size=10 direction=horizontal<cr>";
        key = "<leader>th";
        mode = "n";
        options = {
          desc = "Horizontal";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>ToggleTerm size=80 direction=vertical<cr>";
        key = "<leader>tv";
        mode = "n";
        options = {
          desc = "Vertical";
          nowait = true;
          remap = false;
        };
      }
    ];
    keymapsOnEvents = {
      TermOpen = [
        {
          action.__raw = ''[[<C-\><C-n>]]'';
          key = "<esc>";
          mode = "t";
        }
        {
          action.__raw = ''[[<C-\><C-n><C-W>h]]'';
          key = "<C-h>";
          mode = "t";
        }
        {
          action.__raw = ''[[<C-\><C-n><C-W>j]]'';
          key = "<C-j>";
          mode = "t";
        }
        {
          action.__raw = ''[[<C-\><C-n><C-W>k]]'';
          key = "<C-k>";
          mode = "t";
        }
        {
          action.__raw = ''[[<C-\><C-n><C-W>l]]'';
          key = "<C-l>";
          mode = "t";
        }
      ];
    };
  };
}
