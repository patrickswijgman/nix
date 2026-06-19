{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.sway;
  swayline = pkgs.callPackage ../pkgs/swayline.nix { };
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
    };

    # Enable the gnome-keyring secrets vault.
    # Will be exposed through DBus to programs willing to store secrets.
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;

    # Enable Pipewire for multimedia (screen sharing and audio).
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false;
    };

    # Enable desktop portal for screen sharing.
    # Also requires pipewire to be enabled.
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };

    # Set Alacritty as the default terminal.
    xdg.terminal-exec = {
      enable = true;
      settings = {
        default = [ "Alacritty.desktop" ];
      };
    };

    # Install and set default fonts.
    fonts = {
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
      fontconfig = {
        defaultFonts = {
          monospace = [ "JetBrainsMono Nerd Font" ];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      adwaita-icon-theme # mouse cursor and icons
      alacritty
      brightnessctl
      playerctl
      pamixer
      grim
      slurp
      still
      mako
      kanshi
      swayidle
      swaylock
      swayline
      pomodoro
      wl-clipboard
    ];

    environment.sessionVariables = {
      # Run Electron apps in Wayland.
      NIXOS_OZONE_WL = "1";
    };
  };
}
