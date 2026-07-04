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

  # Make monitor show up as a backlight device so that can be
  # controlled via e.g. brightnessctl.
  boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
  boot.kernelModules = [ "ddcci_backlight" ];

  networking.hostName = "patrick-desktop"; # Define your hostname.

  # Enable Nvidia proprietary driver.
  modules.nvidia.enable = true;

  modules.sway = {
    enable = true;
    useNvidia = true;
  };

  modules.steam.enable = true;

  environment.systemPackages = with pkgs; [
    aseprite
    tiled
  ];

  system.stateVersion = "25.11";
}
