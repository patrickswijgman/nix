{ pkgs, ... }:

{
  services.kanshi = {
    settings = [
      {
        profile.name = "desktop";
        profile.outputs = [
          {
            criteria = "AOC Q24G4 VH0R7HA002360";
            mode = "2560x1440@180.00Hz";
          }
        ];
      }
    ];
  };

  home.packages = with pkgs; [
    # GUI
    aseprite
    tiled
  ];
}
