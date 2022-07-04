{ inputs, ... }: final: prev:
let
  inherit (inputs.nix-colors.lib-contrib { pkgs = final; }) gtkThemeFromScheme;
  inherit (inputs.nix-colors) colorSchemes;
  inherit (builtins) mapAttrs;
in
{
  # Don't launch discord when using discocss
  discocss = prev.discocss.overrideAttrs (oldAttrs: rec {
    patches = (oldAttrs.patches or [ ]) ++ [ ./discocss-no-launch.patch ];
  });

  # Remove autostart on nmapplet https://gitlab.gnome.org/GNOME/network-manager-applet/-/blob/main/meson_post_install.py
  networkmanagerapplet = prev.networkmanagerapplet.overrideAttrs (oldAttrs: rec {
    patches = (oldAttrs.patches or [ ]) ++ [ ./nm-applet-no-autostart.patch ];
  });

  # Add notify-send to networkmanager package path
  networkmanager_dmenu = prev.networkmanager_dmenu.overrideAttrs (oldAttrs: rec {
    propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ]) ++ [ prev.pkgs.libnotify ];
  });

  vimPlugins = prev.vimPlugins // {
    taxi-vim = prev.pkgs.callPackage ../pkgs/vimPlugins/taxi-vim.nix { };
  };

  fishPlugins = prev.fishPlugins // {
    autopair = prev.pkgs.callPackage ../pkgs/fishPlugins/autopair.nix { };
    colored_man_pages = prev.pkgs.callPackage ../pkgs/fishPlugins/colored_man_pages.nix { };
    tide = prev.pkgs.callPackage ../pkgs/fishPlugins/tide.nix { };
  };

  generated-gtk-themes = mapAttrs (_: scheme: gtkThemeFromScheme { inherit scheme; }) colorSchemes;

} // import ../pkgs { pkgs = prev; }
