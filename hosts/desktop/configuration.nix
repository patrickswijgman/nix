# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
