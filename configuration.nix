# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-71936e47-c47f-47e7-8c39-c942ace26eb1".device =
    "/dev/disk/by-uuid/71936e47-c47f-47e7-8c39-c942ace26eb1";
  networking.hostName = "patrick-swijgman-work";

  # Enable networking
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.mutter]
    experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
  '';

  # Remove unused GNOME default software.
  environment.gnome.excludePackages = with pkgs; [
    # baobab
    decibels
    epiphany
    geary
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-connections
    # gnome-console
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.patrick = {
    isNormalUser = true;
    description = "Patrick";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    useDefaultShell = true;
    packages = with pkgs; [
      zed-editor
      chromium
      nodejs_22
      nixd
      nixfmt
    ];
  };

  # Shell.
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Browser.
  programs.firefox.enable = true;

  # Docker.
  virtualisation.docker.enable = true;

  # Use Neovim as terminal editor.
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  # Enable dynamic linker to execute dynamic binaries.
  # Needed for Zed to download execute language servers.
  # Needed for pre-commit to execute downloaded git hooks.
  programs.nix-ld.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
  ];

  # System-wide environment variables.
  environment.sessionVariables = {
    # Don't show "(.venv)" in shell prompt.
    VIRTUAL_ENV_DISABLE_PROMPT = "1";

    # Run Electron apps in Wayland.
    NIXOS_OZONE_WL = "1";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
