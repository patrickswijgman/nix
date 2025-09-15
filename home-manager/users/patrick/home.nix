{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home-manager.users.patrick = {
    # Load home-manager modules.
    imports = [
      inputs.zen-browser.homeModules.beta
    ];

    # Home Manager needs a bit of information about you and the paths it should manage.
    home.username = "patrick";
    home.homeDirectory = "/home/patrick";

    # Browsers
    programs.zen-browser.enable = true;
    programs.chromium.enable = true;

    # Editor
    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        actions-preview-nvim
        blink-cmp
        conform-nvim
        copilot-lua
        leap-nvim
        lualine-nvim
        nvim-autopairs
        nvim-lspconfig
        nvim-spectre
        nvim-spider
        nvim-surround
        nvim-tree-lua
        nvim-treesitter.withAllGrammars
        nvim-various-textobjs
        nvim-web-devicons
        telescope-nvim
        vague-nvim
        zen-mode-nvim
      ];
    };

    # Terminal
    programs.ghostty.enable = true;

    # Packages (that don't have a 'programs.<package>' option).
    home.packages = with pkgs; [
      # CLI
      chezmoi
      fzf
      ripgrep
      fd
      tree
      openvpn
      bat
      dive # Docker image inspection
      httpie # REST API tool
      presenterm
      npm-check-updates
      jq # pretty format JSON string
      htop
      copier # project templating tool

      # Shell
      oh-my-posh
      babelfish

      # Terminal apps
      lazygit
      lazydocker

      # Programming
      nixd
      nixfmt-rfc-style

      lua-language-server
      stylua

      nodejs_22
      vtsls
      prettierd
      tailwindcss-language-server

      go
      gopls

      rustc
      cargo
      rust-analyzer
      rustfmt

      python3
      pyright
      ruff
      uv

      flutter332

      taplo
      yaml-language-server
      vscode-json-languageserver

      codebook
      simple-completion-language-server

      # AI
      claude-code

      # Music
      guitarix
      tonelib-metal
      tonelib-gfx
      helvum
      qjackctl

      # Desktop apps
      gnome-tweaks
      aseprite

      # GNOME Extensions
      gnomeExtensions.pip-on-top
    ];

    # Environment variables.
    # These need to be loaded in the shell, e.g. fish.
    home.sessionVariables = {
      # Set defaults.
      EDITOR = "vim";
      GIT_EDITOR = "vim";

      # Don't show "(.venv)" in shell prompt.
      VIRTUAL_ENV_DISABLE_PROMPT = "1";

      # Playwright.
      # PLAYWRIGHT_BROWSERS_PATH = pkgs.playwright-driver.browsers;
      # PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
      # PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    };

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.patrick = {
    isNormalUser = true;
    description = "Patrick";
    useDefaultShell = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "realtime"
      "docker"
    ];
  };

  # Shell.
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Set default terminal in GNOME.
  xdg = {
    terminal-exec = {
      enable = true;
      settings = {
        GNOME = [ "com.mitchellh.ghostty.desktop" ];
      };
    };
  };
}
