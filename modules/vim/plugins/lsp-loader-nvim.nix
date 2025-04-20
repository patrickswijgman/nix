{ config, pkgs, ... }:

pkgs.vimUtils.buildVimPlugin {
  name = "lsp-loader-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "lsp-loader.nvim";
    rev = "fe9349911e747bfa68b5a5a2c39d149d0dbf9ad9";
    hash = "sha256-d4tiCMlhqaqnTrIisCEMjPYCQzNrkrAHFaDX9tKUnf0=";
  };
}
