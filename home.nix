# /etc/nixos/home.nix - FINAL SIMPLIFIED VERSION
{ config, pkgs, ... }:

{
  home.username = "carlos";
  home.homeDirectory = "/home/carlos";
  home.stateVersion = "25.05";

  # We are only installing a few, safe packages. NordVPN has been removed.
  home.packages = with pkgs; [
    # Utilities
    htop
    wget
    vim
    nvtop
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

    # Development
    jetbrains-toolbox
    terraform
    kubectl
    awscli
    azure-cli
    gcp-cli
    google-cloud-sdk
  ];

  programs.git = {
    enable = true;
    userName = "carlos";
    userEmail = "carlos.jesus.caro@gmail.com";
  };

  programs.zsh = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
  };

  programs.home-manager.enable = true;
}
