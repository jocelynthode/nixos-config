{pkgs, ...}: {
  imports = [
    ./core
    ./plugins
    ./themes
  ];

  config = {
    aspects.base.persistence.homePaths = [
      ".cache/nvim"
      ".local/state/nvim"
    ];

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

      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = true;
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
        rainbow-delimiters.enable = true;
        lastplace.enable = true;
      };
      extraPlugins = with pkgs.vimPlugins; [
        telescope-dap-nvim
        taxi-vim
        nvim-dap-repl-highlights
      ];

      extraConfigLua = ''
        vim.opt.whichwrap:append("<>[]hl")
        vim.opt.iskeyword:append("-")
      '';

      # use python3_host_prog as python path to use here
      extraPython3Packages = ps:
        with ps; [
          debugpy
          setuptools
        ];
    };
  };
}
