{
  config,
  lib,
  ...
}: {
  options.aspects.services.redis.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.redis.enable {
    aspects.base.persistence.systemPaths = [
      {
        directory = "/var/lib/redis";
        user = "postgres";
        group = "postgres";
      }
    ];

    services.redis.servers."" = {
      enable = true;
    };
  };
}
