{pkgs ? null}: {
  # My wallpaper collection
  wallpapers = pkgs.callPackage ./core/wallpapers {};

  # Packages with an actual source
  feathers = pkgs.callPackage ./core/feathers {};

  # Personal scripts
  rofi-pulse = pkgs.callPackage ./core/rofi-pulse {};
  rofi-sound-chooser = pkgs.callPackage ./core/rofi-sound-chooser {};
  rofi-ykman = pkgs.callPackage ./core/rofi-ykman {};
  toggle-bluetooth = pkgs.callPackage ./core/toggle-bluetooth {};
  wofi-powermenu = pkgs.callPackage ./core/wofi-powermenu {};
  fs-diff = pkgs.callPackage ./core/fs-diff {};
  dunst-notification-sound = pkgs.callPackage ./core/dunst-notification-sound {};
}
