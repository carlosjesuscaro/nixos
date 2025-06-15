# /etc/nixos/configuration.nix
{ config, pkgs, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # --- Graphics and Desktop Environment for KDE Plasma ---
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  services.xserver.videoDrivers = [ "nvidia" "intel" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.blacklistedKernelModules = [ "nouveau" ];

  hardware.graphics = {
    enable = true;
  };

  # Enabling Zsh
  programs.zsh.enable = true;  

  # --- System Services ---
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  virtualisation.docker.enable = true;

  # --- User Configuration ---
  users.users.carlos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
  };

#  home-manager.users.carlos = import ./home.nix;

  system.stateVersion = "25.05";
}
