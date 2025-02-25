# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-48be1776-f83e-4539-907c-eaf00884fa7e".device =
    "/dev/disk/by-uuid/48be1776-f83e-4539-907c-eaf00884fa7e";

  # Hostname.
  networking.hostName = "patrick-work";
}
