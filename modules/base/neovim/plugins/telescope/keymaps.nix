_: {
  programs.nixvim.keymaps = [
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
}
