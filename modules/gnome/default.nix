{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.gnome;
in
{
  options.gnome.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "GNOME desktop environment";
  };

  config = lib.mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.xserver.excludePackages = [ pkgs.xterm ];

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
      gnome-clocks
      gnome-connections
      gnome-console
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
    };

    # System-wide packages.
    environment.systemPackages = with pkgs; [
      wl-clipboard
    ];

    # System-wide environment variables.
    environment.sessionVariables = {
      # Enable Wayland for Electron apps.
      NIXOS_OZONE_WL = "1";
    };
  };
}
