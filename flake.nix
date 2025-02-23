{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, ... }:
    {
      nixosConfigurations = {
        acer = nixpkgs.lib.nixosSystem {
          modules = [
            home-manager.nixosModules.default
            ./configuration.nix
            ./hosts/acer/configuration.nix
          ];
        };
      };
    };
}
