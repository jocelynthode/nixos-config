_: {
  programs.nixvim.autoCmd = [
    {
      event = "VimEnter";
      callback.__raw = ''
        function(data)
          local directory = vim.fn.isdirectory(data.file) == 1

          if not directory then
            return
          end
          vim.cmd.enew()
          vim.cmd.bw(data.buf)
          vim.cmd.cd(data.file)
          require("nvim-tree.api").tree.open()
        end
      '';
    }
  ];
}
