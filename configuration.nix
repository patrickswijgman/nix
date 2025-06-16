# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

let
  playwright-test = inputs.playwright.packages.${pkgs.system}.playwright-test;
  playwright-driver = inputs.playwright.packages.${pkgs.system}.playwright-driver;
in
{
  # Load modules from flakes.
  imports = [
    inputs.home-manager.nixosModules.default
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Remove unused GNOME default software.
  environment.gnome.excludePackages = with pkgs; [
    decibels # Audio Player
    epiphany # Web Browser
    evince # Document Viewer
    file-roller
    geary # Mail
    gnome-calendar
    gnome-characters
    # gnome-clocks
    gnome-connections
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-tour
    gnome-weather
    simple-scan # Document Scanner
    snapshot # Camera
    totem # Videos
    yelp # Help
  ];

  # Enable screen sharing in Wayland.
  xdg = {
    portal = {
      enable = true;
      configPackages = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };

    # Set default terminal in GNOME.
    # terminal-exec = {
    #   enable = true;
    #   settings = {
    #     GNOME = [ "com.mitchellh.ghostty.desktop" ];
    #   };
    # };
  };

  # Enable Bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Enable A2DP profile for modern headsets.
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable multimedia via PipeWire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
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
    ];
  };

  # Enable home manager.
  # See options here https://home-manager-options.extranix.com/?query=&release=release-24.11
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    # Use global nixpkgs config to allow unfree packages.
    useGlobalPkgs = true;
    # Keep the home manager configuration separate.
    users.patrick = import ./home/patrick/home.nix;
  };

  # Shell.
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Enable dynamic linker to execute dynamic binaries.
  # Needed for Zed to download and execute language servers.
  # Needed for pre-commit to execute downloaded git hooks.
  programs.nix-ld.enable = true;

  # Run AppImage files.
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # Gaming.
  # Check Linux compatibility with Proton here: https://www.protondb.com/
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  programs.gamemode.enable = true; # Use 'gamemoderun %command%' in Steam game launch options.
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    usbutils
    vim
    curl
    git
    wl-clipboard
    gcc

    # Playwright
    # Needs to be at system level because the environment variables point to system level as well.
    playwright-test
    playwright-driver
  ];

  # Environment variables.
  # Can't be set per user as the shell is not configured via home-manager.
  environment.sessionVariables = {
    # Enable Wayland for Electron apps.
    NIXOS_OZONE_WL = "1";

    # Set defaults.
    BROWSER = "zen";
    EDITOR = "zeditor";
    GIT_EDITOR = "nvim";

    # Don't show "(.venv)" in shell prompt.
    VIRTUAL_ENV_DISABLE_PROMPT = "1";

    # Playwright.
    PLAYWRIGHT_BROWSERS_PATH = pkgs.playwright-driver.browsers;
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
