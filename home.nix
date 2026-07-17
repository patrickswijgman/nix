{ pkgs, ... }:

{
  imports = [ ./modules/veila ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "patrick";
  home.homeDirectory = "/home/patrick";

  # Browser
  programs.librewolf = {
    enable = true;
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
        font = "monospace:size=12";
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
    interactiveShellInit = ''
      cat ~/.cache/wallust/sequences
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
    defaultOptions = [
      "--color=fg:-1"
      "--color=bg:-1"
      "--color=gutter:0"
      "--color=fg+:-1"
      "--color=bg+:0"
      "--color=hl:4"
      "--color=hl+:4"
      "--color=prompt:5"
      "--color=pointer:1"
      "--color=marker:2"
      "--color=info:8"
      "--color=border:8"
      "--color=header:8"
      "--color=spinner:4"
    ];
  };

  # Desktop environment
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    extraConfig = builtins.readFile ./modules/hyprland/hyprland.lua;
  };

  programs.veila = {
    enable = true;
    settings = {
      theme = "seceda";
      background = {
        mode = "file";
        path = "${./wallpapers/giethoorn.jpg}";
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
    };
  };

  programs.hyprshot.enable = true;

  services.wayle = {
    enable = true;
    settings = {
      general = {
        font-sans = "sans-serif";
        font-mono = "monospace";
      };
      styling = {
        rounding = "md";
        theme-provider = "wallust";
        wallust-palette = "dark16";
        wallust-backend = "wal";
        wallust-colorspace = "labmixed";
      };
      wallpaper = {
        engine-enabled = true;
        monitors = [
          {
            name = "";
            wallpaper = "${./wallpapers/giethoorn.jpg}";
            fit-mode = "fill";
          }
        ];
      };
      bar = {
        location = "top";
        button-variant = "basic";
        button-icon-size = 0.8;
        layout = [
          {
            monitor = "*";
            left = [
              "hyprland-workspaces"
            ];
            center = [
              "window-title"
            ];
            right = [
              "media"
              "idle-inhibit"
              "hyprsunset"
              "bluetooth"
              "network"
              "volume"
              "brightness"
              "battery"
              "clock"
            ];
          }
        ];
      };
      modules = {
        hyprland-workspaces = {
          label-size = 0.8;
          active-color = "red";
        };
        clock = {
          format = "%H:%M";
          icon-color = "accent";
          label-color = "accent";
        };
        media = {
          icon-color = "accent";
          label-color = "accent";
        };
        idle-inhibit = {
          icon-color = "accent";
          label-color = "accent";
        };
        hyprsunset = {
          icon-color = "accent";
          label-color = "accent";
        };
        bluetooth = {
          icon-color = "accent";
          label-color = "accent";
        };
        network = {
          icon-color = "accent";
          label-color = "accent";
        };
        volume = {
          icon-color = "accent";
          label-color = "accent";
        };
        brightness = {
          icon-color = "accent";
          label-color = "accent";
        };
        battery = {
          icon-color = "accent";
          label-color = "accent";
        };
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "veila lock --wait-ready";
        before_sleep_cmd = "veila lock --wait-ready";
        after_sleep_cmd = "wlopm --on '*'";
        inhibit_sleep = 3;
      };
      listener = [
        {
          timeout = 150;
          on-timeout = "wlopm --off '*'";
          on-resume = "wlopm --on '*'";
        }
        {
          timeout = 180;
          on-timeout = "veila lock --wait-ready";
        }
      ];
    };
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

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # Packages (these don't have a programs option or override my configuration file by force).
  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji

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
