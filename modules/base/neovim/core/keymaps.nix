_:
let
  options = {
    silent = true;
  };
in
{
  programs.nixvim.keymaps = [
    {
      action = "<Nop>";
      key = "<Space>";
      mode = "n";
      inherit options;
    }
    {
      action = "<C-w>h";
      key = "<C-Left>";
      mode = "n";
      inherit options;
    }
    {
      action = "<C-w>j";
      key = "<C-Down>";
      mode = "n";
      inherit options;
    }
    {
      action = "<C-w>k";
      key = "<C-Up>";
      mode = "n";
      inherit options;
    }
    {
      action = "<C-w>l";
      key = "<C-Right>";
      mode = "n";
      inherit options;
    }

    {
      action = ":resize -2<CR>";
      key = "<C-S-Up>";
      mode = "n";
      inherit options;
    }
    {
      action = ":resize +2<CR>";
      key = "<C-S-Down>";
      mode = "n";
      inherit options;
    }
    {
      action = ":vertical resize -2<CR>";
      key = "<C-S-Left>";
      mode = "n";
      inherit options;
    }
    {
      action = ":vertical resize +2<CR>";
      key = "<C-S-Right>";
      mode = "n";
      inherit options;
    }

    {
      action = ":bnext<CR>";
      key = "<S-Right>";
      mode = "n";
      inherit options;
    }
    {
      action = ":bprevious<CR>";
      key = "<S-Left>";
      mode = "n";
      inherit options;
    }

    {
      action = "<Esc>:m .+1<CR>==gi";
      key = "<A-Down>";
      mode = "n";
      inherit options;
    }
    {
      action = "<Esc>:m .-2<CR>==gi";
      key = "<A-Up>";
      mode = "n";
      inherit options;
    }
    {
      action = ",<c-g>u";
      key = ",";
      mode = "i";
      inherit options;
    }
    {
      action = ".<c-g>u";
      key = ".";
      mode = "i";
      inherit options;
    }
    {
      action = "!<c-g>u";
      key = "!";
      mode = "i";
      inherit options;
    }
    {
      action = "?<c-g>u";
      key = "?";
      mode = "i";
      inherit options;
    }

    {
      action = "<gv";
      key = "<";
      mode = "v";
      inherit options;
    }
    {
      action = ">gv";
      key = ">";
      mode = "v";
      inherit options;
    }
    {
      action = "\"_dP";
      key = "p";
      mode = "v";
      inherit options;
    }
    {
      action = ";";
      key = ",";
      mode = "n";
      inherit options;
    }
    {
      action = ",";
      key = ";";
      mode = "n";
      inherit options;
    }

    {
      action = "<cmd>nohlsearch<CR>";
      key = "<leader>h";
      mode = "n";
      options = {
        desc = "Find text";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>qa!<CR>";
      key = "<leader>q";
      mode = "n";
      options = {
        desc = "Quit";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>w!<CR>";
      key = "<leader>w";
      mode = "n";
      options = {
        desc = "Save";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>bdelete!<CR>";
      key = "<leader>x";
      mode = "n";
      options = {
        desc = "Close Buffer";
        nowait = true;
        remap = false;
      };
    }
  ];
}
