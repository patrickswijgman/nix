{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "butter.nvim";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "butter.nvim";
    rev = "8c727bc51d4a7b3e13159579a1e57f9ae602688b";
    hash = "sha256-u0J6eRAkYQgiCbHQDuDMR7Qb5dg2/sBATctxuveiQJc=";
  };
}
