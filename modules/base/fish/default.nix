{
  config,
  pkgs,
  lib,
  ...
}: let
  base = _config: osConfig: {
    programs.fish = {
      enable = true;
      shellAliases = {
        cat = "${pkgs.bat}/bin/bat";
        ls = "${pkgs.lsd}/bin/lsd -l";
        tree = "${pkgs.lsd}/bin/lsd --tree";
        find = "${pkgs.fd}/bin/fd";
        keti = "${pkgs.kubectl}/bin/kubectl exec -ti";
      };
      shellAbbrs = {
        k = "kubectl";
        t = "terraform";
        n = "nvim";
        gst = "git status";
      };
      shellInit = ''
        set -U fish_greeting
        set -gx fish_key_bindings fish_user_key_bindings
      '';
      interactiveShellInit =
        ''
          any-nix-shell fish | source
        ''
        + lib.optionalString osConfig.aspects.work.kubernetes.enable ''set -gx PATH $PATH $HOME/.krew/bin'';
      functions = {
        fish_user_key_bindings = {
          body = ''
            fish_vi_key_bindings
            # bind -M insert -m default jk backward-char force-repaint
          '';
        };
      };
      plugins = [
        # { name = "tide"; inherit (pkgs.fishPlugins.tide) src; }
        {
          name = "fzf-fish";
          inherit (pkgs.fishPlugins.fzf-fish) src;
        }
        {
          name = "colored-man-pages";
          inherit (pkgs.fishPlugins.colored-man-pages) src;
        }
        {
          name = "autopair";
          inherit (pkgs.fishPlugins.autopair-fish) src;
        }
      ];
    };
  };
in {
  programs.fish = {
    enable = true;
    vendor = {
      completions.enable = true;
      config.enable = true;
      functions.enable = true;
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
        "$fill"
        "$status"
        "$cmd_duration"
        "$all"
        "$line_break"
        "$character"
      ];
      cmd_duration = {
        format = " [⏱ $duration]($style) ";
      };
      directory = {
        truncation_symbol = "…/";
        read_only = " 󰌾";
      };
      fill = {
        symbol = "·";
        style = "bright-black";
      };
      git_branch = {
        symbol = " ";
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };
      git_status = {
        format = "(([$conflicted](bright-red) )([$stashed](bright-green) )([$deleted](bright-red) )([$renamed](bright-yellow) )([$modified](bright-yellow) )([$staged](bright-yellow) )([$untracked](bright-blue) )[$ahead_behind](bright-green) )";
        conflicted = "=$count";
        ahead = "⇡$count";
        behind = "⇣$count";
        diverged = "⇡$ahead_count ⇣$behind_count";
        untracked = "?$count";
        stashed = "*$count";
        modified = "!$count";
        staged = "+$count";
        renamed = "»$count";
        deleted = "✖$count";
      };
      hostname = {
        ssh_symbol = "";
        format = "[$ssh_symbol$hostname]($style) ";
        style = "bold yellow";
      };
      kubernetes = {
        disabled = false;
        format = "[$symbol$context(/$namespace)]($style) ";
      };
      nix_shell = {
        symbol = " ";
        format = "[$symbol$name \\($state\\)]($style) ";
      };
      nodejs = {
        format = "[$symbol($version )]($style) ";
        disabled = true;
      };
      python = {
        symbol = " ";
        format = "[\${symbol}\${pyenv_prefix}(\${version} )(\($virtualenv\) )]($style) ";
      };
      status = {
        disabled = false;
        symbol = "✘";
        format = "[$symbol $status]($style) ";
      };
      time = {
        disabled = false;
        format = "[$time]($style) ";
        style = "bright-black";
      };
      username = {
        format = "[\${user}]($style) ";
      };
    };
  };

  aspects.base.persistence = {
    homePaths = [
      ".config/fish"
      ".local/share/fish"
    ];
    systemPaths = [
      "/root/.config/fish"
    ];
  };

  home-manager.users.jocelyn = {
    config,
    osConfig,
    ...
  }: (base config osConfig);
  home-manager.users.root = {
    config,
    osConfig,
    ...
  }: (base config osConfig);
}
