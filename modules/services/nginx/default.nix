{ config, lib, ... }: {
  options.aspects.services.nginx.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.nginx.enable {
    networking.firewall.allowedTCPPorts = [ 8080 ];
    services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      virtualHosts."tekila.ovh" = {
        root = "/var/www/dde";
        listen = [{ port = 8080; addr = "0.0.0.0"; ssl = false; }];
        locations."/" = {
          extraConfig = ''
            autoindex on;
            autoindex_exact_size on;
          '';
        };
      };
    };
  };
}
