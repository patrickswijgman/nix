{ config, pkgs, ... }:

pkgs.vimUtils.buildVimPlugin {
  name = "wizard-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "wizard.nvim";
    rev = "e7a5f0c4d4a498b170b0baac88b266830462d29f";
    hash = "sha256-w1aioXb51CkeBeV+meZSCiBeBucVaECEAliUxFZzk2k=";
  };
}
