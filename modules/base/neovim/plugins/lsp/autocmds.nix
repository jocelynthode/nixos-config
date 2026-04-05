_: {
  programs.nixvim.autoCmd = [
    {
      event = "FileType";
      pattern = "helm";
      callback.__raw = ''
        function()
          vim.schedule(function()
            vim.lsp.enable("helm_ls")
          end)
        end
      '';
    }
  ];
}
