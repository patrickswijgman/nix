{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "butter.nvim";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "butter.nvim";
    rev = "81239b508b4e853610e36b00db2acaa5afbbed3e";
    hash = "sha256-0QawdYBJqjx5f5eeQqtpaXaXRm84IWeHBVOif8YSCqc=";
  };
}
