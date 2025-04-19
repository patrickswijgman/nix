{ config, pkgs, ... }:

pkgs.vimUtils.buildVimPlugin {
  name = "vague";
  src = pkgs.fetchFromGitHub {
    owner = "vague2k";
    repo = "vague.nvim";
    rev = "1.3.1";
    hash = "sha256-dDtYkRNK4BtWbYtoVDjsvDBmWCVhJ/+qoDt+mJmEKIQ=";
  };
}
