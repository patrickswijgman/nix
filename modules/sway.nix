{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.sway;
in
{
  options.modules.sway = {
    enable = lib.mkEnableOption "Sway desktop environment";

    useNvidia = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Pass `--unsupported-gpu` to Sway. Required to start on the proprietary
        NVIDIA driver, which wlroots otherwise refuses to run on.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraOptions = lib.optionals cfg.useNvidia [ "--unsupported-gpu" ];
      extraPackages = with pkgs; [
        brightnessctl
        foot
        grim
        mako
        pulseaudio
        slurp
        swayidle
        swaylock
        wl-clipboard
        wmenu
      ];
    };

    # Enable the gnome-keyring secrets vault.
    # Will be exposed through DBus to programs willing to store secrets.
    services.gnome.gnome-keyring.enable = true;

    # Enable desktop portal for screen sharing.
    # Also requires pipewire to be enabled.
    xdg.portal = {
      enable = true;
      wlr.enable = true;
    };

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
