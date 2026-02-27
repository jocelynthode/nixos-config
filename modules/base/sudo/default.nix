{
  config = {
    security.sudo-rs = {
      enable = true;
      extraConfig = ''
        Defaults pwfeedback
      '';
    };
  };
}
