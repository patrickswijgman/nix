{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.veila.homeModules.default
    inputs.noctalia.homeModules.default
  ];

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "patrick";
  home.homeDirectory = "/home/patrick";

  # Allow unfree packages (e.g. spotify).
  nixpkgs.config.allowUnfree = true;

  # Nix User Repositories.
  # Needed for Firefox/Librewolf addons.
  nixpkgs.overlays = [ inputs.nur.overlays.default ];

  # Browser
  programs.librewolf = {
    enable = true;
    profiles = {
      patrick = {
        name = "Patrick";
        isDefault = true;
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
          "privacy.fingerprintingProtection" = true;
          "privacy.fingerprintingProtection.overrides" = "+AllTargets,-JSDateTimeUTC";
          "privacy.resistFingerprinting" = false;
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "sidebar.visibility" = "hide-sidebar";
        };
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          seventv
          bitwarden
        ];
        search = {
          force = true;
          default = "ddg";
          engines = { };
        };
      };
    };
    policies = {
      ExtensionSettings = {
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
        birb-nvim = pkgs.callPackage ./modules/neovim/plugins/birb-nvim.nix { };
        bulb-nvim = pkgs.callPackage ./modules/neovim/plugins/bulb-nvim.nix { };
        butter-nvim = pkgs.callPackage ./modules/neovim/plugins/butter-nvim.nix { };
      in
      with pkgs.vimPlugins;
      [
        birb-nvim
        bufdelete-nvim
        bulb-nvim
        butter-nvim
        conform-nvim
        lualine-nvim
        nvim-autopairs
        nvim-lspconfig
        nvim-surround
        nvim-treesitter.withAllGrammars
        nvim-web-devicons
        scope-nvim
        telescope-fzf-native-nvim
        telescope-nvim
        telescope-ui-select-nvim
        vague-nvim
      ];
  };

  # Terminal
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        include = "${./modules/foot/themes/vague.ini}";
        font = "monospace:size=12";
        pad = "10x5 center";
      };
      scrollback = {
        indicator-position = "none";
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
      hyperfocus = {
        description = "Show a break time notification";
        body = builtins.readFile ./modules/fish/functions/hyperfocus.fish;
      };
    };
    shellInit = ''
      set fish_greeting
    '';
    shellAbbrs = {
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
      "--color=fg:#cdcdcd"
      "--color=bg:#141415"
      "--color=hl:#f3be7c"
      "--color=fg+:#aeaed1"
      "--color=bg+:#252530"
      "--color=hl+:#f3be7c"
      "--color=border:#606079"
      "--color=header:#6e94b2"
      "--color=gutter:#141415"
      "--color=spinner:#7fa563"
      "--color=info:#f3be7c"
      "--color=pointer:#aeaed1"
      "--color=marker:#d8647e"
      "--color=prompt:#bb9dbd"
    ];
  };

  programs.btop = {
    enable = true;
    themes = {
      vague = builtins.readFile ./modules/btop/themes/vague.theme;
    };
    settings = {
      color_theme = "vague";
    };
  };

  programs.bat = {
    enable = true;
    themes = {
      vague = {
        file = "vague.tmTheme";
        src = ./modules/bat/themes;
      };
    };
    config = {
      theme = "vague";
    };
  };

  # Desktop environment
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    extraConfig = builtins.readFile ./modules/hyprland/hyprland.lua;
  };

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      shell = {
        launch_apps_as_systemd_services = true;
        animation = {
          speed = 0.67;
        };
      };
      osd = {
        position = "bottom_center";
      };
      bar = {
        main = {
          enabled = false;
        };
      };
      notification = {
        layer = "overlay";
      };
      theme = {
        mode = "dark";
        source = "wallpaper";
        wallpaper_scheme = "m3-monochrome";
      };
      wallpaper = {
        enabled = true;
        default.path = "${./wallpapers/giethoorn.jpg}";
      };
    };
  };

  programs.veila = {
    enable = true;
    service.enable = true;
    settings = {
      theme = "normandy";
      background = {
        mode = "file";
        path = "${./wallpapers/giethoorn.jpg}";
      };
      lock = {
        screen_off_seconds = 30;
        suspend_seconds = 300;
        suspend_only_on_battery = true;
      };
    };
    idle = {
      enable = true;
      lockAfter = 180;
      lockBeforeSleep = true;
    };
  };

  services.kanshi = {
    enable = true;
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
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
    noto-fonts-color-emoji
    noto-fonts

    # GUI
    spotify
    gimp

    # CLI
    curl
    fd
    ripgrep
    tree
    wl-clipboard
    libnotify
    jq # needed for claude statusline
    gcc # needed for pre-commit hooks

    ### Dev

    # Web
    nodejs_24
    vtsls
    typescript-language-server # needed for claude code LSP
    vscode-css-languageserver
    vscode-json-languageserver

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

    # SVG loader for GTK app icons.
    GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
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
