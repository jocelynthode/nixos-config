{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.graphical.printer.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.graphical.printer.enable {
    hardware.sane.enable = true;

    services = {
      printing = {
        enable = true;
        drivers = [pkgs.brlaser];
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
      };
    };

    environment.systemPackages = with pkgs; [
      system-config-printer
    ];

    users.users.jocelyn.extraGroups = ["scanner"];

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [simple-scan];
    };
  };
}
