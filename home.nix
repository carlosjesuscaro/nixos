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
  };

  programs.tmux = {
    enable = true;
  };

  programs.home-manager.enable = true;
}
