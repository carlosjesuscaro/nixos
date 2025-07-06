# /etc/nixos/configuration.nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # 1. Core Nix & System Settings
  # --------------------------------------------------------------------
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05"; # This should match the version you installed with.

  # 2. Bootloader
  # --------------------------------------------------------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 3. Localization and Time
  # --------------------------------------------------------------------
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  # 4. Networking
  # --------------------------------------------------------------------
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # 5. Graphics & Desktop Environment
  # --------------------------------------------------------------------
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" "intel" ];
  };
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false; # Common for desktops
    open = false; # Use the proprietary driver
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  boot.blacklistedKernelModules = [ "nouveau" ];

  # 6. System Services
  # --------------------------------------------------------------------
  hardware.bluetooth.enable = true;
  # services.blueman.enable = true;
  # Enable pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;
  virtualisation.docker.enable = true;

  # 7. System-Wide Programs
  # --------------------------------------------------------------------
  programs.zsh.enable = true;

  # 8. Users and Home Manager
  # --------------------------------------------------------------------
  users.users.carlos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Cleaned up list
    shell = pkgs.zsh;
  };

  # This configuration was moved from flake.nix for better organization.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-bak";
    users.carlos = import ./home.nix;
  };
}
