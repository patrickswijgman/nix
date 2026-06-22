{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  pulseaudio,
  pamixer,
  inotify-tools,
}:

buildGoModule {
  pname = "swayline";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "swayline";
    rev = "0188b36c926f913dd6a7d512f37bacba751db1cc";
    hash = "sha256-A2Uf57DVJOmBn/R+g8vfHz+f2uYHOO8HzWRp/8h2yBc=";
  };

  vendorHash = null;

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgramBinary $out/bin/swayline \
      --prefix PATH : ${
        lib.makeBinPath [
          pulseaudio
          pamixer
          inotify-tools
        ]
      }
  '';
}
