{ pkgs, ... }:
{
  imports = [
    ./bitwarden.nix
    ./calibre.nix
    ./discord.nix
    ./dragon.nix
    ./easyeffects
    ./firefox.nix
    ./font.nix
    ./gammastep.nix
    ./gnupg.nix
    ./gtk.nix
    ./kitty
    ./lutris.nix
    ./mpv.nix
    ./mumble.nix
    ./pavucontrol.nix
    ./playerctl.nix
    ./qt.nix
    ./screenshot.nix
    ./signal.nix
    ./slack.nix
    ./spotify.nix
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "ranger.desktop";
      "application/pdf" = "firefox.desktop";
    };
  };

  home.packages = with pkgs; [
    xdg-utils
    networkmanagerapplet
  ];

  dconf = {
    enable = true;
    settings = {
      "org/blueberry" = {
        tray-enabled = false;
      };
      "com/github/wwmm/easyeffects" = {
        use-dark-theme = true;
      };
    };
  };
}
