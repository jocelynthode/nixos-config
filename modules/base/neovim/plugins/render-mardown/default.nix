_: {
  programs.nixvim.plugins.render-markdown = {
    enable = true;
    settings = {
      enabled.__raw = "vim.env.KITTY_SCROLLBACK_NVIM ~= 'true'";
      file_types = [
        "markdown"
        "codecompanion"
      ];
    };
  };
}
