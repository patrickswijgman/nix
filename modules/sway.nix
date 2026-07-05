{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.sway;
  swayline = inputs.swayline.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  options.modules.sway = {
    enable = lib.mkEnableOption "Sway desktop environment";

    useNvidia = lib.mkOption {
      type = lib.types.bool;
      default = false;
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

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false;
    };

    xdg = {
      portal = {
        enable = true;
        wlr = {
          enable = true;
          settings = {
            screencast = {
              chooser_type = "none";
            };
          };
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
      };
      terminal-exec = {
        enable = true;
        settings = {
          default = [ "Alacritty.desktop" ];
        };
      };
    };

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
      adwaita-icon-theme
      alacritty
      brightnessctl
      foot
      gammastep
      grim
      kanshi
      mako
      pamixer
      playerctl
      pomodoro
      slurp
      still
      swayidle
      swayline
      swaylock
      tofi
      wl-clipboard
      libnotify # used by Foot for desktop notifications
    ];

    environment.sessionVariables = {
      # Run Electron apps in Wayland.
      NIXOS_OZONE_WL = "1";

      # Default terminal for launchers.
      TERMINAL = "alacritty -e";
    };
  };
}
