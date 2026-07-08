# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Make desktop monitor show up as a backlight device so that
  # it can be controlled with e.g. brightnessctl.
  boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
  boot.kernelModules = [ "ddcci_backlight" ];
  hardware.i2c.enable = true;
  # The monitor's DDC/CI doesn't answer until a few seconds after the NVIDIA i2c
  # adapters register, so ddcci's probe fails (-ENODEV) at boot. Retry attaching
  # ddcci to each NVIDIA adapter until a backlight device shows up; probe rejects
  # the phantom adapters, leaving exactly one ddcci* backlight.
  systemd.services.ddcci-backlight = {
    description = "Attach ddcci to the monitor once DDC/CI responds";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for attempt in $(seq 1 30); do
        for dev in /sys/bus/i2c/devices/i2c-*; do
          case "$(cat "$dev/name" 2>/dev/null)" in
            "NVIDIA i2c"*)
              # Drop any client left over from an earlier failed probe, then
              # recreate it. Creating the client auto-triggers ddcci's probe;
              # it succeeds once the monitor's DDC/CI is answering.
              echo 0x37 > "$dev/delete_device" 2>/dev/null || true
              echo ddcci 0x37 > "$dev/new_device" 2>/dev/null || true
              ;;
          esac
        done
        ls /sys/class/backlight/ddcci* >/dev/null 2>&1 && exit 0
        sleep 2
      done
    '';
  };

  ### Network

  networking.hostName = "patrick-desktop"; # Define your hostname.

  ### Graphics

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # Use Nvidia driver instead of Nouveau.
  hardware.nvidia = {
    # Modesetting is required for Wayland.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the Nvidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  ### Programs and services

  programs.steam.enable = true;
  programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin ];
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    # GUI
    aseprite
    tiled
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
