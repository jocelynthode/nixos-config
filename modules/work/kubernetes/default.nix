{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    aspects.work.kubernetes.enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.aspects.work.kubernetes.enable {
    aspects.base.persistence.homePaths = [
      {
        directory = ".kube";
        mode = "0700";
      }
    ];

    home-manager.users.jocelyn = {config, ...}
    : {
      home.packages = with pkgs; [
        kubectl
        kubectx
        kubelogin-oidc
        kubernetes-helm
        kubectl-node-shell
        # kubectl-get-all
        # kubectl-neat
        openshift
      ];

      programs.k9s = {
        enable = true;
        skin = {
          k9s = {
            body = {
              fgColor = "#${config.colorScheme.colors.base05}";
              bgColor = "default";
              logoColor = "#${config.colorScheme.colors.base0C}";
            };
            prompt = {
              fgColor = "#${config.colorScheme.colors.base05}";
              bgColor = "#${config.colorScheme.colors.base00}";
              suggestColor = "#${config.colorScheme.colors.base0A}";
            };
            info = {
              fgColor = "#${config.colorScheme.colors.base0B}";
              sectionColor = "#${config.colorScheme.colors.base05}";
            };
            dialog = {
              fgColor = "#${config.colorScheme.colors.base05}";
              bgColor = "default";
              buttonFgColor = "#${config.colorScheme.colors.base05}";
              buttonBgColor = "#${config.colorScheme.colors.base0C}";
              buttonFocusFgColor = "#${config.colorScheme.colors.base0E}";
              buttonFocusBgColor = "#${config.colorScheme.colors.base0B}";
              labelFgColor = "#${config.colorScheme.colors.base0A}";
              fieldFgColor = "#${config.colorScheme.colors.base05}";
            };
            frame = {
              border = {
                fgColor = "#${config.colorScheme.colors.base02}";
                focusColor = "#${config.colorScheme.colors.base01}";
              };
              menu = {
                fgColor = "#${config.colorScheme.colors.base05}";
                keyColor = "#${config.colorScheme.colors.base0B}";
                numKeyColor = "#${config.colorScheme.colors.base0B}";
              };
              crumbs = {
                fgColor = "#${config.colorScheme.colors.base05}";
                bgColor = "#${config.colorScheme.colors.base01}";
                activeColor = "#${config.colorScheme.colors.base01}";
              };
              status = {
                newColor = "#${config.colorScheme.colors.base05}";
                modifyColor = "#${config.colorScheme.colors.base0C}";
                addColor = "#${config.colorScheme.colors.base09}";
                errorColor = "#${config.colorScheme.colors.base0D}";
                highlightcolor = "#${config.colorScheme.colors.base0A}";
                killColor = "#${config.colorScheme.colors.base03}";
                completedColor = "#${config.colorScheme.colors.base03}";
              };
              title = {
                fgColor = "#${config.colorScheme.colors.base05}";
                bgColor = "#${config.colorScheme.colors.base01}";
                highlightColor = "#${config.colorScheme.colors.base0A}";
                counterColor = "#${config.colorScheme.colors.base0C}";
                filterColor = "#${config.colorScheme.colors.base0B}";
              };
            };
            views = {
              charts = {
                bgColor = "default";
                defaultDialColors = [
                  "#${config.colorScheme.colors.base0C}"
                  "#${config.colorScheme.colors.base0D}"
                ];
                defaultChartColors = [
                  "#${config.colorScheme.colors.base0C}"
                  "#${config.colorScheme.colors.base0D}"
                ];
              };
              table = {
                fgColor = "#${config.colorScheme.colors.base05}";
                bgColor = "default";
                header = {
                  fgColor = "#${config.colorScheme.colors.base05}";
                  bgColor = "default";
                  sorterColor = "#${config.colorScheme.colors.base08}";
                };
              };
              xray = {
                fgColor = "#${config.colorScheme.colors.base05}";
                bgColor = "default";
                cursorColor = "#${config.colorScheme.colors.base01}";
                graphicColor = "#${config.colorScheme.colors.base0C}";
                showIcons = false;
              };
              yaml = {
                keyColor = "#${config.colorScheme.colors.base0B}";
                colonColor = "#${config.colorScheme.colors.base0C}";
                valueColor = "#${config.colorScheme.colors.base05}";
              };
              logs = {
                fgColor = "#${config.colorScheme.colors.base05}";
                bgColor = "default";
                indicator = {
                  fgColor = "#${config.colorScheme.colors.base05}";
                  bgColor = "#${config.colorScheme.colors.base0C}";
                };
              };
              help = {
                fgColor = "#${config.colorScheme.colors.base05}";
                bgColor = "#${config.colorScheme.colors.base00}";
                indicator = {
                  fgColor = "#${config.colorScheme.colors.base0D}";
                };
              };
            };
          };
        };
      };
    };
  };
}
