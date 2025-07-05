{
  config,
  pkgs,
  inputs,
  ...
}:

let
  lsp-extra = pkgs.callPackage ../../modules/vim/plugins/lsp-extra.nix { };
in
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
        auto-session
        blink-cmp
        catppuccin-nvim
        conform-nvim
        leap-nvim
        lsp-extra
        lualine-nvim
        nvim-autopairs
        nvim-lspconfig
        nvim-spider
        nvim-surround
        nvim-treesitter.withAllGrammars
        nvim-web-devicons
        telescope-nvim
      ];
    };

    # Terminal
    programs.ghostty.enable = true;

    # Packages (that don't have a 'programs.<package>' option).
    home.packages = with pkgs; [
      # Shell
      oh-my-posh

      # CLI
      chezmoi
      fzf
      ripgrep
      fd
      tree
      openvpn
      bat
      dive
      httpie
      presenterm
      npm-check-updates

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
      biome

      go

      rustc
      cargo
      rust-analyzer
      rustfmt

      python3
      pyright
      ruff

      taplo
      yaml-language-server
      vscode-json-languageserver

      codebook

      # Music
      guitarix
      helvum
      qjackctl

      # Desktop apps
      gnome-tweaks
      aseprite
    ];

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
