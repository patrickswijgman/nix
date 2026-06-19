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

  # Enable networking
  networking.hostName = "patrick-swijgman-work";
  networking.networkmanager.enable = true;
  networking.hosts = {
    "127.0.0.1" = [ "localhost" ];
  };

  # Desktop environment.
  modules.sway.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.patrick = {
    isNormalUser = true;
    description = "Patrick";
    useDefaultShell = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  # Browser.
  programs.firefox.enable = true;

  # Modules.
  modules.common.enable = true;
  modules.neovim.enable = true;
  modules.fish.enable = true;
  modules.dev.enable = true;

  # Bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # Docker.
  virtualisation.docker.enable = true;

  # Firmware updates.
  services.fwupd.enable = true;

  # Run AppImage files.
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  environment.systemPackages = with pkgs; [
    # Work apps
    slack
    openvpn
  ];

  # System-wide environment variables.
  environment.sessionVariables = {
    # Don't show "(.venv)" in shell prompt.
    # VIRTUAL_ENV_DISABLE_PROMPT = "1";
  };

  system.stateVersion = "25.11";
}
