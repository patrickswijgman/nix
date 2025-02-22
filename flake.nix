{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    {
      nixosConfigurations = {
        acer = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/acer/configuration.nix
          ];
        };
      };
    };
}
