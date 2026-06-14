{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.pomodoro;
in
{
  options.services.pomodoro = {
    enable = lib.mkEnableOption "Pomodoro timer daemon";

    workTime = lib.mkOption {
      type = lib.types.ints.positive;
      default = 30;
      description = "Length of a work interval, in minutes.";
    };

    breakTime = lib.mkOption {
      type = lib.types.ints.positive;
      default = 5;
      description = "Length of a break interval, in minutes.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.pomodoro = {
      description = "Pomodoro timer daemon";

      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.pomodoro}/bin/pomodoro ${toString cfg.workTime} ${toString cfg.breakTime}";
        Restart = "on-failure";
      };
    };
  };
}
