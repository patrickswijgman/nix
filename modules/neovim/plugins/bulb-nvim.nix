{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "bulb.nvim";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "bulb.nvim";
    rev = "8725cec17cce7f15ab3e2e51629b8a382fcbec3a";
    hash = "sha256-jKaaeChAqVcnQ5rlQm24BAQI8uTEXyi4ZdCzv+OWmQg=";
  };
}
