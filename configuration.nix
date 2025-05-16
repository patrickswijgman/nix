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
  zen-browser = inputs.zen-browser.packages.${pkgs.system}.default;
in
{
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
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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
    terminal-exec = {
      enable = true;
      settings = {
        GNOME = [ "com.mitchellh.ghostty.desktop" ];
      };
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
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.patrick = {
    isNormalUser = true;
    description = "Patrick";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ];
  };

  # Shell.
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Enable dynamic linker to execute dynamic binaries.
  # Needed for Zed to download and execute language servers.
  # Needed for pre-commit to execute downloaded git hooks.
  programs.nix-ld.enable = true;

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    # Core
    usbutils
    vim
    curl
    git
    wl-clipboard
    gcc

    # Fonts
    nerd-fonts.zed-mono

    # Browsers
    zen-browser
    chromium

    # Terminal
    ghostty

    # Shell
    oh-my-posh

    # Editors
    zed-editor
    neovim

    # CLI
    chezmoi
    fzf
    ripgrep
    fd
    tree
    openvpn
    bat
    dive
    httpie
    btop
    presenterm
    npm-check-updates
    appimage-run

    # Terminal apps
    lazygit
    lazydocker

    # Programming
    nixd
    nixfmt-rfc-style
    nodejs_22
    go
    python3

    # Desktop apps
    gnome-tweaks
    aseprite
    discord
    guitarix
    helvum

    # Gaming
    protonup
    lutris
  ];

  # Gaming.
  # Check Linux compatibility with Proton here: https://www.protondb.com/
  # Use `protonup` to download the latest Proton GE version. Set in compatibility settings.
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true; # Use 'gamemoderun %command%' in Steam game launch options.

  # Enable OpenGL.
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Environment variables.
  environment.sessionVariables = {
    # Set defaults.
    BROWSER = "zen";
    TERMINAL = "ghostty";
    EDITOR = "zeditor";
    GIT_EDITOR = "nvim";

    # Don't show "(.venv)" in shell prompt.
    VIRTUAL_ENV_DISABLE_PROMPT = "1";

    # Enable Wayland for Electron apps.
    NIXOS_OZONE_WL = "1";

    # Enable Proton GE for Steam.
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/patrick/.steam/root/compatibilitytools.d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
