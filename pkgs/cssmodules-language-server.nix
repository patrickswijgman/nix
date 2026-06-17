{
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "cssmodules-language-server";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "antonk52";
    repo = "cssmodules-language-server";
    rev = "v${version}";
    hash = "sha256-9RZNXdmBP4OK7k/0LuuvqxYGG2fESYTCFNCkAWZQapk=";
  };

  npmDepsHash = "sha256-1CnCgut0Knf97+YHVJGUZqnRId/BwHw+jH1YPIrDPCA=";
}
