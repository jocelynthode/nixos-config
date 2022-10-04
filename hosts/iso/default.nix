{ pkgs, inputs, config, hostname, colorscheme, wallpaper, ... }: {
  imports = [
    inputs.home-manager.nixosModule
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.root.imports = builtins.attrValues (import ./../../modules/home-manager) ++ [
      ./../../home/root
    ];
    extraSpecialArgs = { inherit inputs hostname colorscheme wallpaper; }; # Pass flake variable
  };

  networking = {
    wireless.enable = false;
    networkmanager.enable = true;
  };

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqHMPKXFUpyQO4evq2CV+p0T6JCkVWjNd9fk8EYUVG0mR/cfKAPGm6KnH3+W/F2exp6hB7lm/HfT+53aCtPPF/EZJb3qWhnVl6g48rQxXXo3rAWVjhD5u8drnFDjoAxGVexT7psDWyFHF9+6NFZPyCLswLjaxxIYITZfI6rcImjp/YMUOJz8tTHFrPRkhpy9t0fBerIfQSgbiW/3QuKZ8NNRMitZQL4ZG7gQAU6CRpOSMnCXHuELBnGbB91CVOscdNgXucxWegh+bznfUsEr38WlcgEmFkYjotFFe1TA7lf+baO0o3YNMyJQNJb/83N8UHm7CSOCeXAN530LLPXl2jg7l/FZk4egMhjdiMkAHJOeCNSO5JGoxE13zN2jWJPDJFP5II8eYUMCeplDcJsahtJRgqem7Xzwef6dIMcFzodGmzWOlNrHXjUc6b7bDzXRwCYKJLdiLTmuktPW+aYgiWywFCn8to1TKYEzcaFZRSMWwtawefK5vcrYtmoMB+w5FVLQhNrgDt4J5wbMe4w5mXgFCAygeRpfCdNfYJYBwMvnAd1ITIRpwURbzU4UDuTVed6caiOWEMV+PT0HwGmNFIrcoD7HFneV1o1vXuwP4rP0kCZ4fOFIapalKRn4aniQyz7Ltk9PIzwxA06O5LnMSh8vNV258Bkc7mUSb9wwRkCQ== openpgp:0xB8F44A8F"
  ];

  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    curl
    any-nix-shell
    btrfs-progs
    nix
    git
    sops
    ssh-to-age
    parted
    gptfdisk
    cryptsetup
  ];
}
