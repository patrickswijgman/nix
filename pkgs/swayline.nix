{
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "swayline";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "swayline";
    rev = "d8d652adac6e05754babcc5eed996b8f13a11c46";
    hash = "sha256-uyieZpsZngHY3zm7XLxh5mLV3olNIU3ycZ/41PyBPfg=";
  };

  vendorHash = null;
}
