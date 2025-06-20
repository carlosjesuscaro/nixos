# /etc/nixos/home.nix
# This file manages the user-specific environment for 'carlos'.
# It configures dotfiles, personal packages, and program settings.

{ config, pkgs, ... }:

{
  # --------------------------------------------------------------------
  # 1. Core Home Manager Settings
  # --------------------------------------------------------------------
  home.username = "carlos";
  home.homeDirectory = "/home/carlos";
  home.stateVersion = "25.05"; # Set to the version you want to maintain compatibility with.

  # --------------------------------------------------------------------
  # 2. Packages
  #    Packages installed here are available only to this user.
  #    They have been grouped by category and alphabetized for clarity.
  # --------------------------------------------------------------------
  home.packages = with pkgs; [
    # Development
    awscli
    azure-cli
    google-cloud-sdk
    jetbrains-toolbox
    kubectl
    terraform
    vscode

    # Shell & Utilities
    bat
    btop
    curl
    fd
    fzf
    glances
    htop
    ncdu
    nix-du
    nix-tree
    ripgrep
    tldr
    unzip
    vim
    wget
    wireshark
    zip
    zoxide
    
    # Web Browsers
    brave
    firefox
    google-chrome
  ];

  # --------------------------------------------------------------------
  # 3. Program Configurations
  #    This is where you declaratively manage your dotfiles.
  # --------------------------------------------------------------------

  # --- Git ---
  # Manages your ~/.gitconfig file.
  programs.git = {
    enable = true;
    userName = "carlos";
    userEmail = "carlos.jesus.caro@gmail.com";
    extraConfig = {
      core = { editor = "vim"; };
      init = { defaultBranch = "master"; };
    };
  };

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
    # You could add more tmux configuration here later, for example:
    # extraConfig = ''
    #   set -g mouse on
    # '';
  };

  # --------------------------------------------------------------------
  # 4. Final Home Manager Setting
  # --------------------------------------------------------------------
  # This is required for Home Manager to manage its own configuration file.
  programs.home-manager.enable = true;
}
