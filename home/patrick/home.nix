{
  config,
  pkgs,
  inputs,
  ...
}:

let
  codebook = pkgs.callPackage ../../modules/codebook.nix { };
in
{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "patrick";
  home.homeDirectory = "/home/patrick";

  # Packages (that don't have a 'programs.<package>' option).
  home.packages = with pkgs; [
    # Browsers
    (inputs.zen-browser.packages."${system}".default)
    chromium

    # Terminal
    ghostty

    # Shell
    oh-my-posh

    # Editor
    helix

    # CLI
    chezmoi
    fzf
    ripgrep
    fd
    tree
    openvpn
    bat
    lazygit
    lazydocker
    dive
    httpie
    btop
    pomodoro
    presenterm
    npm-check-updates
    appimage-run

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
    yaml-language-server
    taplo

    codebook

    # Desktop apps
    gnome-tweaks
    aseprite
    discord
    shortwave
  ];

  systemd.user.services.pomodoro-timer = {
    Unit = {
      Description = "Pomodoro Timer";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.pomodoro}/bin/pomodoro 55 5";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

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
