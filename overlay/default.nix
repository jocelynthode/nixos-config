{inputs, ...}: final: prev:
{
  vimPlugins =
    prev.vimPlugins
    // {
      taxi-vim = prev.pkgs.callPackage ../pkgs/vimPlugins/taxi-vim {};
      nvim-dap-repl-highlights = prev.pkgs.callPackage ../pkgs/vimPlugins/nvim-dap-repl-highlights {};
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
