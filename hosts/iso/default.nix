{ pkgs, inputs, config, hostname, ... }: {
  imports = [
    inputs.home-manager.nixosModule
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; }; # Pass flake variable
    users.root = {
      imports = [ ./../../home/root ];
    };
  };

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNw5wtM2BvjEcatJfnW28HwLK617om8YM8Ca/RIeuEK1eULcZxGdQ++QzfUdRrX57RLfVjzYawKWAmhh3g/OFC2vcfD+PUYiBoNAY0crBkf3e94RtvXPp6Cma13aEOJA6haatt3u7G7aehJCEFqdfR62coULoHHUPIykoC1Tnbdu0a5ZVkUdj3OPVTbRIlkfokbRueRTQ9cbPrFbfDq6ZlftvPm3UuTHObOrKPCjdtmHLHH5/jMZG254QpZ5hmMMYlHutC2lxBx3Rhqs6nv4RinixmrIZ7Z5Xpu0CLXQeGtnfTT/kdSDvrTFfZln26KX4KXHv/93EN4sHysxwsrBKF jocelyn"
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
    rage
    ragenix
    parted
    gptfdisk
    cryptsetup
  ];
}
