{ inputs, system, ... }: final: prev:
let
  inherit (inputs.nix-colors.lib-contrib { pkgs = final; }) gtkThemeFromScheme;
  inherit (inputs.nix-colors) colorSchemes;
  inherit (builtins) mapAttrs;
in
rec {
  # Don't launch discord when using discocss
  discocss = prev.discocss.overrideAttrs (oldAttrs: rec {
    patches = (oldAttrs.patches or [ ]) ++ [ ./discocss-no-launch.patch ];
  });

  vimPlugins = prev.vimPlugins // {
    taxi-vim = prev.pkgs.callPackage ../pkgs/vimPlugins/taxi-vim { };
    nvim-dap-python = prev.pkgs.callPackage ../pkgs/vimPlugins/nvim-dap-python { };
  };

  fishPlugins = prev.fishPlugins // {
    autopair = prev.pkgs.callPackage ../pkgs/fishPlugins/autopair { };
    colored_man_pages = prev.pkgs.callPackage ../pkgs/fishPlugins/colored_man_pages { };
    tide = prev.pkgs.callPackage ../pkgs/fishPlugins/tide { };
  };

  generated-gtk-themes = mapAttrs
    (_: scheme: gtkThemeFromScheme {
      inherit scheme;
    })
    colorSchemes;

} // import ../pkgs { pkgs = final; }
