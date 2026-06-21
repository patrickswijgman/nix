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
    rev = "e2173152029ce17188ed8f77b98156ce09653876";
    hash = "sha256-oFIKoA7K68MCPzWDp4wDWruWGu55cP2/fa0FEycp3HU=";
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
