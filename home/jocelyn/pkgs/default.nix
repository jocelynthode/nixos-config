{ pkgs, config }: {
  polybar-bluetooth = pkgs.callPackage ./polybar-bluetooth { config = config; };
  polybar-mic = pkgs.callPackage ./polybar-mic { config = config; };
}
