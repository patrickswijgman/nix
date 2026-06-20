{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "patrick-desktop";
  networking.networkmanager.enable = true;

  users.users.patrick = {
    isNormalUser = true;
    description = "Patrick";
    useDefaultShell = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  modules.common.enable = true;
  modules.sway.enable = true;
  modules.sway.useNvidia = true;
  modules.nvidia.enable = true;
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
