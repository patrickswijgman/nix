{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # GUI
    slack

    # CLI
    openvpn
  ];
}
