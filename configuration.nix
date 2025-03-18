# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Enable flakes.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree packages such as Spotify.
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
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Ensure gnome-settings-daemon udev rules are enabled for gnomeExtensions.appindicator.
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  # Enable screen sharing in Wayland.
  xdg = {
    portal = {
      enable = true;
      configPackages = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
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
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.patrick = {
    isNormalUser = true;
    description = "Patrick";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker" # Provide access to the Docker socket.
    ];
  };

  # Enable home manager.
  # See options here https://home-manager-options.extranix.com/?query=&release=release-24.11
  home-manager = {
    # Use global nixpkgs config to allow unfree packages.
    useGlobalPkgs = true;

    # Keep the home manager configuration separate.
    users.patrick = import ./home/patrick/home.nix;
  };

  # Shell.
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Docker.
  virtualisation.docker.enable = true;

  # Enable dynamic linker to execute dynamic binaries.
  # Needed for pre-commit to execute git hooks.
  # Needed for Zed to download and execute language servers.
  programs.nix-ld.enable = true;

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    vim
    curl
    git
    wl-clipboard
    gcc

    # GNOME
    gnomeExtensions.appindicator
  ];

  # Environment variables.
  environment.sessionVariables = {
    # Set default editor.
    EDITOR = "nvim";
    GIT_EDITOR = "nvim";

    # Don't show "(.venv)" in shell prompt.
    VIRTUAL_ENV_DISABLE_PROMPT = "1";

    # Enable Wayland for Electron apps.
    NIXOS_OZONE_WL = "1";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
