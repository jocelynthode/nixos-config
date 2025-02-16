_: {
  programs.nixvim.autoCmd = [
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
}
