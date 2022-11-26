{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.programs.yubikey.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.yubikey.enable {
    services.udev.packages = with pkgs; [
      yubikey-personalization
    ];

    services.pcscd.enable = true;

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [
        yubikey-manager
        rofi-ykman
      ];
    };
  };
}
