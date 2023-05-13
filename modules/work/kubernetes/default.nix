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
              fgColor = "#${config.colorScheme.colors.foreground}";
              bgColor = "default";
              logoColor = "#${config.colorScheme.colors.teal}";
            };
            prompt = {
              fgColor = "#${config.colorScheme.colors.foreground}";
              bgColor = "#${config.colorScheme.colors.background}";
              suggestColor = "#${config.colorScheme.colors.yellow}";
            };
            info = {
              fgColor = "#${config.colorScheme.colors.green}";
              sectionColor = "#${config.colorScheme.colors.foreground}";
            };
            dialog = {
              fgColor = "#${config.colorScheme.colors.foreground}";
              bgColor = "default";
              buttonFgColor = "#${config.colorScheme.colors.foreground}";
              buttonBgColor = "#${config.colorScheme.colors.teal}";
              buttonFocusFgColor = "#${config.colorScheme.colors.purple}";
              buttonFocusBgColor = "#${config.colorScheme.colors.green}";
              labelFgColor = "#${config.colorScheme.colors.yellow}";
              fieldFgColor = "#${config.colorScheme.colors.foreground}";
            };
            frame = {
              border = {
                fgColor = "#${config.colorScheme.colors.background02}";
                focusColor = "#${config.colorScheme.colors.background01}";
              };
              menu = {
                fgColor = "#${config.colorScheme.colors.foreground}";
                keyColor = "#${config.colorScheme.colors.green}";
                numKeyColor = "#${config.colorScheme.colors.green}";
              };
              crumbs = {
                fgColor = "#${config.colorScheme.colors.foreground}";
                bgColor = "#${config.colorScheme.colors.background01}";
                activeColor = "#${config.colorScheme.colors.background01}";
              };
              status = {
                newColor = "#${config.colorScheme.colors.foreground}";
                modifyColor = "#${config.colorScheme.colors.teal}";
                addColor = "#${config.colorScheme.colors.orange}";
                errorColor = "#${config.colorScheme.colors.blue}";
                highlightcolor = "#${config.colorScheme.colors.yellow}";
                killColor = "#${config.colorScheme.colors.background03}";
                completedColor = "#${config.colorScheme.colors.background03}";
              };
              title = {
                fgColor = "#${config.colorScheme.colors.foreground}";
                bgColor = "#${config.colorScheme.colors.background01}";
                highlightColor = "#${config.colorScheme.colors.yellow}";
                counterColor = "#${config.colorScheme.colors.teal}";
                filterColor = "#${config.colorScheme.colors.green}";
              };
            };
            views = {
              charts = {
                bgColor = "default";
                defaultDialColors = [
                  "#${config.colorScheme.colors.teal}"
                  "#${config.colorScheme.colors.blue}"
                ];
                defaultChartColors = [
                  "#${config.colorScheme.colors.teal}"
                  "#${config.colorScheme.colors.blue}"
                ];
              };
              table = {
                fgColor = "#${config.colorScheme.colors.foreground}";
                bgColor = "default";
                header = {
                  fgColor = "#${config.colorScheme.colors.foreground}";
                  bgColor = "default";
                  sorterColor = "#${config.colorScheme.colors.red}";
                };
              };
              xray = {
                fgColor = "#${config.colorScheme.colors.foreground}";
                bgColor = "default";
                cursorColor = "#${config.colorScheme.colors.background01}";
                graphicColor = "#${config.colorScheme.colors.teal}";
                showIcons = false;
              };
              yaml = {
                keyColor = "#${config.colorScheme.colors.green}";
                colonColor = "#${config.colorScheme.colors.teal}";
                valueColor = "#${config.colorScheme.colors.foreground}";
              };
              logs = {
                fgColor = "#${config.colorScheme.colors.foreground}";
                bgColor = "default";
                indicator = {
                  fgColor = "#${config.colorScheme.colors.foreground}";
                  bgColor = "#${config.colorScheme.colors.teal}";
                };
              };
              help = {
                fgColor = "#${config.colorScheme.colors.foreground}";
                bgColor = "#${config.colorScheme.colors.background}";
                indicator = {
                  fgColor = "#${config.colorScheme.colors.blue}";
                };
              };
            };
          };
        };
      };
    };
  };
}
