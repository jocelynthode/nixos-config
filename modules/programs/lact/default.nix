{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.programs.lact.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.lact.enable {
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
