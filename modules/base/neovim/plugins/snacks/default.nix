_: {
  imports = [
    ./keymaps.nix
  ];

  programs.nixvim.plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      dashboard.enabled = true;
      explorer.enabled = false;
      indent.enabled = true;
      input.enabled = true;
      notifier.enabled = true;
      quickfile.enabled = true;
      scope.enabled = true;
      scroll.enabled = true;
      statuscolumn.enabled = false;
      terminal.enabled = true;
      toggle.enabled = true;
      words.enabled = true;

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
