{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    {
      nixosConfigurations = {
        work = nixpkgs.lib.nixosSystem {
          modules = [ ./hosts/work/configuration.nix ];
        };

        desktop = nixpkgs.lib.nixosSystem {
          modules = [ ./hosts/desktop/configuration.nix ];
        };
      };
    };
}
