{ pkgs }: {
  # My wallpaper collection
  wallpapers = pkgs.callPackage ./core/wallpapers { };

  # Packages with an actual source
  feathers = pkgs.callPackage ./core/feathers { };
  kubectl-node-shell = pkgs.callPackage ./core/kubectl-node-shell { };

  # Personal scripts
  rofi-pulse = pkgs.callPackage ./core/rofi-pulse { };
  toggle-bluetooth = pkgs.callPackage ./core/toggle-bluetooth { };
  fs-diff = pkgs.callPackage ./core/fs-diff { };
  dunst-notification-sound = pkgs.callPackage ./core/dunst-notification-sound { };
}

