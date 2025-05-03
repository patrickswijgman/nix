{ config, pkgs, ... }:

pkgs.vimUtils.buildVimPlugin {
  name = "lsp-extra-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "lsp-extra.nvim";
    rev = "3cba2a16e8bb1551b5d5ea7f21c04d992b398d96";
    hash = "sha256-UbfhN0MBWr74sU6cQjvsifWuAWUszeUm4TGqCyxJsVk=";
  };
}
