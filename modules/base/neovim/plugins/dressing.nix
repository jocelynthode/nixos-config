_: {
  programs.nixvim.plugins.dressing = {
    enable = true;
    settings = {
      input = {
        relative = "editor";
      };
      select = {
        enabled = false;
      };
    };
  };
}
