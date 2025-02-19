_: {
  programs.nixvim.plugins.snacks = {
    enable = true;
    settings = {
      bigfiles.enabled = true;
      notifier.enabled = false;
      quickfile.enabled = true;
      statuscolumn.enabled = false;
      words.enabled = false;
    };
  };
}
