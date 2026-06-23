{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "patrick-desktop";

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
