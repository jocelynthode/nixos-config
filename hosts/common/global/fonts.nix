{ pkgs, ... }: {
  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
    fonts = with pkgs; [
      carlito
      vegur
      noto-fonts
      font-awesome
      corefonts
      material-design-icons
      material-icons
      feathers
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "Noto"
        ];
      })
    ];
  };
}
