{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.steam;
in
{
  options.modules.steam = {
    enable = lib.mkEnableOption "Steam";
  };

  config = lib.mkIf cfg.enable {
    programs.steam.enable = true;
    programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin ];
    programs.gamemode.enable = true;
  };
}
