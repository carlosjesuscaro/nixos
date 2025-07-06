# /etc/nixos/home.nix
# This file manages the user-specific environment for 'carlos'.
# It configures dotfiles, personal packages, and program settings.

{ config, pkgs, ... }:

let
  # Helper variable to make plugin declarations shorter
  nvimPlugin = pkgs.vimPlugins;
in

{
  # --------------------------------------------------------------------
  # 1. Core Home Manager Settings
  # --------------------------------------------------------------------
  home.username = "carlos";
  home.homeDirectory = "/home/carlos";
  home.stateVersion = "25.05";

  # --------------------------------------------------------------------
  # 2. Packages
  #    Packages installed here are available only to this user.
  # --------------------------------------------------------------------
  home.packages = with pkgs; [
    # Development
    awscli
    azure-cli
    google-cloud-sdk
    jetbrains-toolbox
    kubectl
    python3
    terraform
    vscode

    # Shell & Utilities
    bat
    btop
    curl
    fd
    fzf
    glances
    home-manager
    htop
    ncdu
    nix-du
    nix-tree
    ripgrep
    tldr
    unzip
    vim
    wasistlos
    wget
    wireshark
    xclip
    zip
    zoxide

    # Web Browsers
    brave
    firefox
    google-chrome
  ];

  # --------------------------------------------------------------------
  # 3. Environment & Application Integration
  # --------------------------------------------------------------------

  home.sessionVariables = {
    GDK_SCALE = "1";
  };

  # FIX: To handle 'jetbrains://' login links correctly.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/jetbrains" = [ "jetbrains-toolbox.desktop" ];
    };
  };

  xdg.desktopEntries."jetbrains-toolbox" = {
    name = "JetBrains Toolbox";
    comment = "Manage your JetBrains IDEs";
    exec = "jetbrains-toolbox %u";
    icon = "jetbrains-toolbox";
    type = "Application";
    categories = [ "Development" ]; # Good practice to include
    mimeType = [ "x-scheme-handler/jetbrains" ]; # Declare the mime type
    # NoDisplay = false; # Uncomment if you want to explicitly show/hide in menus
  };


  # --------------------------------------------------------------------
  # 4. Program Configurations
  #    This is where you declaratively manage your dotfiles.
  # --------------------------------------------------------------------

  # --- Git ---
  # Manages your ~/.gitconfig file.
  programs.git = {
    enable = true;
    userName = "carlos";
    userEmail = "carlos.jesus.caro@gmail.com";
    extraConfig = {
      core = { editor = "nvim"; };
      init = { defaultBranch = "master"; };
    };
  };

  # --- VIM (Disabled to avoid conflict with Neovim) ---
  programs.vim = {
    enable = false;
  };

  # === NEOVIM (Nix-Managed ~/.config/nvim) ===
  programs.neovim = {
    enable = true;

    plugins = with nvimPlugin; [
      plenary-nvim
      lualine-nvim
      telescope-nvim
      telescope-fzf-native-nvim
    ];

    extraLuaConfig = ''
      -- Core Neovim Settings (moved from 'settings' option)
      vim.o.number = true
      vim.o.relativenumber = true
      vim.o.expandtab = true
      vim.o.tabstop = 4
      vim.o.shiftwidth = 4
      vim.o.autoindent = true
      vim.o.wrap = false
      vim.o.hlsearch = true
      vim.o.incsearch = true
      vim.o.mouse = "a"
      vim.o.undofile = true
      vim.o.updatetime = 300
      vim.o.timeoutlen = 500
      vim.o.termguicolors = true
      vim.opt.cmdheight = 1
      vim.opt.showmode = false
      vim.opt.clipboard = "unnamedplus"

      -- Set global leader key to spacebar
      vim.g.mapleader = " "

      -- Basic Keymaps:
      vim.keymap.set("n", "<Leader>w", ":w<CR>", { desc = "Save current file" })
      vim.keymap.set("n", "<Leader>q", ":q<CR>", { desc = "Quit Neovim" })

      -- Telescope setup:
      require('telescope').setup{}
      vim.keymap.set("n", "<Leader>f", "<cmd>Telescope find_files<CR>", { desc = "Find files with Telescope" })

      -- Lualine setup:
      require('lualine').setup{}

      -- Configure Neovim to use a blinking vertical bar (pipe) cursor.
      -- 'ver25' for a vertical bar 25% of character width.
      -- 'blinkon100' explicitly requests blinking every 100ms.
      -- This is a more explicit request for the shape and blinking.
      vim.opt.guicursor = "n:ver25-blinkon100,v:ver25-blinkon100,o:ver25-blinkon100,i:ver25-blinkon100,r:ver25-blinkon100,c:ver25-blinkon100,sm:ver25-blinkon100"

      -- Explicitly restore blinking cursor on Neovim exit.
      -- This uses the direct Xterm "blinking I-beam" sequence.
      -- This is crucial for cleanup when Neovim exits.
      vim.api.nvim_create_autocmd("VimLeave", {
        pattern = "*",
        command = "silent !printf '\\\\e[5 q'",
        desc = "Restore blinking I-beam cursor on Neovim exit",
      })
    '';
  };
  # === END NEOVIM ===


  # --- Zsh (Z Shell) ---
  # Manages your ~/.zshrc file
  programs.zsh = {
    enable = true;

    # Configuration for the Oh My Zsh framework.
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "kubectl" "fzf" "zoxide" ];
      theme = "amuse";
    };

    # Custom shell aliases for convenience.
    shellAliases = {
      nixos = "cd /etc/nixos";
      rb = "sudo nixos-rebuild switch --flake .";
      update = "sudo nix flake update";
      xclip = "xclip -sel clipboard";
    };

    # Extra commands to run at the end of .zshrc.
    # This block automatically starts or attaches to a tmux session.
    initContent = ''

      # Check if we are in an interactive shell and TMUX is not set
      if [[ -z "$TMUX" && -n "$PS1" ]]; then
        # Attach to existing session, or create a new one
        tmux attach-session -t default || tmux new-session -s default
      fi
    '';
  };

  # --- Tmux (Terminal Multiplexer) ---
  # Manages your ~/.tmux.conf file.
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g default-terminal "konsole-256color"

      # Restore blinking I-beam cursor on Tmux exit/detach.
      # \e[5 q is the Xterm/VT escape sequence for a blinking I-beam cursor.
      set-hook -g client-detached 'run "printf \\\\e[5 q"'

      # Tell Tmux's internal terminal definition (tmux-256color and screen-256color)
      # how to handle cursor shapes and blinking.
      # 'cnorm' (cursor normal) and 'cvvis' (cursor visible) are set using sequences:
      # \e[5 q for blinking I-beam. This will try to get the pipe shape.
      # civis (cursor invisible) is set to \e[?25l.
      set -ga terminal-overrides ',tmux-256color:cnorm=\\E[5 q:civis=\\E[?25l:cvvis=\\E[5 q'
      set -ga terminal-overrides ',screen-256color:cnorm=\\E[5 q:civis=\\E[?25l:cvvis=\\E[5 q'
    '';
  };

  # --------------------------------------------------------------------
  # 5. Final Home Manager Setting
  # --------------------------------------------------------------------
  # This is required for Home Manager to manage its own configuration file.
  programs.home-manager.enable = true;

}
