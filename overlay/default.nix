{inputs, ...}: final: prev:
{
  vimPlugins =
    prev.vimPlugins
    // {
      taxi-vim = prev.pkgs.callPackage ../pkgs/vimPlugins/taxi-vim {};
      deferred-clipboard-nvim = prev.pkgs.callPackage ../pkgs/vimPlugins/deferred-clipboard-nvim {};
      search-replace-nvim = prev.pkgs.callPackage ../pkgs/vimPlugins/search-replace-nvim {};
      nvim-dap-repl-highlights = prev.pkgs.callPackage ../pkgs/vimPlugins/nvim-dap-repl-highlights {};
      codecompanion-nvim = prev.vimPlugins.codecompanion-nvim.overrideAttrs (oldAttrs: {
        src = oldAttrs.src.override {
          rev = "5df1c562efee2a60969ffaabafd2301dce5b274e";
          sha256 = "sha256-E80P+hjUv/0Ei8dJ19Lsx1FJcaZS9T8n73O/5Cpr2DU=";
        };
      });
    };

  slack = prev.slack.overrideAttrs (previousAttrs: {
    installPhase =
      previousAttrs.installPhase
      + ''
        sed -i'.backup' -e 's/,"WebRTCPipeWireCapturer"/,"LebRTCPipeWireCapturer"/' $out/lib/slack/resources/app.asar

      '';
  });

  devenv = inputs.devenv.packages.${final.system}.default;

  proton-ge-custom = prev.pkgs.callPackage ../pkgs/core/proton-ge-custom {};

  mm-server-ui = prev.pkgs.callPackage ../pkgs/services/media-homepage {};
}
// import ../pkgs {pkgs = final;}
