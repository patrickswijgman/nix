{ config, pkgs }:

pkgs.rustPlatform.buildRustPackage {
  pname = "codebook";
  version = "unstable";

  src = pkgs.fetchFromGitHub {
    owner = "blopker";
    repo = "codebook";
    rev = "v0.2.4";
    sha256 = "sha256-w8bzg/aqWAJTbeR8m+w28A24n5MUsoQXGYmlovK9CeA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qEHj3wrrl3oisRR8nsLRRfQStLdSoWp8tEKkwnb293U=";

  nativeBuildInputs = with pkgs; [
    perl
  ];

  doCheck = false;

  meta = with pkgs.lib; {
    description = "An unholy spellchecker for code.";
    homepage = "https://github.com/blopker/codebook";
    platforms = platforms.all;
  };
}
