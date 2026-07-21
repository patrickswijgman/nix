{ pkgs, ... }:

{
  services.kanshi = {
    settings = [
      {
        profile.name = "laptop";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            scale = 1.0;
          }
        ];
      }
      {
        profile.name = "work-desk-45";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "Dell Inc. DELL U2715H GH85D7C600JL";
            mode = "2560x1440@60.00Hz";
          }
        ];
      }
    ];
  };

  home.packages = with pkgs; [
    # GUI
    slack

    # CLI
    openvpn
  ];
}
