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
  };

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.excludePackages = [ pkgs.xterm ];

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
    services.desktopManager.gnome.extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
    '';

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false;
    };

    xdg.terminal-exec = {
      enable = true;
      settings = {
        default = [ "com.mitchellh.ghostty.desktop" ];
      };
    };

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

    environment.systemPackages = with pkgs; [
      ghostty
    ];

    environment.sessionVariables = {
      # Run Electron apps in Wayland.
      NIXOS_OZONE_WL = "1";
    };
  };
}
