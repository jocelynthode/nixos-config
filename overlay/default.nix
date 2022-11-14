{ inputs, ... }: final: prev:
let
  inherit (inputs.nix-colors.lib-contrib { pkgs = final; }) gtkThemeFromScheme;
  inherit (inputs.nix-colors) colorSchemes;
  inherit (builtins) mapAttrs;
in
rec {
  vimPlugins = prev.vimPlugins // {
    taxi-vim = prev.pkgs.callPackage ../pkgs/vimPlugins/taxi-vim { };
    nvim-dap-python = prev.pkgs.callPackage ../pkgs/vimPlugins/nvim-dap-python { };
    nvim-dap-go = prev.pkgs.callPackage ../pkgs/vimPlugins/nvim-dap-go { };
    telescope-live-grep-args-nvim = prev.pkgs.callPackage ../pkgs/vimPlugins/telescope-live-grep-args-nvim { };
  };

  fishPlugins = prev.fishPlugins // {
    autopair = prev.pkgs.callPackage ../pkgs/fishPlugins/autopair { };
    colored_man_pages = prev.pkgs.callPackage ../pkgs/fishPlugins/colored_man_pages { };
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
