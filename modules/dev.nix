{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.dev;
  cssmodules-language-server = pkgs.callPackage ../pkgs/cssmodules-language-server.nix { };
in
{
  options.modules.dev = {
    enable = lib.mkEnableOption "Developer programs and language servers";
  };

  config = lib.mkIf cfg.enable {
    # Run unpatched dynamic binaries.
    # Needed for Zed to download execute language servers.
    # Needed for pre-commit to execute downloaded git hooks.
    # Needed for binaries installed in node_modules with NPM, e.g. Biome.
    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      # Browser
      chromium

      # General
      efm-langserver
      codebook
      prettierd

      # Web dev
      nodejs_24
      vtsls
      vscode-css-languageserver
      cssmodules-language-server
      emmet-language-server

      # Go
      go_1_25
      golangci-lint
      golangci-lint-langserver
      gopls

      # Rust
      rustc
      rust-analyzer
      rustfmt
      cargo
      clippy

      # Python
      python314
      python314Packages.python-lsp-server
      ruff
      uv

      # Lua
      lua
      lua-language-server
      stylua

      # Nix
      nixd
      nixfmt

      # YAML
      yaml-language-server
      docker-language-server

      # TOML
      taplo

      # JSON
      vscode-json-languageserver

      # Fish
      fish-lsp

      # Jinja
      jinja-lsp

      # Tools
      claude-code
      gcc # needed for pre-commit hooks
    ];
  };
}
