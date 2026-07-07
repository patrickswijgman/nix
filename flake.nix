{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # Pinned to stable for xdg-desktop-portal-wlr only: unstable's 0.8.3
    # stalls screen sharing (upstream regression), 26.05 still has 0.8.2.
    # Drop once 0.8.4 lands upstream with the fix.
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-26.05";
    };

    swayline = {
      url = "github:patrickswijgman/swayline";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        work = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./modules
            ./hosts/work/configuration.nix
          ];
        };

        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./modules
            ./hosts/desktop/configuration.nix
          ];
        };
      };
    };
}
