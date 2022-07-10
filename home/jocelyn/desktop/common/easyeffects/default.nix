{
  services.easyeffects = {
    enable = true;
  };

  xdg.configFile."easyeffects" = {
    source = ./config;
    recursive = true;
  };

  dconf.settings = {
    "com/github/wwmm/easyeffects" = {
      use-dark-theme = true;
    };
  };
}
