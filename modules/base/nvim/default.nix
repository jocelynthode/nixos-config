{pkgs, ...}: let
  base = config: {
    home = {
      sessionVariables.EDITOR = "nvim";
    };
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withPython3 = true;
      withNodeJs = false;
      withRuby = false;

      plugins = with pkgs.vimPlugins; [
        # Mulst always be at the top
        {
          plugin = impatient-nvim;
          config = (builtins.readFile ./plugins/impatient.lua) + (builtins.readFile ./core/mappings.lua) + (builtins.readFile ./core/options.lua) + (builtins.readFile ./core/autocmds.lua) + (builtins.readFile ./core/utils.lua);
          type = "lua";
        }

        popup-nvim
        plenary-nvim
        nvim-web-devicons
        vim-bbye
        lualine-lsp-progress
        FixCursorHold-nvim
        nvim-base16
        better-escape-nvim
        nvim-ts-context-commentstring
        telescope-ui-select-nvim
        telescope-fzf-native-nvim
        telescope-dap-nvim
        vim-fugitive
        cmp-nvim-lsp
        cmp-nvim-lua
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp_luasnip
        cmp-dap
        luasnip
        friendly-snippets
        null-ls-nvim
        SchemaStore-nvim
        taxi-vim
        nvim-notify
        nvim-dap-ui
        nvim-dap-python
        nvim-dap-go
        nvim-dap-virtual-text
        vim-helm
        telescope-live-grep-args-nvim
        glance-nvim
        nvim-treesitter-textobjects
        {
          plugin = nvim-dap;
          config = builtins.readFile ./plugins/dap.lua;
          type = "lua";
        }
        {
          plugin = nvim-lspconfig;
          config = builtins.readFile ./plugins/lsp.lua;
          type = "lua";
        }
        {
          plugin = nvim-treesitter.withAllGrammars;
          config = builtins.readFile ./plugins/treesitter.lua;
          type = "lua";
        }
        {
          plugin = gitsigns-nvim;
          config = builtins.readFile ./plugins/gitsigns.lua;
          type = "lua";
        }
        {
          plugin = telescope-nvim;
          config = builtins.readFile ./plugins/telescope.lua;
          type = "lua";
        }
        {
          plugin = dressing-nvim;
          config = builtins.readFile ./plugins/dressing.lua;
          type = "lua";
        }
        {
          plugin = nvim-colorizer-lua;
          config = "require('colorizer').setup()\n";
          type = "lua";
        }
        {
          plugin = nvim-lastplace;
          config = "require('nvim-lastplace').setup()\n";
          type = "lua";
        }
        {
          plugin = nvim-autopairs;
          config = builtins.readFile ./plugins/autopairs.lua;
          type = "lua";
        }
        {
          plugin = comment-nvim;
          config = builtins.readFile ./plugins/comment.lua;
          type = "lua";
        }
        {
          plugin = indent-blankline-nvim;
          config = builtins.readFile ./plugins/indentline.lua;
          type = "lua";
        }
        {
          plugin = surround-nvim;
          config = builtins.readFile ./plugins/surround.lua;
          type = "lua";
        }
        {
          plugin = nvim-tree-lua;
          config = builtins.readFile ./plugins/nvimtree.lua;
          type = "lua";
        }
        {
          plugin = bufferline-nvim;
          config = builtins.readFile ./plugins/bufferline.lua;
          type = "lua";
        }
        {
          plugin = lualine-nvim;
          config = builtins.readFile ./plugins/lualine.lua;
          type = "lua";
        }
        {
          plugin = toggleterm-nvim;
          config = builtins.readFile ./plugins/toggleterm.lua;
          type = "lua";
        }
        {
          plugin = alpha-nvim;
          config = builtins.readFile ./plugins/alpha.lua;
          type = "lua";
        }
        {
          plugin = which-key-nvim;
          config = builtins.readFile ./plugins/whichkey.lua;
          type = "lua";
        }
        {
          plugin = nvim-cmp;
          config = builtins.readFile ./plugins/cmp.lua;
          type = "lua";
        }
      ];

      extraPackages = with pkgs; [
        gcc
        fzf
        gopls
        go
        golint
        delve
        nodePackages.yaml-language-server
        nodePackages.bash-language-server
        nodePackages.vscode-json-languageserver
        nodePackages.vim-language-server
        nodePackages.dockerfile-language-server-nodejs

        nil
        alejandra
        rust-analyzer
        shellcheck
        sumneko-lua-language-server
        terraform-ls
        terraform

        # null-ls
        nodePackages.prettier
        gitlint
        shfmt
        hadolint
      ];

      # use python3_host_prog as python path to use here
      extraPython3Packages = ps:
        with ps; [
          python-lsp-server
          python-lsp-black
          pyls-isort
          debugpy
          setuptools
        ];

      # We must require plugin before colorscheme
      extraConfig = ''
        lua require('base16-colorscheme').with_config {telescope = false}

        colorscheme base16-${config.colorScheme.slug}
      '';
    };
  };
in {
  aspects.base.persistence.homePaths = [
    ".cache/nvim"
    ".local/state/nvim"
  ];
  home-manager.users.jocelyn = {config, ...}: (base config);
  home-manager.users.root = {config, ...}: (base config);
}
