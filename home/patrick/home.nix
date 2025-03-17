{ config, pkgs, ... }:

let
  codebook = pkgs.callPackage ../../modules/codebook.nix { };
in
{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "patrick";
  home.homeDirectory = "/home/patrick";

  # Browsers.
  programs.firefox.enable = true;
  programs.chromium.enable = true;

  # Terminal.
  programs.ghostty.enable = true;

  # Editor.
  programs.helix.enable = true;

  # Packages (that don't have a 'programs.<package>' option).
  home.packages = with pkgs; [
    # Shell
    oh-my-posh

    # Dot file management
    chezmoi

    # Take breaks...
    stretchly

    # CLI
    fzf
    fd
    ripgrep
    tree
    openvpn
    bat
    lazygit

    # Presentations
    slides
    graph-easy
    cowsay

    # Programming
    nixd
    nixfmt-rfc-style

    fish-lsp

    nodejs_22
    typescript
    vtsls
    vscode-langservers-extracted
    tailwindcss-language-server
    prettierd

    go
    gopls
    golangci-lint
    golangci-lint-langserver

    rustc
    cargo
    rustfmt
    rust-analyzer

    python3
    pyright
    ruff

    simple-completion-language-server
    vale
    vale-ls
    codebook

    taplo
    yaml-language-server

    # Desktop apps
    gnome-tweaks
    spotify
    slack
    aseprite
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
