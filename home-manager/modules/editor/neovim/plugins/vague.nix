{ config, pkgs, ... }:

pkgs.vimUtils.buildVimPlugin {
  name = "vague-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "vague2k";
    repo = "vague.nvim";
    rev = "41b6b9a985c9091d0ec8571191e89d6950968cec";
    hash = "sha256-isROQFePz8ofJg0qa3Avbwh4Ml4p9Ii2d+VAAkbeGO8=";
  };
}
