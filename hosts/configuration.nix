# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  pkgs,
  ...
}:

{
  ### Nix

  # Allow unfree packages (e.g. Spotify).
  nixpkgs.config.allowUnfree = true;

  # Enable flakes.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Overlays.
  nixpkgs.overlays = [
    (_: prev: {
      # Pin xdg-desktop-portal-wlr to stable (0.8.2), unstable (0.8.3) freezes when screen sharing.
      xdg-desktop-portal-wlr =
        inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system}.xdg-desktop-portal-wlr;

      creek = prev.creek.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ../patches/creek-title-style.patch ];
      });

      librewolf = prev.librewolf.override {
        extraPolicies = {
          SearchEngines = {
            Add = [ ];
            Remove = [
              "Google"
              "Bing"
              "Amazon.com"
              "eBay"
              "Twitter"
              "Perplexity"
              "Wikipedia (en)"
            ];
          };
          ExtensionSettings = {
            "moz-addon-prod@7tv.app" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/7tv-extension/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        };
      };
    })
  ];

  ### Network

  networking.networkmanager.enable = true;

  ### Locales

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

  ### Users

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.patrick = {
    isNormalUser = true;
    description = "Patrick";
    useDefaultShell = true;
    extraGroups = [
      "networkmanager"
      "video"
      "wheel"
    ];
  };

  ### Desktop environment (River)

  programs.river-classic = {
    enable = true;
    xwayland.enable = true;
    # Don't install the default packages.
    extraPackages = [ ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };

  xdg = {
    portal = {
      enable = true;
      config = {
        river = {
          # Auto-select backends as before, but disable the D-Bus Inhibit portal
          # so Firefox falls back to the wayland idle-inhibit protocol (which
          # river honors); the gtk portal's inhibit is a no-op for swayidle.
          default = "*";
          "org.freedesktop.impl.portal.Inhibit" = "none";
        };
      };
      wlr = {
        enable = true;
        settings = {
          screencast = {
            # Having a chooser seems to result in a "No permission" error in Firefox.
            chooser_type = "none";
            max_fps = 30;
          };
        };
      };
      extraPortals = with pkgs; [
        # Fallback to GTK portal in case Wayland portal does not support something, e.g. file chooser dialog.
        xdg-desktop-portal-gtk
      ];
    };
    terminal-exec = {
      enable = true;
      settings = {
        # Default terminal when executing .desktop files (e.g. drun).
        default = [ "foot.desktop" ];
      };
    };
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };

  ### Programs and services

  # Shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Editor
  programs.neovim =
    let
      # Symlink treesitter parsers (*.so) and its queries (*.scm) into one dir so the
      # builtin Neovim treesitter picks them up. The plugin's queries have fixes over the Neovim bundled ones.
      treesitter = pkgs.symlinkJoin {
        name = "treesitter";
        paths =
          (builtins.filter pkgs.lib.isDerivation (
            builtins.attrValues pkgs.vimPlugins.nvim-treesitter-parsers
          ))
          ++ (builtins.filter pkgs.lib.isDerivation (
            builtins.attrValues pkgs.vimPlugins.nvim-treesitter.passthru.queries
          ));
      };
    in
    {
      enable = true;
      defaultEditor = true;
      runtime = {
        "parser".source = "${treesitter}/parser";
        "queries".source = "${treesitter}/queries";
      };
    };

  # Needed for Zed to download and start language servers.
  # Needed for pre-commit to execute downloaded git hooks.
  # Needed for binaries installed in node_modules with npm, e.g. Biome.
  programs.nix-ld.enable = true;

  environment.systemPackages =
    let
      cssmodules-language-server = pkgs.callPackage ../pkgs/cssmodules-language-server.nix { };
      swayline = inputs.swayline.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    with pkgs;
    [
      # GUI
      librewolf
      chromium
      spotify
      gimp

      # CLI
      git
      curl
      fd
      fzf
      ripgrep
      tree
      keychain
      wl-clipboard
      jq # needed for claude statusline
      gcc # needed for pre-commit hooks

      ### Dev

      # Web
      nodejs_24
      vtsls
      typescript-language-server # needed for claude code LSP
      vscode-css-languageserver
      cssmodules-language-server
      emmet-language-server

      # Go
      go_1_25
      gopls
      golangci-lint
      golangci-lint-langserver

      # Python
      python314
      python314Packages.python-lsp-server
      ruff
      uv

      # Lua
      lua
      lua-language-server
      stylua

      # Nix
      nixd
      nixfmt

      # Fish
      fish-lsp

      # AI
      claude-code

      # Other
      codebook
      prettierd
      taplo
      vscode-json-languageserver
      yaml-language-server

      ### Desktop (River)

      adwaita-icon-theme
      brightnessctl
      creek
      foot
      gammastep
      grim
      kanshi
      libnotify
      mako
      pamixer
      playerctl
      slurp
      still
      swaybg
      swayidle
      swayline
      swaylock
      tofi
      wlopm
    ];

  ### Environment

  environment.sessionVariables = {
    # Needed for dbus environment variables so that the desktop portal config for river is used.
    XDG_CURRENT_DESKTOP = "river";

    # Disable builtin virtual env segment in Fish prompt.
    VIRTUAL_ENV_DISABLE_PROMPT = "1";

    # Run Electron apps in Wayland.
    NIXOS_OZONE_WL = "1";

    # Default terminal for launchers.
    TERMINAL = "foot";
  };
}
