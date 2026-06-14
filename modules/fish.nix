# Fish shell, set as the default user shell.

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.fish;
in
{
  options.modules.fish = {
    enable = lib.mkEnableOption "Fish shell";
  };

  config = lib.mkIf cfg.enable {
    programs.fish.enable = true;
    users.defaultUserShell = pkgs.fish;
  };
}
