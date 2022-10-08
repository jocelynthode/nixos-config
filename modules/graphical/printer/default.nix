{ config, lib, pkgs, ... }: {
  options.aspects.graphical.printer.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.graphical.printer.enable {
    services.printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };

    environment.systemPackages = with pkgs; [
      system-config-printer
    ];

    home-manager.users.jocelyn = { ... }: {
      home.packages = with pkgs; [ simple-scan ];
    };
  };
}
