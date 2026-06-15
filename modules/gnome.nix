{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.gnome;
in
{
  options.modules.gnome = {
    enable = lib.mkEnableOption "GNOME desktop environment";

    autoLogin = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "patrick";
      description = "User to automatically log in, or null to disable auto login.";
    };
  };

  config = lib.mkIf cfg.enable {
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
    services.desktopManager.gnome.extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
    '';

    # Auto login.
    services.displayManager.autoLogin = lib.mkIf (cfg.autoLogin != null) {
      enable = true;
      user = cfg.autoLogin;
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

    # Enable pipewire for multimedia (screen sharing and audio).
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false;
    };

    environment.sessionVariables = {
      # Run Electron apps in Wayland.
      NIXOS_OZONE_WL = "1";
    };
  };
}
