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
        ".local/share/nvim"
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
        ".config/Mumble"
        ".config/dconf"
        ".config/qmk"
        ".config/deluge"

        # Local
        { directory = ".local/share/keyrings"; mode = "0700"; }
        ".local/share/fish"
        ".local/share/Mumble"
        ".local/state/wireplumber" # Store default sinks/sources
        ".local/share/Steam"
        ".local/share/containers"
        ".local/share/direnv"

        # Cache
        { directory = ".cache/rbw"; mode = "0700"; } # Store database cache
        ".cache/betterlockscreen" # Store generated lockscreen images
        ".cache/mozilla/firefox"

        # Misc
        { directory = ".ssh"; mode = "0700"; }
        { directory = ".gnupg"; mode = "0700"; }
        ".mozilla/firefox"
        ".steam"
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
