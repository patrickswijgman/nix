{
  config,
  pkgs,
  inputs,
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

  # Don't show generations list on boot.
  # Should be able to press any key to show generations list.
  boot.loader.timeout = 0;

  # Encryption.
  boot.initrd.luks.devices."luks-48be1776-f83e-4539-907c-eaf00884fa7e".device =
    "/dev/disk/by-uuid/48be1776-f83e-4539-907c-eaf00884fa7e";

  # Hostname.
  networking.hostName = "patrick-work";

  # Enable Bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Enable A2DP profile for modern headsets.
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Enable dynamic linker to execute dynamic binaries.
  # Needed for pre-commit to execute downloaded git hooks.
  programs.nix-ld.enable = true;

  # Run AppImage files.
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # Firewall.
  networking.firewall = {
    enable = true;
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
