{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.neovim;
  treesitter = pkgs.callPackage ../pkgs/treesitter.nix { };
in
{
  options.modules.neovim = {
    enable = lib.mkEnableOption "Neovim editor with Treesitter parsers and queries";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.neovim
    ];

    environment.sessionVariables = {
      # Points to the derivation containing the Treesitter parser (*.so) files and query (*.scm) files.
      TREESITTER_PATH = "${treesitter}";
    };
  };
}
