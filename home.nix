# /etc/nixos/home.nix
{ config, pkgs, ... }:

{
  home.username = "carlos";
  home.homeDirectory = "/home/carlos";
  home.stateVersion = "25.05";

  # We are only installing a few, safe packages. NordVPN has been removed.
  home.packages = with pkgs; [
    # Utilities
    htop
    btop
    glances
    wget
    vim
    ncdu
    ripgrep
    fd # find replacement
    bat
    curl
    unzip
    zip
    tldr
    fzf
    zoxide
    nix-tree
    nix-du
    wireshark

    # Development
    vscode
    jetbrains-toolbox
    terraform
    kubectl
    awscli
    azure-cli
    google-cloud-sdk

    # Others
    firefox
    brave
    google-chrome
  ];

  programs.git = {
    enable = true;
    userName = "carlos";
    userEmail = "carlos.jesus.caro@gmail.com";
    extraConfig = {
      core = { editor = "vim"; };
      init = { defaultBranch = "master"; };
    };
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "kubectl" "fzf" "zoxide" ];
      theme = "amuse";
   };
 
    shellAliases = {
      nixos = "cd /etc/nixos";
      rb = "sudo nixos-rebuild switch --flake .";
    };

    initExtra = ''
      # Check if we are in an interactive shell and TMUX is not set
      if [[ -z "$TMUX" && -n "$PS1" ]]; then
        # Attach to existing session, or create a new one
        tmux attach-session -t default || tmux new-session -s default
      fi
    '';   
  
  };

  programs.tmux = {
    enable = true;
  };

  programs.home-manager.enable = true;
}
