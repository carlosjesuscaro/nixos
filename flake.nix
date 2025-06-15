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

   pkgs = import nixpkgs {
     inherit system;
     config = {
       allowUnfree = true;
     };
   };
  in
  {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
   	  inherit inputs pkgs;
          };
      modules = [
        ./configuration.nix
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

