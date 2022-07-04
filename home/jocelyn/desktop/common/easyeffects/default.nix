{
  services.easyeffects = {
    enable = true;
  };

  xdg.configFile."easyeffects" = {
    source = ./config;
    recursive = true;
  };
}
