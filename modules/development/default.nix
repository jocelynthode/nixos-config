{
  config,
  lib,
  ...
}:
{
  imports = [
    ./android
    ./containers
    ./libvirt
    ./ollama
    ./opencode
    ./qmk
    ./rust
  ];

  options.aspects.development.enable = lib.mkEnableOption "development";

  config = lib.mkIf config.aspects.development.enable {
    aspects = {
      development = {
        android.enable = lib.mkDefault true;
        containers.enable = lib.mkDefault true;
        libvirt.enable = lib.mkDefault true;
        ollama.enable = lib.mkDefault false;
        opencode.enable = lib.mkDefault false;
        qmk.enable = lib.mkDefault true;
        rust.enable = lib.mkDefault true;
      };
    };
  };
}
