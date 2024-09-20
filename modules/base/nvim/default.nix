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
        plenary-nvim
        nvim-web-devicons
        lualine-lsp-progress
        better-escape-nvim
        nvim-ts-context-commentstring
        telescope-ui-select-nvim
        telescope-fzf-native-nvim
        telescope-dap-nvim
        telescope-live-grep-args-nvim
        vim-fugitive
        lspkind-nvim
        cmp-nvim-lsp
        cmp-nvim-lua
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp_luasnip
        cmp-dap
        luasnip
        friendly-snippets
        none-ls-nvim
        SchemaStore-nvim
        taxi-vim
        nvim-notify
        nvim-dap-ui
        nvim-dap-python
        nvim-dap-go
        nvim-dap-virtual-text
        nvim-dap-repl-highlights

        nui-nvim
        vim-helm
        lspsaga-nvim
        nvim-lsp-notify
        crates-nvim
        rust-tools-nvim
        {
          plugin = indent-blankline-nvim;
          config = builtins.readFile ./plugins/indentline.lua;
          type = "lua";
        }
        {
          plugin = noice-nvim;
          config = builtins.readFile ./plugins/noice.lua;
          type = "lua";
        }
        {
          plugin = mini-nvim;
          config = builtins.readFile ./plugins/mini.lua;
          type = "lua";
        }
        {
          plugin = catppuccin-nvim;
          config = builtins.readFile ./plugins/theme.lua;
          type = "lua";
        }
        {
          plugin = nvim-dap;
          config = builtins.readFile ./plugins/dap.lua;
          type = "lua";
        }
        {
          plugin = nvim-cmp;
          config = builtins.readFile ./plugins/cmp.lua;
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
          plugin = rainbow-delimiters-nvim;
          config = "require('rainbow-delimiters.setup').setup()\n";
          type = "lua";
        }
        {
          plugin = nvim-lastplace;
          config = "require('nvim-lastplace').setup()\n";
          type = "lua";
        }
        {
          plugin = search-replace-nvim;
          config = "require('search-replace').setup()\n";
          type = "lua";
        }
        {
          plugin = deferred-clipboard-nvim;
          config = "require('deferred-clipboard').setup({fallback = 'unnamedplus'})\n";
          type = "lua";
        }
        {
          plugin = nvim-tree-lua;
          config = builtins.readFile ./plugins/tree.lua;
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
          plugin = which-key-nvim;
          config = builtins.readFile ./plugins/whichkey.lua;
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
        ruff
        nodePackages.yaml-language-server
        nodePackages.vscode-json-languageserver
        nodePackages.vim-language-server
        nodePackages.dockerfile-language-server-nodejs
        basedpyright
        bash-language-server

        nil
        alejandra
        rust-analyzer
        lua-language-server
        terraform-ls
        terraform

        # none-ls
        nodePackages.prettier
        gitlint
        shfmt
        hadolint
        python3Packages.black
        python3Packages.flake8
      ];

      # use python3_host_prog as python path to use here
      extraPython3Packages = ps:
        with ps; [
          debugpy
          setuptools
        ];

      # local llm_ls_bin_path = '${pkgs.llm-ls}/bin/llm-ls'
      extraLuaConfig =
        ''
          vim.loader.enable()
          local rust_vscode_extension_path = '${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/'
        ''
        + (builtins.readFile ./core/mappings.lua)
        + (builtins.readFile ./core/options.lua)
        + (builtins.readFile ./core/autocmds.lua)
        + (builtins.readFile ./core/utils.lua);

      # We must require plugin before colorscheme
      # extraConfig = ''
      #   lua require('base16-colorscheme').with_config {telescope = false}
      #
      #   colorscheme base16-${config.colorScheme.slug}
      # '';
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
