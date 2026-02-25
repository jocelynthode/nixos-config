_: {
  programs.nixvim.plugins.yaml-schema-detect = {
    enable = true;
    settings = {
      keymap = {
        cleanup = "<leader>yc";
        info = "<leader>yi";
        refresh = "<leader>yr";
      };
    };
  };
}
