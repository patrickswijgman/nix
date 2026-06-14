{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.ghostty;
in
{
  options.modules.ghostty = {
    enable = lib.mkEnableOption "Ghostty terminal emulator";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.ghostty
    ];

    # Set as the default terminal.
    xdg.terminal-exec = {
      enable = true;
      settings = {
        default = [
          "com.mitchellh.ghostty.desktop"
        ];
      };
    };
  };
}
