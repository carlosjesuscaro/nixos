# /etc/nixos/flake.nix
# This file defines the dependencies (inputs) and build instructions (outputs)
# for the entire NixOS system. It is the entry point for the configuration.

{
  description = "Carlos's NixOS Configuration";

  # --------------------------------------------------------------------
  # 1. INPUTS
  #    This section lists all the external dependencies (Git repositories)
  #    that your system needs to build itself.
  # --------------------------------------------------------------------
  inputs = {

    # The primary source for Nix packages and NixOS modules.
    # 'nixos-unstable' provides the latest packages.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # The module for managing your user-level dotfiles and packages.
    home-manager = {
      url = "github:nix-community/home-manager";
      # This crucial line ensures home-manager uses the same version
      # of nixpkgs as your system, preventing conflicts.
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  # --------------------------------------------------------------------
  # 2. OUTPUTS
  #    This section defines what this flake can build using the inputs
  #    defined above.
  # --------------------------------------------------------------------
  # This function takes the inputs and produces the buildable outputs.
  outputs = { self, nixpkgs, home-manager, ... }@inputs: {

    # We are defining a NixOS system configuration.
    nixosConfigurations = {

      # 'nixos' is the hostname of the machine we are building.
      # It should match the `networking.hostName` in configuration.nix.
      nixos = nixpkgs.lib.nixosSystem {
        
        system = "x86_64-linux"; # The architecture of your machine.
        
        # This makes the 'inputs' (like nixpkgs, home-manager) available
        # to your other configuration files (e.g., configuration.nix).
        specialArgs = { inherit inputs; };
        
        # This is the "recipe" for your system, listing all the configuration
        # files and modules to assemble.
        modules = [
          # Your primary system configuration file.
          ./configuration.nix

          # The NixOS module for Home Manager, enabling its functionality.
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
