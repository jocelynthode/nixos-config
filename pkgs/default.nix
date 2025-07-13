{
  pkgs ? null,
}:
{
  # My wallpaper collection
  wallpapers = pkgs.callPackage ./core/wallpapers { };

  # Packages with an actual source
  feathers = pkgs.callPackage ./core/feathers { };

  # Personal scripts
  toggle-bluetooth = pkgs.callPackage ./core/toggle-bluetooth { };
  fs-diff = pkgs.callPackage ./core/fs-diff { };
  dunst-notification-sound = pkgs.callPackage ./core/dunst-notification-sound { };
}
