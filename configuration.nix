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
    ./modules/gnome
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
    jack.enable = true;
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
        ./modules/home-manager/neovim
      ];

      # Home Manager needs a bit of information about you and the paths it should manage.
      home.username = "patrick";
      home.homeDirectory = "/home/patrick";

      # Browsers.
      programs.zen-browser.enable = true;
      programs.chromium.enable = true;

      # Editor.
      programs.zed-editor.enable = true;

      # Terminal.
      programs.ghostty.enable = true;

      # Packages (that don't have a 'programs.<package>' option).
      home.packages = with pkgs; [
        # Fonts
        nerd-fonts.hack # Used as a fallback for the nerd font icons.

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

        # Shell
        oh-my-posh
        babelfish

        # Terminal apps
        lazygit
        lazydocker

        # Programming
        nixd
        nixfmt-rfc-style
        nodejs_22
        go
        python3
        uv
        flutter332

        # AI
        claude-code

        # Music
        guitarix
        tonelib-metal
        tonelib-gfx
        helvum
        qjackctl

        # Desktop apps
        gnome-tweaks
        aseprite
        gimp
      ];

      # Environment variables.
      # These need to be loaded in the shell, e.g. fish.
      home.sessionVariables = {
        # Set defaults.
        EDITOR = "vim";
        GIT_EDITOR = "vim";

        # Don't show "(.venv)" in shell prompt.
        VIRTUAL_ENV_DISABLE_PROMPT = "1";

        # Playwright.
        # PLAYWRIGHT_BROWSERS_PATH = pkgs.playwright-driver.browsers;
        # PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
        # PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
      };

      # Enable fontconfig to make fonts installed by Home Manager available to applications.
      fonts.fontconfig.enable = true;

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
  gnome = {
    enable = true;
    defaultTerminal = "com.mitchellh.ghostty.desktop";
  };

  # Remember SSH passphrase.
  programs.ssh.startAgent = true;

  # Enable dynamic linker to execute dynamic binaries.
  # Needed for Zed to download execute language servers.
  # Needed for pre-commit to execute downloaded git hooks.
  programs.nix-ld.enable = true;

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    usbutils
    vim
    curl
    git
    gcc
  ];

  # System-wide environment variables.
  environment.sessionVariables = { };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
