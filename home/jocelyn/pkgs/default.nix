{ pkgs, config }: {
  polybar-bluetooth = pkgs.callPackage ./polybar-bluetooth { config = config; };
  polybar-gammastep = pkgs.callPackage ./polybar-gammastep { config = config; };
  polybar-mic = pkgs.callPackage ./polybar-mic { config = config; };
}
