{ pkgs, ... }: {
  security.pam.services = {
    login.enableGnomeKeyring = true;
    lightdm.enableGnomeKeyring = true;
  };
  environment.systemPackages = [ pkgs.gnome.gnome-keyring pkgs.pinentry-gnome ];
  services.dbus.packages = with pkgs; [ gnome.gnome-keyring gcr ];
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      gnome.gnome-keyring
    ];
  };
}
