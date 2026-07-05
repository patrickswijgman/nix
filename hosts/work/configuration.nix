{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Full disk encryption.
  boot.initrd.luks.devices."luks-71936e47-c47f-47e7-8c39-c942ace26eb1".device =
    "/dev/disk/by-uuid/71936e47-c47f-47e7-8c39-c942ace26eb1";

  ### Network

  networking.hostName = "patrick-swijgman-work";

  ### Desktop environment

  modules.sway.enable = true;

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

  ### Programs and services

  virtualisation.docker.enable = true;
  users.users.patrick.extraGroups = [ "docker" ];

  services.printing.enable = true;
  services.fwupd.enable = true;

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  environment.systemPackages = with pkgs; [
    slack
    openvpn
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
