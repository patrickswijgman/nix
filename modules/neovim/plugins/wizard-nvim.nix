{ config, pkgs, ... }:

pkgs.vimUtils.buildVimPlugin {
  name = "wizard-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "wizard.nvim";
    rev = "35dbebd917ee77e9eafcf746c42ad7b9419ce4a8";
    hash = "sha256-hE1zk6KIBh7uZJfg+MxEvEJo/lZN2GjD9PmbqZ8vrNE=";
  };
}
