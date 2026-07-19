{
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    inputs.stylix.homeModules.stylix
    inputs.veila.homeModules.default
  ];

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "patrick";
  home.homeDirectory = "/home/patrick";

  # Allow unfree packages (e.g. spotify).
  nixpkgs.config.allowUnfree = true;

  # Allow insecure packages.
  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-9.15.9" # needed for stylelint
  ];

  # Browser
  programs.librewolf = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
      };
    };
    settings = {
      "browser.ctrlTab.sortByRecentlyUsed" = true;
      "browser.startup.page" = 3;
      "browser.toolbars.bookmarks.visibility" = "never";
      "browser.translations.enable" = false;
      "browser.uiCustomization.state" = builtins.readFile ./modules/librewolf/toolbar.json;
      "devtools.theme" = "dark";
      "network.cookie.lifetimePolicy" = 0;
      "privacy.clearOnShutdown_v2.cache" = true;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      "privacy.clearOnShutdown_v2.history" = false;
      "privacy.sanitize.sanitizeOnShutdown" = true;
      "sidebar.visibility" = "hide-sidebar";
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
    policies = {
      SearchEngines = {
        Add = [ ];
        Remove = [
          "Amazon.com"
          "Bing"
          "Google"
          "Perplexity"
          "Twitter"
          "Wikipedia (en)"
          "eBay"
        ];
      };
      ExtensionSettings = {
        "moz-addon-prod@7tv.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/7tv-extension/latest.xpi";
          installation_mode = "normal_installed";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "normal_installed";
        };
        "nl-NL@dictionaries.addons.mozilla.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/woordenboek-nederlands/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
    };
  };

  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform-hint=auto"
    ];
  };

  # Editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    initLua = builtins.readFile ./modules/neovim/init.lua;
    plugins =
      let
        butter-nvim = pkgs.callPackage ./modules/neovim/plugins/butter-nvim.nix { };
      in
      with pkgs.vimPlugins;
      [
        butter-nvim
        conform-nvim
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        nvim-web-devicons
        telescope-nvim
        telescope-fzf-native-nvim
        telescope-ui-select-nvim
      ];
  };

  # Terminal
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        pad = "10x5 center";
      };
    };
  };

  # Shell
  programs.fish = {
    enable = true;
    functions = {
      fish_prompt = {
        description = "Fish prompt";
        body = builtins.readFile ./modules/fish/functions/fish_prompt.fish;
      };
      print_colors = {
        description = "Print the 16 base ANSI colors";
        body = builtins.readFile ./modules/fish/functions/print_colors.fish;
      };
    };
    shellInit = ''
      set fish_greeting
    '';
    shellAbbrs = {
      # Git
      gb = "git branch";
      gc = "git switch";
      ga = "git add";
      gaa = "git add .";
      gs = "git status";
      gst = "git stash";
      gsts = "git stash show";
      gstl = "git stash list";
      gstp = "git stash pop";
      gm = "git commit -m";
      gma = "git commit --amend";
      gman = "git commit --amend --no-edit";
      gf = "git fetch";
      gp = "git pull";
      gP = "git push";
      gl = "git log";
      gd = "git diff";
      gds = "git diff --staged";
      gr = "git rebase -i";
      grc = "git rebase --continue";
      gra = "git rebase --abort";
      grs = "git restore";
      grss = "git restore --staged";
      grsm = "git restore --source origin/main";
      yolo = "git commit --amend --no-edit && git push --force";
      yeet = "git commit --amend --no-edit --no-verify && git push --force --no-verify";

      # Docker
      dc = "docker compose";
      dcu = "docker compose up";
      dcr = "docker compose run --rm";

      # NixOS
      ns = "nix-shell --run fish";
      nc = "sudo nix-collect-garbage";
      nr = "nix run";

      # Virtualenv
      va = "source .venv/bin/activate.fish";
      vd = "source .venv/bin/deactivate.fish";
    };
  };

  # Tools
  programs.git = {
    enable = true;
    settings = {
      core = {
        editor = "nvim";
      };
      pull = {
        rebase = true;
      };
      push = {
        autoSetupRemote = true;
      };
      user = {
        name = "Patrick";
      };
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
      };
      "gitlab.wearespindle.com" = {
        WarnWeakCrypto = "no";
      };
    };
  };

  programs.keychain = {
    enable = true;
    enableFishIntegration = true;
    keys = [ ];
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Desktop environment
  stylix = {
    enable = true;
    image = ./wallpapers/giethoorn.jpg;
    polarity = "dark";
    targets = {
      librewolf = {
        profileNames = [ "default" ];
      };
    };
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    extraConfig = builtins.readFile ./modules/hyprland/hyprland.lua;
  };

  programs.veila = {
    enable = true;
    service.enable = true;
    settings = {
      theme = "seceda";
      background = {
        mode = "file";
        path = ./wallpapers/giethoorn.jpg;
      };
      visuals = {
        clock = {
          font_family = "sans-serif";
        };
        date = {
          font_family = "sans-serif";
        };
        input = {
          font_family = "sans-serif";
        };
        username = {
          font_family = "sans-serif";
        };
        weather = {
          temperature = {
            font_family = "sans-serif";
          };
          location = {
            font_family = "sans-serif";
          };
        };
        now_playing = {
          artist = {
            font_family = "sans-serif";
          };
          title = {
            font_family = "sans-serif";
          };
        };
      };
      lock = {
        screen_off_seconds = 10;
        suspend_seconds = 60;
        suspend_only_on_battery = true;
      };
    };
    idle = {
      enable = true;
      lockAfter = 180;
      lockBeforeSleep = true;
    };
  };

  programs.hyprshot.enable = true;

  services.swaync = {
    enable = true;
    style = lib.mkAfter (builtins.readFile ./modules/swaync/style.css);
  };

  services.hyprsunset = {
    enable = true;
    settings = {
      profile = [
        {
          time = "7:30";
          identity = true;
        }
        {
          time = "20:30";
          temperature = 4500;
          gamma = 0.75;
        }
      ];
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  # Packages (these don't have a programs option or override my configuration file by force).
  home.packages = with pkgs; [
    # GUI
    spotify
    gimp

    # CLI
    curl
    fd
    ripgrep
    tree
    wl-clipboard
    jq # needed for claude statusline
    gcc # needed for pre-commit hooks

    ### Dev

    # Web
    nodejs_24
    vtsls
    typescript-language-server # needed for claude code LSP
    vscode-css-languageserver

    # Go
    go_1_25
    gopls

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

    # Desktop environment
    brightnessctl
    playerctl
    pamixer
    wlopm
  ];

  ### XDG configuration

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "librewolf.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
        "application/xhtml+xml" = "librewolf.desktop";
      };
    };
  };

  ### Environment

  home.sessionVariables = {
    # Disable builtin virtual env segment in Fish prompt.
    VIRTUAL_ENV_DISABLE_PROMPT = "1";

    # Hint Electron apps to use Wayland.
    NIXOS_OZONE_WL = "1";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.05";
}
