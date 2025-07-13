{
  config,
  lib,
  ...
}:
{
  options.aspects.services.nginx.enable = lib.mkEnableOption "nginx";

  config = lib.mkIf config.aspects.services.nginx.enable {
    services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      appendHttpConfig = ''
        access_log syslog:server=unix:/dev/log combined;
      '';
    };
  };
}
