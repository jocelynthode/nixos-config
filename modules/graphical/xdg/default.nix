{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.graphical.xdg.enable = lib.mkEnableOption "xdg";

  config = lib.mkIf config.aspects.graphical.xdg.enable {
    aspects.base.persistence.homePaths = [
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"
      "Projects"
      "Programs"
      "go"
      ".config/dconf"
    ];

    xdg.portal = {
      enable = true;
      config = {
        common = {
          default = [
            "gtk"
          ];
        };
        sway = {
          default = [
            "gtk"
            "wlr"
          ];
        };
        niri = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [
            "gtk"
          ];
        };
        hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
        };
      };
      wlr.enable = config.aspects.graphical.sway.enable;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };

    home-manager.users.jocelyn =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          xdg-user-dirs
          xdg-utils
        ];

        xdg = {
          enable = true;
          # Some applications overwrite mimeapps.list with an identical file
          configFile."mimeapps.list".force = true;
          mimeApps = {
            enable = true;
            defaultApplications = {
              "inode/directory" = "yazi.desktop";
              "application/pdf" = "firefox.desktop";

              "text/plain" = [ "neovim.desktop" ];
              "text/html" = [ "firefox.desktop" ];
              "x-scheme-handler/about" = [ "firefox.desktop" ];
              "x-scheme-handler/http" = [ "firefox.desktop" ];
              "x-scheme-handler/https" = [ "firefox.desktop" ];
              "x-scheme-handler/unknown" = [ "firefox.desktop" ];
            };
          };
          desktopEntries = {
            nvim = {
              name = "Neovim";
              genericName = "Text Editor";
              comment = "Edit text files";
              exec = "nvim %F";
              icon = "nvim";
              mimeType = [
                "text/english"
                "text/plain"
                "text/x-makefile"
                "text/x-c++hdr"
                "text/x-c++src"
                "text/x-chdr"
                "text/x-csrc"
                "text/x-java"
                "text/x-moc"
                "text/x-pascal"
                "text/x-tcl"
                "text/x-tex"
                "application/x-shellscript"
                "text/x-c"
                "text/x-c++"
              ];
              terminal = true;
              type = "Application";
              categories = [
                "Utility"
                "TextEditor"
              ];
            };
          };
        };
        dconf = {
          enable = true;
          settings = {
            "org/blueberry" = {
              tray-enabled = false;
            };
          };
        };
      };
  };
}
