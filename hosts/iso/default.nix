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
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCfWwANBI/hiFVHf60jHaD4HAqFebg0GjCD/Up9jVR+1ocxHm2YycKhYpCba5XyvQsuDJTmWDBQI55EZAB1zuxsCcHicrqgS9Zo+EPAi6Dcr1q3kUYPx+p0DVlCwkym/9zsfidoCuIYtFpXjE0Q3PRPHduUp7hsZ/6rsWktHfTIhAWB8xsHZotQW2R1IDWubRLlhdUkiEwtkPcS8p6NeBIKQFQ/8W0CNG2J10jWH9X7fEy27AIHvy5OyczPkoSgUAhaBTyDjXu2tZw9sxYlO171Wl/lm/74Q+T8Vr/EJBW1qHfk3pYSzDmvdFgQDzY49I0NV3xdG9Bnvx6f8pm4WO/OrGByDF90GAUgdAvF2nRR8QXGpjO6/Q/rpZnx+t9YTJcdObg3SABFxYl1BCRDxpq4GuA8yQk8wG2KWREP9j4ollg2yxkOSC5Q20Vyfo06/CG4HeWFfpvdwcUqhotn0pvW3vIORa87fJyGcxFCtufhK/Fq4idEUnZqVfLGeTqkEaPNCDcgFsqTgapdwnWn4CU8um3x5wdurUWphtMc0vTBxF2ALNb+BRtXEGk3yyfjOgTku/G5+9XvpJwSW8dEf7C2UfAFUW8C7EI118cIbBJH1xvMR++0tw8Mi/ZgkPJszwKUQIvFUfH7tDsVSbN/A0ogtyz2QaVy770WS1ksMJCG0w== openpgp:0x2207C621"
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
