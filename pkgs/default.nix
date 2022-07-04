{ pkgs }: {
  # My wallpaper collection
  wallpapers = pkgs.callPackage ./core/wallpapers { };

  # Packages with an actual source
  feathers = pkgs.callPackage ./core/feathers { };

  # Personal scripts
  rofi-pulse = pkgs.callPackage ./core/rofi-pulse { };
  toggle-bluetooth = pkgs.callPackage ./core/toggle-bluetooth { };
}

