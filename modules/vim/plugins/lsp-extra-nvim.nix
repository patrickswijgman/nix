{ config, pkgs, ... }:

pkgs.vimUtils.buildVimPlugin {
  name = "lsp-extra-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "lsp-extra.nvim";
    rev = "6582214046e57d825ca5cf2881690a6cd1a57429";
    hash = "sha256-MkeQUhdxMn8b8EEZhqszqrmVRp6INyQZH+Ac8rejNzQ=";
  };
}
