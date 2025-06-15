# /etc/nixos/flake.nix - CORRECTED VERSION 3
{
  description = "My NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
  let
   system = "x86_64-linux";
  in
  {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
   	  inherit inputs;
          };
      
      modules = [
        ./configuration.nix
	
	({ config, pkgs, ... }: {
    	  nixpkgs.config.allowUnfree = true;
	})
        home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.carlos = import ./home.nix;
          }
        ]; 
      };
    };
  };
}

