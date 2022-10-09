{ config, lib, ... }: {
  imports = [
    ./android
    ./containers
    ./qmk
  ];

  options.aspects.development.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.development.enable {
    aspects = {
      development = {
        android.enable = lib.mkDefault true;
        containers.enable = lib.mkDefault true;
        qmk.enable = lib.mkDefault true;
      };
    };
  };
}
