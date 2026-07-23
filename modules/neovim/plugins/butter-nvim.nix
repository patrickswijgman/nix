{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "butter.nvim";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "butter.nvim";
    rev = "4eba33d29f5032394a0db8dcb12f7a8647afd38e";
    hash = "sha256-4W+BGhWAzeObBh2tRPTaZX8M7AfhMrs/zAJv91URfk4=";
  };
}
