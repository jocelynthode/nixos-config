_: let
  options = {
    silent = true;
  };
in {
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
      action = "<CMD>SearchReplaceSingleBufferVisualSelection<CR>";
      key = "<C-r>";
      mode = "x";
      inherit options;
    }
    {
      action = "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>";
      key = "<C-b>";
      mode = "x";
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

    {
      action = "<cmd>SearchReplaceSingleBufferCWORD<cr>";
      key = "<leader>rW";
      mode = "n";
      options = {
        desc = "[W]ORD";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>SearchReplaceMultiBufferCWORD<cr>";
      key = "<leader>rbW";
      mode = "n";
      options = {
        desc = "[W]ORD";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>SearchReplaceMultiBufferCExpr<cr>";
      key = "<leader>rbe";
      mode = "n";
      options = {
        desc = "[e]xpr";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>SearchReplaceMultiBufferCFile<cr>";
      key = "<leader>rbf";
      mode = "n";
      options = {
        desc = "[f]ile";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>SearchReplaceMultiBufferOpen<cr>";
      key = "<leader>rbo";
      mode = "n";
      options = {
        desc = "[o]pen";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>SearchReplaceMultiBufferSelections<cr>";
      key = "<leader>rbs";
      mode = "n";
      options = {
        desc = "SearchReplaceMultiBuffer [s]election list";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>SearchReplaceMultiBufferCWord<cr>";
      key = "<leader>rbw";
      mode = "n";
      options = {
        desc = "[w]ord";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>SearchReplaceSingleBufferCExpr<cr>";
      key = "<leader>re";
      mode = "n";
      options = {
        desc = "[e]xpr";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>SearchReplaceSingleBufferCFile<cr>";
      key = "<leader>rf";
      mode = "n";
      options = {
        desc = "[f]ile";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>SearchReplaceSingleBufferOpen<cr>";
      key = "<leader>ro";
      mode = "n";
      options = {
        desc = "[o]pen";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>SearchReplaceSingleBufferSelections<cr>";
      key = "<leader>rs";
      mode = "n";
      options = {
        desc = "SearchReplaceSingleBuffer [s]election list";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>SearchReplaceSingleBufferCWord<cr>";
      key = "<leader>rw";
      mode = "n";
      options = {
        desc = "[w]ord";
        nowait = true;
        remap = false;
      };
    }
  ];
}
