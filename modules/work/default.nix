{ inputs, ... }:
{
  flake.nixosModules.workModule =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [
        (inputs.import-tree.match "^/[^/]+/default\\.nix$" ./.)
      ];

      options.aspects.work.enable = lib.mkEnableOption "work";

      config = lib.mkIf config.aspects.work.enable {
        aspects = {
          development.enable = true;
          work = {
            git.enable = lib.mkDefault true;
            kubernetes.enable = lib.mkDefault true;
            openstack.enable = lib.mkDefault true;
            slack.enable = lib.mkDefault true;
            tailscale.enable = lib.mkDefault true;
            taxi.enable = lib.mkDefault true;
            terraform.enable = lib.mkDefault true;
            vpn.enable = lib.mkDefault true;
          };
        };

        aspects.base.persistence.homePaths = [
          "Liip"
          "poto"
        ];
      };
    };
}
