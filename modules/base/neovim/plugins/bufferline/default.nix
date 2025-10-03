_: {
  programs.nixvim.plugins.bufferline = {
    enable = true;
    settings = {
      options = {
        separator_style = "thin";
      };
      highlights.__raw = ''require("catppuccin.special.bufferline").get_theme()'';
    };
  };
}
