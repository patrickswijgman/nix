{ pkgs, ... }:

{
  systemd.user.services.pomodoro = {
    description = "Pomodoro timer daemon";

    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.pomodoro}/bin/pomodoro 30 5";
      Restart = "on-failure";
    };
  };
}
