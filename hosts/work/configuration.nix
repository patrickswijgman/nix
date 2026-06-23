{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-71936e47-c47f-47e7-8c39-c942ace26eb1".device =
    "/dev/disk/by-uuid/71936e47-c47f-47e7-8c39-c942ace26eb1";

  networking.hostName = "patrick-swijgman-work";
  users.users.patrick.extraGroups = [ "docker" ];

  modules.sway.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  virtualisation.docker.enable = true;

  services.printing.enable = true;
  services.fwupd.enable = true;

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  environment.systemPackages = with pkgs; [
    slack
    openvpn
  ];

  system.stateVersion = "25.11";
}
