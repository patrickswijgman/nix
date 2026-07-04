{
  pkgs,
  ...
}:

let
  treesitter = pkgs.callPackage ../pkgs/treesitter.nix { };
  cssmodules-language-server = pkgs.callPackage ../pkgs/cssmodules-language-server.nix { };
in
{
  # Allow unfree packages (e.g. Spotify).
  nixpkgs.config.allowUnfree = true;

  # Enable flakes.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable networking.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalization properties.
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

  # Install firefox.
  programs.firefox.enable = true;

  # Use fish as the default shell.
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Needed for Zed to download and start language servers.
  # Needed for pre-commit to execute downloaded git hooks.
  # Needed for binaries installed in node_modules with npm, e.g. Biome.
  programs.nix-ld.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # GUI
    chromium
    spotify
    gimp

    # TUI
    neovim
    btop
    claude-code

    # CLI
    git
    curl
    fd
    fzf
    ripgrep
    tree
    bat
    keychain
    wl-clipboard
    jq # needed for claude statusline
    gcc # needed for pre-commit hooks

    ### Dev

    # Web
    nodejs_24
    vtsls
    typescript-language-server # needed for claude LSP
    vscode-css-languageserver
    cssmodules-language-server
    emmet-language-server

    # Go
    go_1_25
    gopls
    golangci-lint
    golangci-lint-langserver

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

    # Fish
    fish-lsp

    # Misc
    codebook
    docker-language-server
    efm-langserver
    jinja-lsp
    prettierd
    taplo
    vscode-json-languageserver
    yaml-language-server
  ];

  # Set system level environment variables. Requires a restart to take effect.
  environment.sessionVariables = {
    # Default editor.
    EDITOR = "nvim";

    # Treesitter path for Neovim.
    TREESITTER_PATH = "${treesitter}";

    # Disable builtin virtual env in prompt.
    VIRTUAL_ENV_DISABLE_PROMPT = "1";

    # Location to default FZF options file.
    FZF_DEFAULT_OPTS_FILE = "/home/patrick/.config/fzf/config";

    # Set default theme for Bat (does not have a config file).
    BAT_THEME = "vague";
  };
}
