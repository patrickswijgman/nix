{ config, pkgs }:

pkgs.rustPlatform.buildRustPackage {
  pname = "codebook";
  version = "v0.2.12";

  src = pkgs.fetchFromGitHub {
    owner = "blopker";
    repo = "codebook";
    rev = "v0.2.12";
    sha256 = "sha256-MGyyN7lq0CpR4F0Ew+ve+KS8OnVFh8sUHQmXTIjh+Ok=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ry0cHP0NUa9vi7dYuJlgg75ktUeZp3dr9KHQIt8OOK0=";

  nativeBuildInputs = with pkgs; [
    perl
  ];

  # The tests try to download a text file.
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
