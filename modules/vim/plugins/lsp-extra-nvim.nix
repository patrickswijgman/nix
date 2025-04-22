{ config, pkgs, ... }:

pkgs.vimUtils.buildVimPlugin {
  name = "lsp-extra-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "lsp-extra.nvim";
    rev = "0e10ab13d1946b9077a40523d2ab60d6efbbb82a";
    hash = "sha256-WxwhzDYqBLpCyhXDBy6AWmW3BUfh4TUXpoW4ps8a8o4=";
  };
}
