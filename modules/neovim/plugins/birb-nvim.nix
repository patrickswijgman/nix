{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "birb.nvim";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "patrickswijgman";
    repo = "birb.nvim";
    rev = "104c68fcd1cd3087a18992e84984b54af7c5759a";
    hash = "sha256-bW/G6OQAlXGkzoWVwtq+DtnY8B5qCh8tw6Bo3hKjjVI=";
  };
}
