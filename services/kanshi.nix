{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.kanshi;
in
{
  options.services.kanshi.enable = lib.mkEnableOption "Kanshi dynamic display configuration daemon";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kanshi # Provides `kanshictl` for reloading profiles.
    ];

    systemd.user.services.kanshi = {
      description = "Kanshi dynamic display configuration daemon";

      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.kanshi}/bin/kanshi";
        Restart = "on-failure";
      };
    };
  };
}
