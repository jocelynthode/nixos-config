_: {
  programs.nixvim = {
    autoCmd = [
      {
        event = "TermOpen";
        pattern = [
          "term://*"
        ];
        callback.__raw = ''
          vim.schedule_wrap(function(data)
              -- Try to start terminal mode only if target terminal is current
              if not (vim.api.nvim_get_current_buf() == data.buf and vim.bo.buftype == 'terminal') then return end
              vim.cmd('startinsert')
          end)
        '';
        group = "_general_settings";
        desc = "Start builtin terminal in Insert mode";
      }
    ];
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
    plugins.toggleterm = {
      enable = true;
      settings = {
        size = 20;
        open_mapping.__raw = ''[[<c-\>]]'';
        hide_numbers = true;
        shade_terminals = true;
        shading_factor = 2;
        start_in_insert = true;
        insert_mappings = true;
        persist_size = true;
        direction = "float";
        close_on_exit = true;
        shell.__raw = "vim.o.shell";
        float_opts = {
          border = "curved";
          winblend = 0;
          highlights = {
            border = "Normal";
            background = "Normal";
          };
        };
      };
    };
  };
}
