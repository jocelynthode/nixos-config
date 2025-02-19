_: {
  programs.nixvim.plugins.flash = {
    enable = true;
    settings = {
      labels = "asenflrtiuqcopwjmdyzxvbhgk";
      modes = {
        search.enabled = true;
        char.jump_labels = true;
      };
    };
  };
}
