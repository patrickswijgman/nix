# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  ...
}:

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

  # Docker.
  virtualisation.docker.enable = true;
  users.users.patrick.extraGroups = [ "docker" ];

  # Firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [
      3000
      5050
    ];
  };

  # WebHID devices.
  services.udev.extraRules = ''
    ATTRS{idVendor}=="1395", ATTRS{idProduct}=="0298", MODE="0666"
    ATTRS{idVendor}=="1395", ATTRS{idProduct}=="00a9", MODE="0666"
    ATTRS{idVendor}=="6993", ATTRS{idProduct}=="b017", MODE="0666"
  '';
}
