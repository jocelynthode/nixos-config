_: {
  programs.nixvim = {
    keymaps = [
      {
        action = "<cmd>lua require('gitsigns').reset_buffer()<cr>";
        key = "<leader>gR";
        mode = "n";
        options = {
          desc = "Reset Buffer";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>Telescope git_branches<cr>";
        key = "<leader>gb";
        mode = "n";
        options = {
          desc = "Checkout branch";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>Telescope git_commits<cr>";
        key = "<leader>gc";
        mode = "n";
        options = {
          desc = "Checkout commit";
          nowait = true;
          remap = false;
        };
      }

      {
        action = ":Gvdiffsplit!<CR>";
        key = "<leader>gfd";
        mode = "n";
        options = {
          desc = "Diff";
          nowait = true;
          remap = false;
        };
      }
      {
        action = ":diffget //2 <CR>";
        key = "<leader>gfh";
        mode = "n";
        options = {
          desc = "Get Left Diff";
          nowait = true;
          remap = false;
        };
      }
      {
        action = ":diffget //3 <CR>";
        key = "<leader>gfl";
        mode = "n";
        options = {
          desc = "Get Right Diff";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>:Git<CR>";
        key = "<leader>gg";
        mode = "n";
        options = {
          desc = "Git Status";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>lua require('gitsigns').next_hunk()<cr>";
        key = "<leader>gj";
        mode = "n";
        options = {
          desc = "Next Hunk";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>lua require('gitsigns').prev_hunk()<cr>";
        key = "<leader>gk";
        mode = "n";
        options = {
          desc = "Prev Hunk";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>lua require('gitsigns').blame_line()<cr>";
        key = "<leader>gl";
        mode = "n";
        options = {
          desc = "Blame";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>Telescope git_status<cr>";
        key = "<leader>go";
        mode = "n";
        options = {
          desc = "Open changed file";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>lua require('gitsigns').preview_hunk()<cr>";
        key = "<leader>gp";
        mode = "n";
        options = {
          desc = "Preview Hunk";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>lua require('gitsigns').reset_hunk()<cr>";
        key = "<leader>gr";
        mode = "n";
        options = {
          desc = "Reset Hunk";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>lua require('gitsigns').stage_hunk()<cr>";
        key = "<leader>gs";
        mode = "n";
        options = {
          desc = "Stage Hunk";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>lua require('gitsigns').undo_stage_hunk()<cr>";
        key = "<leader>gu";
        mode = "n";
        options = {
          desc = "Undo Stage Hunk";
          nowait = true;
          remap = false;
        };
      }
    ];
    plugins.gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = {text = "▎";};
          change = {text = "▎";};
          delete = {text = "󰍵";};
          topdelete = {text = "‾";};
          changedelete = {text = "▎";};
          untracked = {text = "┆";};
        };
        attach_to_untracked = true;
      };
    };
  };
}
