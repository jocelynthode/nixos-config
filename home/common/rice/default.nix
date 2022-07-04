{ pkgs, config, inputs, ... }:

let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) colorschemeFromPicture nixWallpaperFromScheme;
in
{
  imports = [ inputs.nix-colors.homeManagerModule ];

  colorscheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard;
} 
