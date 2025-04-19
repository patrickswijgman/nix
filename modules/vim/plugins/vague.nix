{ config, pkgs, ... }:

pkgs.vimUtils.buildVimPlugin {
  name = "vague";
  src = pkgs.fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "vague.nvim";
    rev = "f029318b771cdf746f6b470413c786ca6efd06cb";
    hash = "sha256-d/raxCfHRcypTdfEHVqIEmQ2nVk5HdIvmiutxgaGxrU=";
  };
}
