{ config, pkgs }:

pkgs.rustPlatform.buildRustPackage {
  pname = "codebook";
  version = "v0.2.9";

  src = pkgs.fetchFromGitHub {
    owner = "blopker";
    repo = "codebook";
    rev = "v0.2.9";
    sha256 = "sha256-iJ9S9DDoZVZxZ1o9dkor8PGM6Z+FljWZfetWFFMOIIo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-PmhfEftgto0FHOIfryN9JME9S+/CarAEZ6hV/vj37Eg=";

  nativeBuildInputs = with pkgs; [
    perl
  ];

  # The tests try to download a text file, but that obviously fails in the build phase.
  doCheck = false;

  versionCheckProgram = "${placeholder "out"}/bin/codebook-lsp";
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  meta = with pkgs.lib; {
    description = "An unholy spellchecker for code.";
    homepage = "https://github.com/blopker/codebook";
    platforms = platforms.all;
  };
}
