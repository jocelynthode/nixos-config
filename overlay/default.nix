{inputs, ...}: final: prev: let
  inherit (inputs.nix-colors.lib-contrib {pkgs = final;}) gtkThemeFromScheme;
  inherit (inputs.nix-colors) colorSchemes;
  inherit (builtins) mapAttrs;
in
  {
    vimPlugins =
      prev.vimPlugins
      // {
        taxi-vim = prev.pkgs.callPackage ../pkgs/vimPlugins/taxi-vim {};
        glance-nvim = prev.pkgs.callPackage ../pkgs/vimPlugins/glance-nvim {};
        deferred-clipboard-nvim = prev.pkgs.callPackage ../pkgs/vimPlugins/deferred-clipboard-nvim {};
        search-replace-nvim = prev.pkgs.callPackage ../pkgs/vimPlugins/search-replace-nvim {};
      };

    waybar = prev.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    });

    devenv = inputs.devenv.defaultPackage.${final.system};

    proton-ge-custom = prev.pkgs.callPackage ../pkgs/core/proton-ge-custom {};

    mm-server-ui = prev.pkgs.callPackage ../pkgs/services/media-homepage {};

    generated-gtk-themes =
      mapAttrs
      (_: scheme:
        gtkThemeFromScheme {
          inherit scheme;
        })
      colorSchemes;
  }
  // import ../pkgs {pkgs = final;}
