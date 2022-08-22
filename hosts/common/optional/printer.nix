{ pkgs, ... }: {
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };

  environment.systemPackages = with pkgs; [
    system-config-printer
  ];
}
