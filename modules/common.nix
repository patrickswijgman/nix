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

    extraUserGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra groups to add to the user.";
    };
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

    users.users.patrick = {
      isNormalUser = true;
      description = "Patrick";
      useDefaultShell = true;
      extraGroups = [
        "networkmanager"
        "video"
        "wheel"
      ]
      ++ cfg.extraUserGroups;
    };

    programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
      spotify
      gimp

      btop

      git
      fd
      fzf
      ripgrep
      tree
      wl-clipboard
    ];

    environment.sessionVariables = {
      FZF_DEFAULT_OPTS_FILE = "/home/patrick/.config/fzf/config";
    };
  };
}
