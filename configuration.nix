# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Load flakes and custom modules.
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.walker.nixosModules.default
  ];

  # Enable flakes.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Enable networking.
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalization properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Configure keyboard layout.
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable multimedia via PipeWire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };

  # Enable home manager.
  # See options here https://home-manager-options.extranix.com/?query=&release=release-24.11
  home-manager = {
    # Use global nixpkgs config to allow unfree packages.
    useGlobalPkgs = true;

    users.patrick = {
      # Load Home Manager modules.
      imports = [
        inputs.zen-browser.homeModules.beta
      ];

      # Home Manager needs a bit of information about you and the paths it should manage.
      home.username = "patrick";
      home.homeDirectory = "/home/patrick";

      # Browsers.
      programs.zen-browser.enable = true;
      programs.chromium.enable = true;

      # Editor.
      programs.neovim = {
        enable = true;
        plugins =
          with pkgs.vimPlugins;
          let
            wizard-nvim = pkgs.callPackage ./modules/neovim/plugins/wizard-nvim.nix { };
          in
          [
            actions-preview-nvim
            blink-cmp
            catppuccin-nvim
            conform-nvim
            copilot-lua
            leap-nvim
            lualine-nvim
            nvim-autopairs
            nvim-lspconfig
            nvim-spectre
            nvim-spider
            nvim-surround
            nvim-tree-lua
            nvim-treesitter.withAllGrammars
            nvim-various-textobjs
            nvim-web-devicons
            telescope-nvim
            vim-helm # syntax highlighting for go templates (chezmoi)
            wizard-nvim
            zen-mode-nvim
          ];
      };

      # Terminal.
      programs.alacritty.enable = true;

      # Packages (that don't have a 'programs.<package>' option).
      home.packages = with pkgs; [
        # Fonts
        nerd-fonts.hack
        font-awesome
        noto-fonts-color-emoji

        # CLI
        chezmoi
        fzf
        ripgrep
        fd
        tree
        openvpn
        bat
        dive # Docker image inspection
        httpie # REST API tool
        presenterm
        npm-check-updates
        jq # pretty format JSON string
        htop
        copier # project templating tool
        libnotify # desktop notifications

        # Shell
        oh-my-posh

        # Terminal apps
        lazygit
        lazydocker

        # Programming
        nixd
        nixfmt-rfc-style

        lua-language-server
        stylua

        nodejs_22
        vtsls
        prettierd
        tailwindcss-language-server

        go
        gopls

        rustc
        cargo
        rust-analyzer
        rustfmt

        python3
        pyright
        ruff
        uv

        flutter332

        taplo
        yaml-language-server
        vscode-langservers-extracted

        fish-lsp

        codebook
        simple-completion-language-server

        # AI
        claude-code

        # Desktop apps
        spotify
        slack
        gimp
      ];

      # Discover fonts installed through home.packages.
      fonts.fontconfig.enable = true;

      # Cursor theme.
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.phinger-cursors;
        name = "phinger-cursors-dark";
        size = 16;
      };

      # Theme.
      gtk = {
        enable = true;
        # theme = {
        #   package = pkgs.yaru-theme;
        #   name = "Yaru-blue";
        # };
        iconTheme = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
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
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.patrick = {
    isNormalUser = true;
    description = "Patrick";
    useDefaultShell = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "realtime"
      "docker"
    ];
  };

  # Shell.
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Desktop environment.
  programs.hyprland.enable = true;
  programs.walker.enable = true;

  # Enable XDG portal for sandboxed applications.
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      # Add GTK portal as Hyprland portal does not implement a file picker.
      xdg-desktop-portal-gtk
    ];
  };

  # Enable dynamic linker to execute dynamic binaries.
  # Needed for Zed to download execute language servers.
  # Needed for pre-commit to execute downloaded git hooks.
  programs.nix-ld.enable = true;

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    # Core
    usbutils
    vim
    curl
    git
    gcc

    # Desktop environment
    ashell # bar
    hypridle
    hyprlock
    hyprshot # screenshot tool
    swayosd # on-screen display for brightness/volume changes
    swaybg
    mako
    kanshi
    gammastep # blue light filter
    bato # battery notifier
    wl-clipboard
    brightnessctl
    playerctl
    blueman # bluetooth manager and notifier
    wayland-pipewire-idle-inhibit # prevent idle on audio/video playback
  ];

  # System-wide environment variables.
  environment.sessionVariables = {
    # Set defaults.
    EDITOR = "nvim";
    GIT_EDITOR = "nvim";
    TERMINAL = "alacritty";

    # Don't show "(.venv)" in shell prompt.
    VIRTUAL_ENV_DISABLE_PROMPT = "1";

    # Run Electron apps in Wayland.
    NIXOS_OZONE_WL = "1";

    # Playwright.
    # PLAYWRIGHT_BROWSERS_PATH = pkgs.playwright-driver.browsers;
    # PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    # PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
