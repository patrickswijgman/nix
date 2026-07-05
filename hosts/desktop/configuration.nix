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

  ### Desktop environment

  modules.nvidia.enable = true;

  modules.sway = {
    enable = true;
    useNvidia = true;
  };

  ### Programs and services

  modules.steam.enable = true;

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
