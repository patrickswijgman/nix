{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    {
      nixosConfigurations = {
        work = nixpkgs.lib.nixosSystem {
          modules = [ ./configuration.nix ];
        };
      };
    };
}
