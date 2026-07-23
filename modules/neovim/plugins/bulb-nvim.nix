{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "bulb.nvim";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "bulb.nvim";
    rev = "ecc7d236c4d922f784eaf9b6f1d8e6f64154d802";
    hash = "sha256-VuBDV3i6rVoE47/WUbbSoiu/JKjbTzlBoMPPLqOuNWc=";
  };
}
