{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "butter.nvim";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "butter.nvim";
    rev = "16f9a5ab4f152b073c4f4e83d28764252d26b3ab";
    hash = "sha256-PHov4FWPcSwvs3+sr1Ho3ztFcZIZlMYPTzs7z/gjiIM=";
  };
}
