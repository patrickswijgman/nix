{
  pkgs,
  ...
}:

let
  treesitter = pkgs.callPackage ../pkgs/treesitter.nix { };
  cssmodules-language-server = pkgs.callPackage ../pkgs/cssmodules-language-server.nix { };
in
{

  ### Nix options

  # Allow unfree packages (e.g. Spotify).
  nixpkgs.config.allowUnfree = true;

  # Enable nix flakes.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  ### Network

  networking.networkmanager.enable = true;

  ### Locales

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  ### Users

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.patrick = {
    isNormalUser = true;
    description = "Patrick";
    useDefaultShell = true;
    extraGroups = [
      "networkmanager"
      "video"
      "wheel"
    ];
  };

  ### Programs and services

  # Browser
  programs.firefox.enable = true;

  # Shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    runtime = {
      "parser".source = "${treesitter}/parser";
      "queries".source = "${treesitter}/queries";
    };
  };

  # Needed for Zed to download and start language servers.
  # Needed for pre-commit to execute downloaded git hooks.
  # Needed for binaries installed in node_modules with npm, e.g. Biome.
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    # GUI
    chromium
    spotify
    gimp

    # TUI
    btop
    claude-code

    # CLI
    git
    curl
    fd
    fzf
    ripgrep
    tree
    keychain
    wl-clipboard
    jq # needed for claude statusline
    gcc # needed for pre-commit hooks

    ### Dev

    # Web
    nodejs_24
    vtsls
    typescript-language-server # needed for claude code LSP
    vscode-css-languageserver
    cssmodules-language-server
    emmet-language-server

    # Go
    go_1_25
    gopls
    golangci-lint
    golangci-lint-langserver

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

    # Fish
    fish-lsp

    # Other
    codebook
    docker-language-server
    jinja-lsp
    prettierd
    taplo
    vscode-json-languageserver
    yaml-language-server
  ];

  ### Environment

  environment.sessionVariables = {
    # Disable builtin virtual env segment in Fish prompt.
    VIRTUAL_ENV_DISABLE_PROMPT = "1";
  };
}
