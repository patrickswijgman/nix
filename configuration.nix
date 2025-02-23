# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Enable networking.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Enable flakes.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree packages such as Spotify.
  nixpkgs.config.allowUnfree = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable screen sharing in Wayland.
  xdg = {
    portal = {
      enable = true;
      configPackages = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  # Configure keyboard layout.
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable Bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Enable A2DP profile for modern headsets.
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable multimedia via Pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.patrick = {
    isNormalUser = true;
    description = "Patrick";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker" # Provide access to the Docker socket.
    ];
  };

  # Enable home manager.
  home-manager = {
    # Use global nixpkgs config to allow unfree packages.
    useGlobalPkgs = true;

    users.patrick = {
      # Browsers.
      programs.firefox.enable = true;
      programs.chromium.enable = true;

      # Git.
      programs.git.enable = true;

      # Terminal.
      programs.ghostty.enable = true;

      # Editor.
      programs.neovim = {
        enable = true;

        # Search for plugins here https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins+
        plugins = with pkgs.vimPlugins; [
          catppuccin-nvim
          nvim-treesitter.withAllGrammars
          auto-session
          nvim-lspconfig
          conform-nvim
          nvim-cmp
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          cmp-cmdline
          telescope-nvim
          neo-tree-nvim
        ];
      };

      # Packages (that don't have a 'programs.<package>' option).
      home.packages = with pkgs; [
        chezmoi

        fzf
        ripgrep
        tree

        nodejs_22

        nixd
        nixfmt-rfc-style
        taplo
        lua
        lua-language-server
        stylua
        typescript-language-server
        vscode-langservers-extracted
        prettierd
        codespell

        spotify
        slack
      ];

      # Environment variables.
      home.sessionVariables = {
        # Set default editor.
        EDITOR = "nvim";
        GIT_EDITOR = "nvim";

        # Enable Wayland for Electron apps.
        NIXOS_OZONE_WL = "1";
      };

      # Home Manager needs a bit of information about you and the paths it should manage.
      home.username = "patrick";
      home.homeDirectory = "/home/patrick";

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      home.stateVersion = "24.11"; # Please read the comment before changing.
    };
  };

  # Shell.
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Docker.
  virtualisation.docker.enable = true;

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    vim
    curl
    wl-clipboard
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
