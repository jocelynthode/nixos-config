{pkgs, ...}: {
  # Machine-specific module settings
  aspects = {
    stateVersion = "25.05";
    base = {
      fileSystems.enable = false;
      sshd.PermitRootLogin = "yes";
    };
    programs = {
      git.enable = true;
    };
  };
  networking = {
    wireless.enable = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDt+7HTCLF1Q658UrgvVb4a47Jp3aJt8mBY4dWltoHXUqXFkgfU7Y1zoDyEtylXRaqqSi4sWwW2WDT6wmzSx5DPf7y8sj9gSSpCSMoDOXlO2ylZdWdShpgXRJ4DZ0zlM0oWk5iNb+OdWLRluu7K1IYJZe5wMl8+fDsdXLg29xep8CwpjYAFtgPREImS5r5whMHLsUHQ19u0p3cGN2tvh9SW9otCL2rcCWz2KV09/VKWCzc6x5eVnsZtvw9VSmBrpnlt/DgXTqgCeg3L6smRSlyslQzswxhEesMpp+JJRdSD2wcWDZGoVsR9Yhbk9tOOZ3s79k5w2XVTqzYQnLagAS2YkSgS1+0+Wi4G+lqZ8ypEo0hzSpI4HcNxlRXGSAykkvp+TqkAsoOXd/0PauB6N24TBpfi2VDF/EDWSviyhJwD2KU8mLqXya57HwheDX/e35TNpYUwavN1Nf4FXZ/VdN+13mlAbQSkDQRa+bn/HeZGRZTwXmV0Vl0BAS0m8wWNJ223HJTiEVLuJuPMS9xLSvredULISh/9hXW7Ma86bVHA69lK7To8EFZGLZhXb5QH4sJeekPMdsuuioitHb5a0TploRzBrFCqmBM7N85uyBt4gXjMkYpf/kGtGiOAV4k8n9mFDyoCl1MvnP3JlUzRhMJ41Rz4tgCPHZ7s3Hq9lkU3Vw== openpgp:0x0D3B55DC"
  ];

  environment.systemPackages = with pkgs; [
    git
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
    disko
  ];
}
