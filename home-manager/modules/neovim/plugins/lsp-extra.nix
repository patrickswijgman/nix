{ config, pkgs, ... }:

pkgs.vimUtils.buildVimPlugin {
  name = "lsp-extra-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "lsp-extra.nvim";
    rev = "224b6feb1e79ff3af705b4b538fd267e4a1e1a6e";
    hash = "sha256-fmSvyLDhzb026mrYJvcB8LRedgy1gHuJPrdb+7CMqao=";
  };
}
