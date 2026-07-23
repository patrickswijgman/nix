{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "butter.nvim";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "butter.nvim";
    rev = "3fcc943173a0497aff89bbd3b3e2698ef0f724fa";
    hash = "sha256-OTQUpfLD8QAcpEbKFO/GXpcCzNLoByz7jobcrTM+X4E=";
  };
}
