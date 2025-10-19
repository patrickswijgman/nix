{ config, pkgs, ... }:

pkgs.vimUtils.buildVimPlugin {
  name = "wizard-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "wizard.nvim";
    rev = "ad2356be0fdfc78ff567fa9c206212e23a65c14c";
    hash = "sha256-D4FkBES+CkZkGRvCMs9X/Eo8eeXspRW0yug56TlvFGU=";
  };
}
