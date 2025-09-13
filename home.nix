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
    gcc
    python3
    terraform
    vscode

    # Shell & Utilities
    bat
    btop
    curl
    gnumake
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
#    wasistlos
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
    categories = [ "Development" ];
    mimeType = [ "x-scheme-handler/jetbrains" ];
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
  #    nvim-treesitter.withAllGrammars
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

      -- Treesitter setup:
      -- require('nvim-treesitter.configs').setup {
      -- ensure_installed = "all", 
      -- highlight = { enable = true }, 
      -- parser_install_dir = vim.fn.stdpath('cache') .. '/nvim/treesitter-parsers',
      -- }
    '';
  };
  # === END NEOVIM ===

  # --- Zsh (Z Shell) ---
  # Manages your ~/.zshrc file.
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
  };

  # --------------------------------------------------------------------
  # 5. Final Home Manager Setting
  # --------------------------------------------------------------------
  # This is required for Home Manager to manage its own configuration file.
  programs.home-manager.enable = true;

}
