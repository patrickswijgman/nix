{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.veila;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.programs.veila = {
    enable = lib.mkEnableOption "Veila screen locker config file";

    settings = lib.mkOption {
      type = tomlFormat.type;
      default = { };
      description = "Written verbatim as TOML to ~/.config/veila/config.toml.";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."veila/config.toml".source = tomlFormat.generate "veila-config.toml" cfg.settings;
  };
}
