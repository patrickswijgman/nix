{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # GUI
    aseprite
    tiled
  ];
}
