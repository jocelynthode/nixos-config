_: {
  programs.nixvim.keymaps = [
    {
      action = "<cmd>lua require'dap'.run_to_cursor()<cr>";
      key = "<leader>dC";
      mode = "n";
      options = {
        desc = "Run To Cursor";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>lua require('dap-go').debug_last_test()<cr>";
      key = "<leader>dGl";
      mode = "n";
      options = {
        desc = "Debug Last Test";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>lua require('dap-go').debug_test()<cr>";
      key = "<leader>dGt";
      mode = "n";
      options = {
        desc = "Debug Test";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>lua require('dap-python').test_class()<cr>";
      key = "<leader>dPc";
      mode = "n";
      options = {
        desc = "Debug Class";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>lua require('dap-python').test_method()<cr>";
      key = "<leader>dPm";
      mode = "n";
      options = {
        desc = "Debug Method";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>lua require('dap-python').debug_selection()<cr>";
      key = "<leader>dx";
      mode = "n";
      options = {
        desc = "Terminate";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>lua require'dap'.disconnect()<cr>";
      key = "<leader>dd";
      mode = "n";
      options = {
        desc = "Disconnect";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>lua require'dap'.session()<cr>";
      key = "<leader>dg";
      mode = "n";
      options = {
        desc = "Get Session";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>lua require'dap'.pause().toggle()<cr>";
      key = "<leader>dp";
      mode = "n";
      options = {
        desc = "Toggle Pause";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>lua require'dap'.close()<cr>";
      key = "<leader>dq";
      mode = "n";
      options = {
        desc = "Quit";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>lua require'dap'.repl.toggle()<cr>";
      key = "<leader>dr";
      mode = "n";
      options = {
        desc = "Toggle Repl";
        nowait = true;
        remap = false;
      };
    }
    {
      action = "<cmd>lua require'dap'.toggle_breakpoint()<cr>";
      key = "<leader>dt";
      mode = "n";
      options = {
        desc = "Toggle Breakpoint";
        nowait = true;
        remap = false;
      };
    }
  ];
}
