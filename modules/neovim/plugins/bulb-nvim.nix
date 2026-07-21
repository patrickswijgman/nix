{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "bulb.nvim";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "bulb.nvim";
    rev = "82572144d21c185dc554ce77b8304947af25a9e2";
    hash = "sha256-NUNWO/DKZRuv0M5bGRYSo8EAkjws6S/K8Mv9xOkkRfo=";
  };
}
