# Gaming: Steam with Proton-GE and GameMode.

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.gaming;
in
{
  options.modules.gaming = {
    enable = lib.mkEnableOption "Steam and gaming tweaks";
  };

  config = lib.mkIf cfg.enable {
    programs.steam.enable = true;
    programs.steam.extraCompatPackages = with pkgs; [ proton-ge-bin ];
    programs.gamemode.enable = true;
  };
}
