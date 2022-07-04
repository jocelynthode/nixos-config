{ pkgs, ... }: {
  fontProfiles = {
    enable = true;
    monospace = {
      family = "JetBrains Mono Nerd Font";
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
    };
    regular = {
      family = "NotoSans Nerd Font";
      package = pkgs.nerdfonts.override { fonts = [ "Noto" ]; };
    };
  };
}
