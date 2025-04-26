{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.programs.lact.enable = lib.mkEnableOption "lact";

  config = lib.mkIf config.aspects.programs.lact.enable {
    aspects.base.persistence.systemPaths = [
      {
        directory = "/etc/lact";
      }
    ];
    environment.systemPackages = with pkgs; [
      lact
    ];
    systemd = {
      services.lactd.wantedBy = ["multi-user.target"];
      packages = with pkgs; [
        lact
      ];
    };
  };
}
