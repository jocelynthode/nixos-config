{ config, pkgs, lib, ... }:

let
  base = config: {
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
      };
      shellInit = ''
        set -U fish_greeting
        set -gx fish_key_bindings fish_user_key_bindings
      '';
      interactiveShellInit = ''
        any-nix-shell fish | source
      '';
      functions = {
        fish_user_key_bindings = {
          body = ''
            fish_vi_key_bindings
            bind -M insert -m default jk backward-char force-repaint
          '';
        };
      };
      plugins = [
        # { name = "tide"; inherit (pkgs.fishPlugins.tide) src; }
        { name = "fzf-fish"; inherit (pkgs.fishPlugins.fzf-fish) src; }
        { name = "colored-man-pages"; inherit (pkgs.fishPlugins.colored-man-pages) src; }
        { name = "autopair"; inherit (pkgs.fishPlugins.autopair-fish) src; }
      ];
    };

    xdg.configFile."fish/conf.d/fzf-theme.fish" = {
      text = ''
        set -l color00 '#${config.colorScheme.colors.base00}'
        set -l color01 '#${config.colorScheme.colors.base01}'
        set -l color02 '#${config.colorScheme.colors.base02}'
        set -l color03 '#${config.colorScheme.colors.base03}'
        set -l color04 '#${config.colorScheme.colors.base04}'
        set -l color05 '#${config.colorScheme.colors.base05}'
        set -l color06 '#${config.colorScheme.colors.base06}'
        set -l color07 '#${config.colorScheme.colors.base07}'
        set -l color08 '#${config.colorScheme.colors.base08}'
        set -l color09 '#${config.colorScheme.colors.base09}'
        set -l color0A '#${config.colorScheme.colors.base0A}'
        set -l color0B '#${config.colorScheme.colors.base0B}'
        set -l color0C '#${config.colorScheme.colors.base0C}'
        set -l color0D '#${config.colorScheme.colors.base0D}'
        set -l color0E '#${config.colorScheme.colors.base0E}'
        set -l color0F '#${config.colorScheme.colors.base0F}'

        set -l FZF_NON_COLOR_OPTS

        for arg in (echo $FZF_DEFAULT_OPTS | tr " " "\n")
            if not string match -q -- "--color*" $arg
                set -a FZF_NON_COLOR_OPTS $arg
            end
        end

        set -Ux FZF_DEFAULT_OPTS "$FZF_NON_COLOR_OPTS"\
        " --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
        " --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
        " --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"
      '';
    };
  };
in
{
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
        "$cmd_duration"
        "$all"
        "$line_break"
        "$character"
      ];
      cmd_duration = {
        format = " [祥$duration]($style) ";
      };
      directory = {
        truncation_symbol = "…/";
        read_only = " ";
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
        deleted = "✘$count";
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
        format = " [$symbol$state]($style) ";
      };
      nodejs = {
        format = "[$symbol($version )]($style) ";
        disabled = true;
      };
      python = {
        symbol = " ";
        format = "[\${symbol}\${pyenv_prefix}(\${version} )(\($virtualenv\) )]($style) ";
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

  home-manager.users.jocelyn = { config, ... }: (base config);
  home-manager.users.root = { config, ... }: (base config);
}
