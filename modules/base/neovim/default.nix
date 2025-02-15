{
  pkgs,
  nixvim,
  ...
}: let
  base = _config: {
    imports = [
      ./core/autocmds.nix
      ./core/keymaps.nix
      ./themes/catppuccin.nix
      ./plugins/blink-cmp.nix
      ./plugins/bufferline.nix
      ./plugins/codecompanion.nix
      ./plugins/dap.nix
      ./plugins/dressing.nix
      ./plugins/gitsigns.nix
      ./plugins/indent-blankline.nix
      ./plugins/lsp.nix
      ./plugins/lualine.nix
      ./plugins/mini.nix
      ./plugins/noice.nix
      ./plugins/none-ls.nix
      ./plugins/nvim-tree.nix
      ./plugins/render-mardown.nix
      ./plugins/telescope.nix
      ./plugins/toggleterm.nix
      ./plugins/treesitter.nix
      ./plugins/which-key.nix
    ];

    home = {
      sessionVariables.EDITOR = "nvim";
    };

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      luaLoader.enable = true;

      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };

      opts = {
        backup = false;
        clipboard = "unnamedplus";
        cmdheight = 2;
        completeopt = ["menuone" "noselect"];
        conceallevel = 0;
        fileencoding = "utf-8";
        foldenable = false;
        hlsearch = true;
        ignorecase = true;
        mouse = "a";
        pumheight = 10;
        showmode = false;
        showtabline = 2;
        smartcase = true;
        smartindent = true;
        splitbelow = true;
        splitright = true;
        swapfile = false;
        termguicolors = true;
        background = "light";
        timeoutlen = 250;
        undofile = true;
        updatetime = 300;
        writebackup = false;
        expandtab = true;
        shiftwidth = 2;
        tabstop = 2;
        cursorline = true;
        number = true;
        relativenumber = true;
        numberwidth = 3;
        signcolumn = "yes";
        wrap = false;
        scrolloff = 8;
        sidescrolloff = 8;
        guifont = "JetBrainsMono NFM:h11";
        laststatus = 3;
        inccommand = "split";
        synmaxcol = 250;
      };

      plugins = {
        web-devicons.enable = true;
        better-escape.enable = true;
        fugitive.enable = true;
        luasnip.enable = true;
        friendly-snippets.enable = true;
        notify.enable = true;
        nui.enable = true;
        helm.enable = true;
        crates.enable = true;
        rustaceanvim.enable = true;
        grug-far.enable = true;
        codecompanion.enable = true;
        rainbow-delimiters.enable = true;
        lastplace.enable = true;
      };
      extraPlugins = with pkgs.vimPlugins; [
        telescope-dap-nvim
        taxi-vim
        nvim-dap-repl-highlights
        nvim-lsp-notify
        search-replace-nvim
        deferred-clipboard-nvim
      ];

      extraConfigLua = ''
        vim.opt.whichwrap:append("<>[]hl")
        vim.opt.iskeyword:append("-")

        require('search-replace').setup()
        require('deferred-clipboard').setup({fallback = 'unnamedplus'})
      '';

      # use python3_host_prog as python path to use here
      extraPython3Packages = ps:
        with ps; [
          debugpy
          setuptools
        ];
    };
  };
in {
  aspects.base.persistence.homePaths = [
    ".cache/nvim"
    ".local/state/nvim"
  ];

  home-manager = {
    sharedModules = [nixvim.homeManagerModules.nixvim];
    users.jocelyn = {config, ...}: (base config);
    users.root = {config, ...}: (base config);
  };
}
