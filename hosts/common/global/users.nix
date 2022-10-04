{ pkgs, hostname, colorscheme, wallpaper, inputs, config, lib, home-manager, ... }: {
  users = {
    mutableUsers = false;
    users = {
      jocelyn = {
        isNormalUser = true;
        shell = pkgs.fish;
        passwordFile = config.sops.secrets."users/jocelyn/password".path;
        subUidRanges = [{ startUid = 100000; count = 65536; }]; #for podman containers
        subGidRanges = [{ startGid = 100000; count = 65536; }];
        extraGroups = [
          "wheel"
          "video"
          "audio"
          "camera"
        ]
        ++ (lib.optional config.networking.networkmanager.enable "networkmanager")
        ++ (lib.optional config.hardware.sane.enable "scanner")
        ++ (lib.optional config.programs.adb.enable "adbusers");

        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqHMPKXFUpyQO4evq2CV+p0T6JCkVWjNd9fk8EYUVG0mR/cfKAPGm6KnH3+W/F2exp6hB7lm/HfT+53aCtPPF/EZJb3qWhnVl6g48rQxXXo3rAWVjhD5u8drnFDjoAxGVexT7psDWyFHF9+6NFZPyCLswLjaxxIYITZfI6rcImjp/YMUOJz8tTHFrPRkhpy9t0fBerIfQSgbiW/3QuKZ8NNRMitZQL4ZG7gQAU6CRpOSMnCXHuELBnGbB91CVOscdNgXucxWegh+bznfUsEr38WlcgEmFkYjotFFe1TA7lf+baO0o3YNMyJQNJb/83N8UHm7CSOCeXAN530LLPXl2jg7l/FZk4egMhjdiMkAHJOeCNSO5JGoxE13zN2jWJPDJFP5II8eYUMCeplDcJsahtJRgqem7Xzwef6dIMcFzodGmzWOlNrHXjUc6b7bDzXRwCYKJLdiLTmuktPW+aYgiWywFCn8to1TKYEzcaFZRSMWwtawefK5vcrYtmoMB+w5FVLQhNrgDt4J5wbMe4w5mXgFCAygeRpfCdNfYJYBwMvnAd1ITIRpwURbzU4UDuTVed6caiOWEMV+PT0HwGmNFIrcoD7HFneV1o1vXuwP4rP0kCZ4fOFIapalKRn4aniQyz7Ltk9PIzwxA06O5LnMSh8vNV258Bkc7mUSb9wwRkCQ== openpgp:0xB8F44A8F"
        ];
        uid = 1000;
      };
      root = {
        home = "/root";
      };
    };
  };

  services.geoclue2.enable = true;

  home-manager.users = {
    jocelyn = {
      imports = builtins.attrValues (import ../../../modules/home-manager) ++ [
        ../../../home/jocelyn
      ];
    };
    root = {
      imports = builtins.attrValues (import ../../../modules/home-manager) ++ [
        ../../../home/root
      ];
    };
  };
}
