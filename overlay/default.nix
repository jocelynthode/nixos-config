{ inputs, ... }: final: prev:
let
  inherit (inputs.nix-colors.lib-contrib { pkgs = final; }) gtkThemeFromScheme;
  inherit (inputs.nix-colors) colorSchemes;
  inherit (builtins) mapAttrs;
in
rec {
  vimPlugins = prev.vimPlugins // {
    taxi-vim = prev.pkgs.callPackage ../pkgs/vimPlugins/taxi-vim { };
    nvim-dap-go = prev.pkgs.callPackage ../pkgs/vimPlugins/nvim-dap-go { };
  };

  fishPlugins = prev.fishPlugins // {
    colored-man-pages = prev.pkgs.callPackage ../pkgs/fishPlugins/colored-man-pages { };
    tide = prev.pkgs.callPackage ../pkgs/fishPlugins/tide { };
  };

  waybar = prev.waybar.overrideAttrs (oldAttrs: {
    mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  });

  generated-gtk-themes = mapAttrs
    (_: scheme: gtkThemeFromScheme {
      inherit scheme;
    })
    colorSchemes;

} // import ../pkgs { pkgs = final; }
