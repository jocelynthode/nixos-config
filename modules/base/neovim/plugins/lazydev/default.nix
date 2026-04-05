_: {
  programs.nixvim.plugins.lazydev = {
    enable = true;
    settings = {
      library = [
        {
          path = "\${3rd}/luv/library";
          words = [ "vim%.uv" ];
        }
        {
          path = "snacks.nvim";
          words = [ "Snacks" ];
        }
        {
          path = "nvim-lspconfig";
          words = [ "lspconfig" ];
        }
      ];
    };
  };
}
