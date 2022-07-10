{ config, pkgs, lib, ... }:
{
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  boot.initrd.systemd.enable = true;
}
