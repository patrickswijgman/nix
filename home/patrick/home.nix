{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "patrick";
  home.homeDirectory = "/home/patrick";

  # Terminal.
  programs.ghostty.enable = true;

  # Editor.
  programs.neovim = {
    enable = true;
    # Find plugins here https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimplugins+
    plugins = with pkgs.vimPlugins; [
      blink-cmp
      conform-nvim
      lualine-nvim
      nvim-spectre
      nvim-spider
      nvim-surround
      nvim-treesitter.withAllGrammars
      oil-nvim
      telescope-nvim

      # Dependencies
      nvim-web-devicons
      plenary-nvim

      # Plugins that are unavailable in nixpkgs
      (pkgs.vimUtils.buildVimPlugin {
        name = "vague";
        src = pkgs.fetchFromGitHub {
          owner = "vague2k";
          repo = "vague.nvim";
          rev = "982453f671332ce0240a15be5eb223d32f877e06";
          hash = "sha256-QNHNMPPnGrITbzLCQQ8VfwSnJ/cKvc18mq8Kei/sA60=";
        };
      })
    ];
  };

  # Packages (that don't have a 'programs.<package>' option).
  home.packages = with pkgs; [
    # Browser
    (inputs.zen-browser.packages."${system}".default)

    # CLI
    chezmoi
    fzf
    ripgrep
    fd
    tree
    openvpn
    bat
    httpie
    btop
    pomodoro
    presenterm
    npm-check-updates
    dive

    # Programming
    nixd
    nixfmt-rfc-style

    lua
    lua-language-server
    stylua

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

    yaml-language-server
    taplo

    # Desktop apps
    gnome-tweaks
    aseprite
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
