# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  ### Boot

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Full disk encryption
  boot.initrd.luks.devices."luks-71936e47-c47f-47e7-8c39-c942ace26eb1".device =
    "/dev/disk/by-uuid/71936e47-c47f-47e7-8c39-c942ace26eb1";

  ### Network

  networking.hostName = "patrick-swijgman-work";

  ### Bluetooth

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  ### Home manager

  home-manager.users.patrick.imports = [ ../../home/hosts/work/home.nix ];

  ### Programs and services

  virtualisation.docker.enable = true;
  users.users.patrick.extraGroups = [ "docker" ];

  services.printing.enable = true;
  services.fwupd.enable = true;

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
}
