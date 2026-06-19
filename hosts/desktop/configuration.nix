{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.hostName = "patrick-desktop";
  networking.networkmanager.enable = true;

  # Desktop environment.
  modules.sway.enable = true;
  modules.sway.useNvidia = true;
  modules.nvidia.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.patrick = {
    isNormalUser = true;
    description = "Patrick";
    useDefaultShell = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Browser.
  programs.firefox.enable = true;

  # Modules.
  modules.common.enable = true;
  modules.neovim.enable = true;
  modules.fish.enable = true;
  modules.dev.enable = true;
  modules.steam.enable = true;

  environment.systemPackages = with pkgs; [
    aseprite
    tiled
  ];

  system.stateVersion = "25.11";
}
