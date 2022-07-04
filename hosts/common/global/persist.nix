{ inputs, ... }: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/systemd"
      "/var/lib/bluetooth" # Store registered bluetooth devices
      "/etc/mullvad-vpn"
      "/etc/nixos"
    ];
    files = [
      "/etc/machine-id"
    ];
    users.jocelyn = {
      directories = [
        # Base directories
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
        "Projects"
        "Programs"
        "go"

        # Work
        "Liip"
        ".local/share/networkmanagement/certificates" # Store VPN certificates
        ".config/taxi"
        ".local/share/taxi"
        ".local/share/zebra"
        { directory = ".kube"; mode = "0700"; }

        # Config
        { directory = ".config/Signal"; mode = "0700"; }
        { directory = ".config/Bitwarden"; mode = "0700"; }
        ".config/fish"
        ".config/Slack"
        ".config/spotify"
        ".config/kdeconnect"
        ".config/pavucontrol-qt"
        ".config/discord"

        # Local
        { directory = ".local/share/keyrings"; mode = "0700"; }
        ".local/share/fish"
        ".local/share/Mumble"
        ".local/state/wireplumber" # Store default sinks/sources
        ".local/share/Steam"

        # Cache
        { directory = ".cache/rbw"; mode = "0700"; } # Store database cache
        ".cache/betterlockscreen" # Store generated lockscreen images

        # Misc
        { directory = ".ssh"; mode = "0700"; }
        ".mozilla/firefox"
        ".steam"
        # TODO remove
        ".dotfiles"
      ];
    };
    users.root = {
      home = "/root";
      directories = [
        ".config/fish"
      ];
    };
  };

}
