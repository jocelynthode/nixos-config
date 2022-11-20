{
  lib,
  config,
  ...
}: let
  mkFontOption = kind: {
    family = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "Family name for ${kind} font profile";
      example = "JetBrainsMono";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = null;
      description = "Package for ${kind} font profile";
      example = "pkgs.jetbrains-mono";
    };
    size = lib.mkOption {
      type = lib.types.int;
      default = null;
      description = "Size for ${kind} font profile";
      example = 11;
    };
  };
  base = {
    home.packages = [config.aspects.base.fonts.monospace.package config.aspects.base.fonts.regular.package];
  };
in {
  options.aspects.base.fonts = {
    monospace = mkFontOption "monospace";
    regular = mkFontOption "regular";
  };

  config = {
    home-manager.users.jocelyn = _: base;
    home-manager.users.root = _: base;
  };
}
