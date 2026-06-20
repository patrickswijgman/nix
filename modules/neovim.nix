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
    environment.systemPackages = with pkgs; [
      neovim
      ripgrep # needed for plugins
      fd # needed for plugins
      fzf # needed for plugins
      curl
      git
      wl-clipboard
    ];

    environment.sessionVariables = {
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";
      TREESITTER_PATH = "${treesitter}";
    };
  };
}
