{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.programs.yubikey.enable = lib.mkEnableOption "yubikey";

  config = lib.mkIf config.aspects.programs.yubikey.enable {
    services.udev.packages = with pkgs; [
      yubikey-personalization
    ];

    services.pcscd.enable = true;

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [
        yubikey-manager
        wofi-ykman
      ];
    };
  };
}
