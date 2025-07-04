_: {
  programs.nixvim.plugins.which-key = {
    enable = true;
    settings = {
      plugins = {
        spelling = {
          enabled = true;
          suggestions = 5;
        };
      };
      spec = [
        {
          __unkeyed-1 = "<leader>a";
          group = "CodeCompanion";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>d";
          group = "Debug";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>dG";
          group = "Go";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>dP";
          group = "Python";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>dT";
          group = "Telescope";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "Git";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "LSP";
          icon = "󰌌 ";
        }
        {
          __unkeyed-1 = "<leader>s";
          group = "Search";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>t";
          group = "Terminal";
          icon = " ";
        }
      ];
    };
  };
}
