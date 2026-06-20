{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.common;
in
{
  options.modules.common = {
    enable = lib.mkEnableOption "Common packages and system configuration";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    time.timeZone = "Europe/Amsterdam";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
      btop
      fd
      fzf
      gimp
      git
      jq
      ripgrep
      spotify
      tree
      wl-clipboard
    ];

    environment.sessionVariables = {
      # Don't show "(.venv)" in shell prompt.
      VIRTUAL_ENV_DISABLE_PROMPT = "1";
    };
  };
}
