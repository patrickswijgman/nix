{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "butter.nvim";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "butter.nvim";
    rev = "00d198bc2615f08c35880d556d000f43c1217728";
    hash = "sha256-x4dhELQHWhN5U1qyUjgdMp21oiQc6RKE5D7KDlHv6yA=";
  };
}
