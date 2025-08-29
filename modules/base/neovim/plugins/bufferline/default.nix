_: {
  programs.nixvim.plugins.bufferline = {
    enable = true;
    settings = {
      options = {
        separator_style = "thin";
      };
      highlights.__raw = ''require("catppuccin.groups.integrations.bufferline").get_theme()'';
    };
  };
}
