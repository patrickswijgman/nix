{
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "swayopacity";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "plotkaraphael29-arch";
    repo = "swayopacity";
    rev = "8f3d91a27c30ea5c900eab8646b55436839e7442";
    hash = "sha256-PwMiju1SS/qG5ZBI8qNVmm8/1ursO7SHT68jzTcBdfo=";
  };

  cargoHash = "sha256-AmbIrOWMzVngGI9bh9GG45KQcSE8Ci6g4qm5m6jC0oI=";
}
