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
      };

    waybar = prev.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    });

    devenv = inputs.devenv.defaultPackage.${final.system};

    generated-gtk-themes =
      mapAttrs
      (_: scheme:
        gtkThemeFromScheme {
          inherit scheme;
        })
      colorSchemes;
  }
  // import ../pkgs {pkgs = final;}
