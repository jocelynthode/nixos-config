{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ pinentry-gnome ];
  services.dbus.packages = with pkgs; [ gcr ];
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
