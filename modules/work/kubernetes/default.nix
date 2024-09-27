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
      {
        directory = ".krew";
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
        kubectl-view-secret
        # kubectl-get-all
        kubectl-neat
        openshift
        krew
      ];

      programs.k9s = {
        enable = true;
        skins = {
          skins = {
            k9s = {
              body = {
                fgColor = "#${config.colorScheme.palette.foreground}";
                bgColor = "default";
                logoColor = "#${config.colorScheme.palette.teal}";
              };
              prompt = {
                fgColor = "#${config.colorScheme.palette.foreground}";
                bgColor = "#${config.colorScheme.palette.background}";
                suggestColor = "#${config.colorScheme.palette.yellow}";
              };
              info = {
                fgColor = "#${config.colorScheme.palette.green}";
                sectionColor = "#${config.colorScheme.palette.foreground}";
              };
              dialog = {
                fgColor = "#${config.colorScheme.palette.foreground}";
                bgColor = "default";
                buttonFgColor = "#${config.colorScheme.palette.foreground}";
                buttonBgColor = "#${config.colorScheme.palette.teal}";
                buttonFocusFgColor = "#${config.colorScheme.palette.purple}";
                buttonFocusBgColor = "#${config.colorScheme.palette.green}";
                labelFgColor = "#${config.colorScheme.palette.yellow}";
                fieldFgColor = "#${config.colorScheme.palette.foreground}";
              };
              frame = {
                border = {
                  fgColor = "#${config.colorScheme.palette.background02}";
                  focusColor = "#${config.colorScheme.palette.background01}";
                };
                menu = {
                  fgColor = "#${config.colorScheme.palette.foreground}";
                  keyColor = "#${config.colorScheme.palette.green}";
                  numKeyColor = "#${config.colorScheme.palette.green}";
                };
                crumbs = {
                  fgColor = "#${config.colorScheme.palette.foreground}";
                  bgColor = "#${config.colorScheme.palette.background01}";
                  activeColor = "#${config.colorScheme.palette.background01}";
                };
                status = {
                  newColor = "#${config.colorScheme.palette.foreground}";
                  modifyColor = "#${config.colorScheme.palette.teal}";
                  addColor = "#${config.colorScheme.palette.orange}";
                  errorColor = "#${config.colorScheme.palette.blue}";
                  highlightcolor = "#${config.colorScheme.palette.yellow}";
                  killColor = "#${config.colorScheme.palette.background03}";
                  completedColor = "#${config.colorScheme.palette.background03}";
                };
                title = {
                  fgColor = "#${config.colorScheme.palette.foreground}";
                  bgColor = "#${config.colorScheme.palette.background01}";
                  highlightColor = "#${config.colorScheme.palette.yellow}";
                  counterColor = "#${config.colorScheme.palette.teal}";
                  filterColor = "#${config.colorScheme.palette.green}";
                };
              };
              views = {
                charts = {
                  bgColor = "default";
                  defaultDialColors = [
                    "#${config.colorScheme.palette.teal}"
                    "#${config.colorScheme.palette.blue}"
                  ];
                  defaultChartColors = [
                    "#${config.colorScheme.palette.teal}"
                    "#${config.colorScheme.palette.blue}"
                  ];
                };
                table = {
                  fgColor = "#${config.colorScheme.palette.foreground}";
                  bgColor = "default";
                  header = {
                    fgColor = "#${config.colorScheme.palette.foreground}";
                    bgColor = "default";
                    sorterColor = "#${config.colorScheme.palette.red}";
                  };
                };
                xray = {
                  fgColor = "#${config.colorScheme.palette.foreground}";
                  bgColor = "default";
                  cursorColor = "#${config.colorScheme.palette.background01}";
                  graphicColor = "#${config.colorScheme.palette.teal}";
                  showIcons = false;
                };
                yaml = {
                  keyColor = "#${config.colorScheme.palette.green}";
                  colonColor = "#${config.colorScheme.palette.teal}";
                  valueColor = "#${config.colorScheme.palette.foreground}";
                };
                logs = {
                  fgColor = "#${config.colorScheme.palette.foreground}";
                  bgColor = "default";
                  indicator = {
                    fgColor = "#${config.colorScheme.palette.foreground}";
                    bgColor = "#${config.colorScheme.palette.teal}";
                  };
                };
                help = {
                  fgColor = "#${config.colorScheme.palette.foreground}";
                  bgColor = "#${config.colorScheme.palette.background}";
                  indicator = {
                    fgColor = "#${config.colorScheme.palette.blue}";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
