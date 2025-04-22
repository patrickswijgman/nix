{ config, pkgs, ... }:

pkgs.vimUtils.buildVimPlugin {
  name = "lsp-extra-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "lsp-extra.nvim";
    rev = "678e9277084df4868f7db34d27bf600433883e77";
    hash = "sha256-9qycEQRz1Ob8Wlv3U4e4WtiBbi13zStj+pItr+BjE5k=";
  };
}
