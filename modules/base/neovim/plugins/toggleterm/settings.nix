_: {
  programs.nixvim.plugins.toggleterm = {
    enable = true;
    settings = {
      size = 20;
      open_mapping.__raw = ''[[<c-\>]]'';
      hide_numbers = true;
      shade_terminals = true;
      shading_factor = 2;
      start_in_insert.__raw = "vim.env.KITTY_SCROLLBACK_NVIM ~= 'true'";
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
}
