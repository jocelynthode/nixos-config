_: {
  programs.nixvim.plugins.snacks = {
    enable = true;
    settings = {
      bigfiles.enabled = true;
      notifier.enabled = false;
      quickfile.enabled = true;
      statuscolumn.enabled = false;
      words.enabled = false;
      terminal.enabled = true;

      picker.select.layout = {
        preset = "select";
        layout = {
          width = 0.4;
          height = 0.3;
          max_width = 80;
        };
      };
    };
  };
}
