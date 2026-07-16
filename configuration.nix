# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  ### Nix

  # Allow unfree packages (e.g. Spotify).
  nixpkgs.config.allowUnfree = true;

  # Allow insecure packages.
  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-9.15.9" # needed for stylelint
  ];

  # Enable flakes.
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

  ### Home manager

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.patrick.imports = [ ./home.nix ];
  };

  ### Desktop environment

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Configure keymap in X11.
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable the GNOME Desktop Environment (with fractional scaling support).
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Auto login.
  services.displayManager.autoLogin = {
    enable = true;
    user = "patrick";
  };

  # Remove unused GNOME default software.
  environment.gnome.excludePackages = with pkgs; [
    # baobab
    decibels
    epiphany
    geary
    # gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-connections
    gnome-console
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-system-monitor
    gnome-text-editor
    gnome-tour
    gnome-weather
    # loupe
    # nautilus
    # papers
    showtime
    simple-scan
    snapshot
    yelp
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };

  ### Programs and services

  # Shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Needed for Zed to download and start language servers.
  # Needed for pre-commit to execute downloaded git hooks.
  # Needed for binaries installed in node_modules with npm, e.g. Biome.
  programs.nix-ld.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
