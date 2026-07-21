{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "birb.nvim";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "birb.nvim";
    rev = "f32320ee2910a15b4c47f70417eacfd5027a4a9f";
    hash = "sha256-+KARpDTBJpJfqrM0EbD5kg6PhfpCSa39+5UxH0ZTXS4=";
  };
}
