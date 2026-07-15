{ pkgs, ... }:

{
  # Modules
  imports = [
    ./modules/dconf
  ];

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
    };
    policies = {
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

  # Terminal
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    systemd.enable = true;
    settings = {
      theme = "Vague";
      mouse-scroll-multiplier = 2;
      keybind = [
        "ctrl+shift+h=previous_tab"
        "ctrl+shift+l=next_tab"

        "ctrl+alt+h=goto_split:left"
        "ctrl+alt+j=goto_split:down"
        "ctrl+alt+k=goto_split:up"
        "ctrl+alt+l=goto_split:right"

        "ctrl+alt+shift+h=new_split:left"
        "ctrl+alt+shift+j=new_split:down"
        "ctrl+alt+shift+k=new_split:up"
        "ctrl+alt+shift+l=new_split:right"

        "ctrl+tab=unbind"
        "ctrl+shift+o=unbind"
        "ctrl+shift+e=unbind"
      ];
    };
  };

  # Shell
  programs.fish = {
    enable = true;
    functions = {
      fish_prompt.body = builtins.readFile ./modules/fish/functions/fish_prompt.fish;
    };
    shellInit = builtins.readFile ./modules/fish/config.fish;
  };

  # Tools
  programs.git = {
    enable = true;
    settings = {
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

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Packages (these don't have a programs option or override my configuration file by force).
  home.packages =
    let
      cssmodules-language-server = pkgs.callPackage ./pkgs/cssmodules-language-server.nix { };
    in
    with pkgs;
    [
      # GUI
      spotify
      gimp

      # TUI
      neovim

      # CLI
      curl
      fd
      ripgrep
      tree
      wl-clipboard
      dconf2nix
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
    ];

  ### XDG configuration

  # Default apps
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

  home.sessionVariables =
    let
      treesitter = pkgs.callPackage ./pkgs/treesitter.nix { };
    in
    {
      # Default editor.
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";

      # Treesitter parsers and queries for Neovim.
      TREESITTER_PATH = "${treesitter}";

      # Disable builtin virtual env segment in Fish prompt.
      VIRTUAL_ENV_DISABLE_PROMPT = "1";
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
