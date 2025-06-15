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
  };

  programs.zsh = {
    enable = true;
#   ohMyZsh = {
#     enable = true;
#      plugins = [ "git" "sudo" "docker" "kubectl" ];
#   };
#    shellInit = ''
      # Check if not already in a Tmux session ($TMUX is empty)
      # and if the shell is interactive ($PS1 is not empty).
#      if [ -z "$TMUX" ] && [ -n "$PS1" ]; then
          # Attempt to attach to an existing session named 'default'.
          # If no such session exists, create a new one named 'default'.
#          tmux attach-session -t default || tmux new-session -s default
#      fi
#    '';
  };

  programs.tmux = {
    enable = true;
  };

  programs.home-manager.enable = true;
}
